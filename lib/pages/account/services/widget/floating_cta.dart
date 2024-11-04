import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingCTA extends StatelessWidget {
  const FloatingCTA({super.key});

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
            onPressed: () {},
            child: const Text('Book Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed(
                'chat',
                queryParameters: {'recipientId': '', 'recipient': ''},
              );
            },
            child: const Text('Chat'),
          ),
        ],
      ),
    );
  }
}
