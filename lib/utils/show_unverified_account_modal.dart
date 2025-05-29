import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showUnverifiedAccountModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        CupertinoIcons.exclamationmark_triangle,
        size: 28,
        color: Colors.amber,
      ),
      title: Text(
        'Account not verified',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You need to verify your account to access this feature.',
          ),
          Text(
            '\nComplete your verification to continue using all available services.',
          ),
        ],
      ),
      actions: [
        TextButton(
          style: const ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.green.shade800,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            context.pushNamed('verifyAccount');
          },
          child: const Text(
            'Verify Now',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
