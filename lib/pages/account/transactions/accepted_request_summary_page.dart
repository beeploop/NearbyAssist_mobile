import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/models/transaction_qr_code_data.dart';
import 'package:nearby_assist/pages/account/transactions/widget/qr_reader.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:provider/provider.dart';

class AcceptedRequestSummaryPage extends StatefulWidget {
  const AcceptedRequestSummaryPage({
    super.key,
    required this.transaction,
    this.showChatIcon = false,
  });

  final TransactionModel transaction;
  final bool showChatIcon;

  @override
  State<AcceptedRequestSummaryPage> createState() =>
      _AcceptedRequestSummaryPageState();
}

class _AcceptedRequestSummaryPageState
    extends State<AcceptedRequestSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Transaction Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (widget.showChatIcon)
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    'chat',
                    queryParameters: {
                      'recipientId': widget.transaction.vendorId,
                      'recipient': widget.transaction.vendor,
                    },
                  );
                },
                icon: const Icon(CupertinoIcons.ellipses_bubble),
              ),
            const SizedBox(width: 20),
          ],
        ),
        body: buildPadding(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: () {
              _completeTransaction();
            },
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const Text('Complete'),
          ),
        ),
      ),
    );
  }

  Padding buildPadding() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Row(
              children: [
                Text('Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    )),
                const Spacer(),
                _chip(widget.transaction.status),
              ],
            ),
            const Divider(),

            // Vendor information
            const SizedBox(height: 20),
            const Text('Vendor Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Vendor Name:', text: widget.transaction.vendor),
            const Divider(),

            // Client information
            const SizedBox(height: 20),
            const Text('Client Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Client Name:', text: widget.transaction.client),
            const Divider(),

            // Service Price
            const SizedBox(height: 20),
            const Text('Service Information', style: TextStyle(fontSize: 16)),

            // Extras
            const SizedBox(height: 20),
            AutoSizeText(widget.transaction.service.title),
            const SizedBox(height: 10),
            RowTile(
                label: 'Base Rate:',
                text: '₱ ${widget.transaction.service.rate}'),
            const SizedBox(height: 20),
            const AutoSizeText(
              'Extras:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.transaction.extras.map((extra) {
              return RowTile(
                label: extra.title,
                text: '₱ ${extra.price}',
                withLeftPad: true,
              );
            }),
            const SizedBox(height: 20),
            const Divider(),

            // Estimated cost
            const SizedBox(height: 20),
            RowTile(label: 'Total Cost:', text: '₱ ${_calculateTotalCost()}'),

            // Complete Button
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  double _calculateTotalCost() {
    double total = widget.transaction.service.rate;
    for (final extra in widget.transaction.extras) {
      total += extra.price;
    }
    return total;
  }

  void _completeTransaction() async {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        isDismissible: false,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: QrReader(
            onDetect: _onQRDetect,
          ),
        ),
      );
    } catch (error) {
      _onError(error.toString());
    }
  }

  void _onQRDetect(BarcodeCapture capture) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      final requestProvider = context.read<TransactionProvider>();

      Navigator.pop(context); // Called to close the dialog for the camera

      final detectedValue = capture.barcodes.first.rawValue;
      if (detectedValue == null) {
        throw 'Error scanning QR';
      }

      final data = TransactionQrCodeData.fromJson(jsonDecode(detectedValue));

      // call the server to verify the QR code signature
      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.qrVerifySignature,
        data: data.toJson(),
      );

      // call the server to complete the transaction
      await api.dio
          .post('${endpoint.completeTransaction}/${data.transactionId}');

      requestProvider.removeRequestFromAccepted(widget.transaction.id);
      _onSuccess();
    } on DioException catch (error) {
      _onError(error.response?.data);
    } catch (error) {
      _onError('Invalid QR');
    } finally {
      loader.hide();
    }
  }

  void _onSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Successful'),
          content: const Text('Transaction complete'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Failed'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _chip(String label) {
    Color color;
    switch (label.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.teal;
        break;
      case 'done':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
