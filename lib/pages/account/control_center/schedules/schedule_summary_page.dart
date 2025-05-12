import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/booking_qr_code_data.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/control_center/schedules/widget/menu.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/format_quantity_booked.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:provider/provider.dart';

class ScheduleSummaryPage extends StatefulWidget {
  const ScheduleSummaryPage({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ScheduleSummaryPage> createState() => _ScheduleSummaryPageState();
}

class _ScheduleSummaryPageState extends State<ScheduleSummaryPage> {
  final _qrController = MobileScannerController();

  @override
  void dispose() {
    super.dispose();
    _qrController.dispose();
  }

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
            Menu(booking: widget.booking),
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
                      color: Colors.grey.shade800,
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
              label: 'Base Price:',
              text: formatCurrency(widget.booking.service.price),
            ),
            const SizedBox(height: 10),
            RowTile(
              label: 'Pricing Type',
              text: widget.booking.service.pricingType.label,
            ),
            if (widget.booking.service.pricingType != PricingType.fixed)
              const SizedBox(height: 10),
            if (widget.booking.service.pricingType != PricingType.fixed)
              RowTile(
                label: 'Booked for',
                text: formatQuantityBooked(
                  widget.booking.quantity,
                  widget.booking.service.pricingType,
                ),
              ),
            const SizedBox(height: 10),
            RowTile(
              label: 'Scheduled on: ',
              text: DateFormatter.monthDateRangeDT(
                widget.booking.scheduleStart!,
                widget.booking.scheduleEnd!,
              ),
            ),
            const SizedBox(height: 20),
            const AutoSizeText(
              'Add-ons:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.booking.extras.map((extra) {
              return RowTile(
                label: extra.title,
                text: formatCurrency(extra.price),
                withLeftPad: true,
              );
            }),
            const SizedBox(height: 20),
            const Divider(),

            // Estimated cost
            const SizedBox(height: 20),
            RowTile(
              label: 'Total Cost:',
              text: formatCurrency(widget.booking.total()),
            ),

            // Complete Button
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _handleCompleteBooking() async {
    try {
      _qrController.start();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => MobileScanner(
          controller: _qrController,
          onDetect: _onQRDetect,
          overlayBuilder: (context, constraints) => Center(
            child: Container(
              width: constraints.maxWidth * 0.6,
              height: constraints.maxWidth * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
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
      _qrController.stop();
      loader.show();
      Navigator.pop(context); // Called to close the dialog for the camera

      final code = capture.barcodes.firstOrNull;
      if (code == null) {
        throw 'No code data read';
      }

      final detectedValue = code.rawValue;
      if (detectedValue == null || detectedValue.isEmpty) {
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
}
