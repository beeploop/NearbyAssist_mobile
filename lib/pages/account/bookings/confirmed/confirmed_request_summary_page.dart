import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/confirmed/widget/booking_qr_image.dart';
import 'package:nearby_assist/pages/account/bookings/widget/menu.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class ConfirmedRequestSummarPage extends StatefulWidget {
  const ConfirmedRequestSummarPage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  State<ConfirmedRequestSummarPage> createState() =>
      _ConfirmedRequestSummarPageState();
}

class _ConfirmedRequestSummarPageState
    extends State<ConfirmedRequestSummarPage> {
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
            Menu(booking: widget.booking),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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

          // QR Code to scan for completing the booking
          const Text(
            'Show this QR to the vendor to complete this booking',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // QR Signature of booking
          BookingQRImage(booking: widget.booking),

          // Complete Button
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
