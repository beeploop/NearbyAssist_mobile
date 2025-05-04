import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class VendorHistorySummaryPage extends StatefulWidget {
  const VendorHistorySummaryPage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  State<VendorHistorySummaryPage> createState() =>
      _VendorHistorySummaryPageState();
}

class _VendorHistorySummaryPageState extends State<VendorHistorySummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
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
              AutoSizeText(
                widget.booking.service.title,
              ),
              const SizedBox(height: 10),
              RowTile(
                label: 'Base Rate:',
                text: formatCurrency(widget.booking.service.rate),
              ),
              const SizedBox(height: 20),
              const AutoSizeText(
                'Extras:',
                style: TextStyle(fontWeight: FontWeight.bold),
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

              const SizedBox(height: 20),

              // Reason if rejected or cancelled
              if (widget.booking.status == BookingStatus.rejected ||
                  widget.booking.status == BookingStatus.cancelled)
                const AutoSizeText(
                  'Reason:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10),
              if (widget.booking.status == BookingStatus.rejected ||
                  widget.booking.status == BookingStatus.cancelled)
                AutoSizeText(widget.booking.cancelReason ?? ''),

              // Bottom padding
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
