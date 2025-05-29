import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/rate_page.dart';
import 'package:nearby_assist/pages/account/bookings/widget/menu.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:nearby_assist/utils/format_quantity_booked.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class ToRateSummaryPage extends StatefulWidget {
  const ToRateSummaryPage({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ToRateSummaryPage> createState() => _ToRateSummaryPageState();
}

class _ToRateSummaryPageState extends State<ToRateSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Menu(booking: widget.booking, showCancel: false),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date created
              Row(
                children: [
                  Text(
                    'Date Booked',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    DateFormatter.yearMonthDateFromDT(widget.booking.createdAt),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),

              const Divider(),

              // Vendor information
              const SizedBox(height: 20),
              Text(
                'Vendor Information',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              RowTile(label: 'Vendor Name:', text: widget.booking.vendor.name),
              const Divider(),

              // Client information
              const SizedBox(height: 20),
              Text(
                'Client Information',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              RowTile(label: 'Client Name:', text: widget.booking.client.name),
              const Divider(),

              // Service Price
              const SizedBox(height: 20),
              Text(
                'Service Information',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),

              // Title
              AutoSizeText(
                'Title:',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                widget.booking.serviceTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),

              // Description
              AutoSizeText(
                'Description',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                widget.booking.serviceDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),

              RowTile(
                label: 'Base Price:',
                text: formatCurrency(widget.booking.price),
              ),
              const SizedBox(height: 10),
              RowTile(
                label: 'Pricing Type',
                text: widget.booking.pricingType.label,
              ),

              // Dates and schedules
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
              const SizedBox(height: 10),
              RowTile(
                label: 'Scheduled on: ',
                text: widget.booking.pricingType == PricingType.perDay
                    ? DateFormatter.monthDateRangeDT(
                        widget.booking.scheduleStart!,
                        widget.booking.scheduleEnd!,
                      )
                    : DateFormatter.monthAndDateFromDT(
                        widget.booking.scheduleStart!),
              ),
              // date completed
              const SizedBox(height: 10),
              _dateModified(),

              // Add-ons
              const SizedBox(height: 20),
              AutoSizeText(
                'Add-ons:',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
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

              // Bottom padding
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => RatePage(booking: widget.booking),
              ),
            );
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: const WidgetStatePropertyAll(
              Size.fromHeight(50),
            ),
          ),
          child: const Text('Rate'),
        ),
      ),
    );
  }

  Widget _dateModified() {
    final date = widget.booking.updatedAt;

    switch (widget.booking.status) {
      case BookingStatus.pending:
        return RowTile(
          label: 'Date requested',
          text: DateFormatter.yearMonthDateFromDT(date!),
        );
      case BookingStatus.confirmed:
        return RowTile(
          label: 'Date confirmed',
          text: DateFormatter.yearMonthDateFromDT(date!),
        );
      case BookingStatus.done:
        return RowTile(
          label: 'Date completed',
          text: DateFormatter.yearMonthDateFromDT(date!),
        );
      case BookingStatus.rejected:
        return RowTile(
          label: 'Date rejected',
          text: DateFormatter.yearMonthDateFromDT(date!),
        );
      case BookingStatus.cancelled:
        return RowTile(
          label: 'Date cancelled',
          text: DateFormatter.yearMonthDateFromDT(date!),
        );
    }
  }
}
