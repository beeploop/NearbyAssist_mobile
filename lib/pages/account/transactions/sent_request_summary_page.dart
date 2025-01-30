import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/transaction_qr_code_data.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SentRequestSummaryPage extends StatefulWidget {
  const SentRequestSummaryPage({
    super.key,
    required this.transaction,
    this.showChatIcon = false,
  });

  final BookingModel transaction;
  final bool showChatIcon;

  @override
  State<SentRequestSummaryPage> createState() => _SentRequestSummaryPageState();
}

class _SentRequestSummaryPageState extends State<SentRequestSummaryPage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return Scaffold(
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
      body: FutureBuilder(
        future: _getTransactionSignature(widget.transaction),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: AlertDialog(
                icon: Icon(CupertinoIcons.exclamationmark_triangle),
                title: Text('Something went wrong'),
                content: Text(
                  'An error occurred while fetching data for this page, try again later',
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const Text('Vendor Information',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  RowTile(
                      label: 'Vendor Name:', text: widget.transaction.vendor),
                  const Divider(),

                  // Client information
                  const SizedBox(height: 20),
                  const Text('Client Information',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  RowTile(label: 'Client Name:', text: user.name),
                  const Divider(),

                  // Service Price
                  const SizedBox(height: 20),
                  const Text('Service Information',
                      style: TextStyle(fontSize: 16)),

                  // Extras
                  const SizedBox(height: 20),
                  Text(
                    widget.transaction.service.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  RowTile(
                      label: 'Base Rate:',
                      text: '₱ ${widget.transaction.service.rate}'),
                  const SizedBox(height: 20),
                  const Text(
                    'Extras:',
                    style: TextStyle(
                      fontSize: 18,
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
                  RowTile(
                      label: 'Total Cost:', text: '₱ ${_calculateTotalCost()}'),
                  const SizedBox(height: 20),

                  // Cancel Button
                  const SizedBox(height: 20),
                  if (widget.transaction.status.toLowerCase() == 'pending')
                    FilledButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            icon: const Icon(
                              CupertinoIcons.question_circle,
                              color: Colors.red,
                              size: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: const Text('Are you sure?'),
                            content: const Text(
                              'This action is not reversible.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                  _cancelTransaction();
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        minimumSize:
                            WidgetStatePropertyAll(Size.fromHeight(50)),
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      child: const Text('Cancel'),
                    ),

                  // QR Code to scan for completing the transaction
                  if (widget.transaction.status.toLowerCase() == 'confirmed')
                    const Text(
                      'Show this QR to the vendor to complete this transaction',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                  if (widget.transaction.status.toLowerCase() == 'confirmed')
                    _displayQR(widget.transaction, snapshot.data!),

                  // For padding the bottom
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
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

  Widget _displayQR(BookingModel transaction, String signature) {
    final data = TransactionQrCodeData(
      clientId: transaction.clientId,
      vendorId: transaction.vendorId,
      transactionId: transaction.id,
      signature: signature,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QrImageView(
          data: jsonEncode(data.toJson()),
          version: QrVersions.auto,
          size: 250,
          eyeStyle: QrEyeStyle(
            color: Colors.green.shade900,
          ),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: Colors.green.shade900,
          ),
          embeddedImage: const AssetImage('assets/icon/icon.png'),
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(20, 20),
          ),
        ),
      ],
    );
  }

  void _cancelTransaction() async {
    try {
      await context
          .read<TransactionProvider>()
          .cancelTransactionRequest(widget.transaction.id);

      _onSuccess();
    } catch (error) {
      _onError(error.toString());
    }
  }

  Future<String> _getTransactionSignature(BookingModel transaction) async {
    if (transaction.status.toLowerCase() != 'confirmed') {
      return '';
    }

    try {
      final data = TransactionQrCodeData(
        clientId: transaction.clientId,
        vendorId: transaction.vendorId,
        transactionId: transaction.id,
        signature: '',
      );

      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.qrSignature,
        data: data.toJsonNoSignature(),
      );

      return response.data['signature'];
    } catch (error) {
      rethrow;
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
          content:
              const Text('You successfully cancelled your booking request'),
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
