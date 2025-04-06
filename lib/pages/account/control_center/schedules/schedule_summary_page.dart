import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/pages/account/control_center/widget/qr_reader/qr_reader.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:provider/provider.dart';

class ScheduleSummaryPage extends StatefulWidget {
  const ScheduleSummaryPage({
    super.key,
    required this.booking,
    this.showChatIcon = false,
  });

  final BookingModel booking;
  final bool showChatIcon;

  @override
  State<ScheduleSummaryPage> createState() => _ScheduleSummaryPageState();
}

class _ScheduleSummaryPageState extends State<ScheduleSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Booking Summary',
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
                      'recipientId': widget.booking.vendor.id,
                      'recipient': widget.booking.vendor.name,
                    },
                  );
                },
                icon: const Icon(CupertinoIcons.ellipses_bubble),
              ),
            const SizedBox(width: 20),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FilledButton(
            onPressed: _handleCompleteBooking,
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

  Widget _buildBody() {
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
                BookingStatusChip(status: widget.booking.status),
              ],
            ),
            const Divider(),

            // Vendor information
            const SizedBox(height: 20),
            const Text('Vendor Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Vendor Name:', text: widget.booking.vendor.name),
            const Divider(),

            // Client information
            const SizedBox(height: 20),
            const Text('Client Information', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            RowTile(label: 'Client Name:', text: widget.booking.client.name),
            const Divider(),

            // Service Price
            const SizedBox(height: 20),
            const Text('Service Information', style: TextStyle(fontSize: 16)),

            // Extras
            const SizedBox(height: 20),
            AutoSizeText(widget.booking.service.title),
            const SizedBox(height: 10),
            RowTile(
                label: 'Base Rate:', text: '₱ ${widget.booking.service.rate}'),
            const SizedBox(height: 20),
            const AutoSizeText(
              'Extras:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.booking.extras.map((extra) {
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
    double total = widget.booking.service.rate;
    for (final extra in widget.booking.extras) {
      total += extra.price;
    }
    return total;
  }

  void _handleCompleteBooking() async {
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
          child: QrReader(onDetect: _onQRDetect),
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
      Navigator.pop(context); // Called to close the dialog for the camera

      final detectedValue = capture.barcodes.first.rawValue;
      if (detectedValue == null) {
        throw 'Error scanning QR';
      }

      final data = BookingQrCodeData.fromJson(jsonDecode(detectedValue));
      await context.read<ControlCenterProvider>().complete(data);
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
          content: const Text('Booking complete'),
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
}
