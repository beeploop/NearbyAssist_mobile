import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/rate_page.dart';
import 'package:nearby_assist/pages/account/bookings/to_rate/to_rate_summary_page.dart';
import 'package:nearby_assist/pages/account/widget/booking_status_chip.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/utils/date_formatter.dart';

class ToRateListItem extends StatelessWidget {
  const ToRateListItem({
    super.key,
    required this.booking,
    this.backgroundColor,
  });

  final BookingModel booking;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        children: [
          // Vendor section
          GestureDetector(
            onTap: () => context.pushNamed(
              'vendorPage',
              queryParameters: {'vendorId': booking.vendor.id},
            ),
            child: _top(context),
          ),

          // Service section
          _middle(),
          const SizedBox(height: 20),

          // Schedule section
          _bottom(context),
        ],
      ),
    );
  }

  Widget _top(BuildContext context) {
    return Row(
      children: [
        // Vendor
        const Icon(CupertinoIcons.person, size: 13),
        const SizedBox(width: 10),
        Text(
          booking.vendor.name,
          style: const TextStyle(fontSize: 12),
        ),

        const Spacer(),

        // Status
        BookingStatusChip(status: booking.status),
      ],
    );
  }

  Widget _middle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Icon
        const Icon(CupertinoIcons.wrench, size: 32),
        const SizedBox(width: 10),

        // Service
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.service.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                booking.service.description,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Updated date
        Text(DateFormatter.monthAndDateFromDT(booking.updatedAt!)),
        const Spacer(),

        // Details button
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ToRateSummaryPage(booking: booking),
              ),
            );
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            visualDensity: VisualDensity.compact,
            padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
          ),
          child: const Text('Details'),
        ),
        const SizedBox(width: 10),

        // Rate button
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => RatePage(booking: booking),
              ),
            );
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            visualDensity: VisualDensity.compact,
            padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
          ),
          child: const Text('Rate'),
        ),
      ],
    );
  }
}
