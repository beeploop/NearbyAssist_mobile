import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showHasPendingVerification(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        CupertinoIcons.exclamationmark_triangle,
        size: 28,
        color: Colors.amber,
      ),
      title: const Text('Pending Verification'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your account verification is still in progress. Some features are temporarily unavailable until the process is complete.',
            textAlign: TextAlign.justify,
          ),
          Text(
            '\n\nPlease check back later.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.red.shade800,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () => context.pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
