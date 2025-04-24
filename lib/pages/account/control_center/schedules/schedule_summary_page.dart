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
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
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
            'Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: _showRescheduleModal,
              icon: const Icon(CupertinoIcons.calendar_today),
            ),
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
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
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

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Booking completed!');
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: 'Invalid QR');
    } finally {
      loader.hide();
    }
  }

  void _showRescheduleModal() {
    final rescheduleController = TextEditingController(
      text: DateFormatter.monthAndDate(widget.booking.scheduledAt!),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          CupertinoIcons.calendar_badge_plus,
          color: Colors.green,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'Set reschedule date',
          style: TextStyle(fontSize: 20),
        ),
        content: TextField(
          controller: rescheduleController,
          decoration: const InputDecoration(
            labelText: 'Schedule',
            filled: true,
            prefixIcon: Icon(CupertinoIcons.calendar),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? schedule = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(widget.booking.scheduledAt!),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 30),
                ));

            if (schedule == null) return;

            setState(() {
              rescheduleController.text = schedule.toString().split(" ")[0];
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleReschedule(widget.booking.id, rescheduleController.text);
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleReschedule(String bookingId, String schedule) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      await context
          .read<ControlCenterProvider>()
          .reschedule(bookingId, schedule);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Booking rescheduled');
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
