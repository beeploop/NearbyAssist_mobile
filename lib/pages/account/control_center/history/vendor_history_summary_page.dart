import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/control_center/history/widget/review_item.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/format_quantity_booked.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:provider/provider.dart';

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
      body: FutureBuilder(
          future: context
              .read<ControlCenterProvider>()
              .getClientReviewOnBooking(
                  widget.booking.client.id, widget.booking.id),
          builder: (context, snapshot) {
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
                  const Text('Vendor Information',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  RowTile(
                      label: 'Vendor Name:', text: widget.booking.vendor.name),
                  const Divider(),

                  // Client information
                  const SizedBox(height: 20),
                  const Text('Client Information',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  RowTile(
                      label: 'Client Name:', text: widget.booking.client.name),
                  const Divider(),

                  // Service Price
                  const SizedBox(height: 20),
                  const Text('Service Information',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),

                  // Title
                  const AutoSizeText(
                    'Title:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    widget.booking.serviceTitle,
                  ),
                  const SizedBox(height: 10),

                  // Description
                  const AutoSizeText(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    widget.booking.serviceDescription,
                  ),
                  const SizedBox(height: 20),

                  // Price
                  RowTile(
                    label: 'Base Price:',
                    text: formatCurrency(widget.booking.price),
                  ),
                  const SizedBox(height: 10),
                  RowTile(
                    label: 'Pricing Type',
                    text: widget.booking.pricingType.label,
                  ),
                  if (widget.booking.pricingType != PricingType.fixed)
                    const SizedBox(height: 10),
                  if (widget.booking.pricingType != PricingType.fixed)
                    RowTile(
                      label: 'Booked for',
                      text: formatQuantityBooked(
                        widget.booking.quantity,
                        widget.booking.pricingType,
                      ),
                    ),
                  if (widget.booking.pricingType != PricingType.fixed)
                    const SizedBox(height: 10),
                  _dateModified(),
                  const SizedBox(height: 20),

                  // Add-ons
                  const AutoSizeText(
                    'Add-ons:',
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
                  _whoCancelled(),
                  const SizedBox(height: 10),

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

                  const SizedBox(height: 30),

                  const AutoSizeText(
                    'Review:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : snapshot.data == null
                          ? Container()
                          : ReviewItem(review: snapshot.data!),

                  // Bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }

  Widget _whoCancelled() {
    final user = context.watch<UserProvider>().user;

    if (widget.booking.status != BookingStatus.cancelled) {
      return const SizedBox(height: 10);
    }

    if (widget.booking.cancelledById == user.id) {
      return RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 12),
          children: [
            TextSpan(
                text: 'Cancelled by: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(
              text: 'You',
            ),
          ],
        ),
      );
    }

    return RichText(
      text: const TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 12),
        children: [
          TextSpan(
              text: 'Cancelled by: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: 'Client',
          ),
        ],
      ),
    );
  }

  Widget _dateModified() {
    final date = widget.booking.updatedAt;

    switch (widget.booking.status) {
      case BookingStatus.pending:
        return RowTile(
          label: 'Date requested',
          text: DateFormatter.monthAndDateFromDT(date!),
        );
      case BookingStatus.confirmed:
        return RowTile(
          label: 'Date confirmed',
          text: DateFormatter.monthAndDateFromDT(date!),
        );
      case BookingStatus.done:
        return RowTile(
          label: 'Date completed',
          text: DateFormatter.monthAndDateFromDT(date!),
        );
      case BookingStatus.rejected:
        return RowTile(
          label: 'Date rejected',
          text: DateFormatter.monthAndDateFromDT(date!),
        );
      case BookingStatus.cancelled:
        return RowTile(
          label: 'Date cancelled',
          text: DateFormatter.monthAndDateFromDT(date!),
        );
    }
  }
}
