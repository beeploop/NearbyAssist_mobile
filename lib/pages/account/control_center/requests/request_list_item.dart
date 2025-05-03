import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/utils/money_formatter.dart';
import 'package:nearby_assist/utils/date_formatter.dart';
import 'package:go_router/go_router.dart';

class RequestListItem extends StatelessWidget {
  const RequestListItem({
    super.key,
    required this.booking,
    required this.onTap,
    this.backgroundColor,
  });

  final BookingModel booking;
  final void Function() onTap;
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
              'chat',
              queryParameters: {
                'recipientId': booking.client.id,
                'recipient': booking.client.name,
              },
            ),
            child: _top(context),
          ),
          const SizedBox(height: 10),

          // Service section
          GestureDetector(
            onTap: onTap,
            child: _middle(),
          ),
          const SizedBox(height: 20),

          // Schedule section
          _bottom(),
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
          booking.client.name,
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Text(DateFormatter.monthAndDateFromDT(booking.createdAt)),
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
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                booking.service.description,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Total amount
        Text(
          formatCurrency(booking.total()),
          style: TextStyle(color: Colors.green.shade800),
        ),
      ],
    );
  }

  Widget _bottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Created date
        Text(DateFormatter.monthAndDateFromDT(booking.createdAt)),
        const SizedBox(width: 10),

        // Details button
        OutlinedButton(
          onPressed: onTap,
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
      ],
    );
  }
}
