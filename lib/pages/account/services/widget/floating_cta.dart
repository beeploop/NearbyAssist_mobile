import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/pages/booking/booking_page.dart';

class FloatingCTA extends StatelessWidget {
  const FloatingCTA({super.key, required this.details});

  final DetailedServiceModel details;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: FilledButton(
        onPressed: () => _handleClick(context),
        child: const Text('Book Now'),
      ),
    );
  }

  void _handleClick(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Now'),
        content: const Text(
          'You are about to book this service. Instead of booking, you can chat with the vendor to discuss more.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => BookingPage(details: details),
                ),
              );
            },
            child: const Text('Book Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed(
                'chat',
                queryParameters: {
                  'recipientId': details.vendor.id,
                  'recipient': details.vendor.name,
                },
              );
            },
            child: const Text('Chat'),
          ),
        ],
      ),
    );
  }
}
