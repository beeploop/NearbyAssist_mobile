import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showUnverifiedAccountModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(CupertinoIcons.exclamationmark_triangle),
      title: const Text('Account not verified'),
      content: const Text('Verify your account to unlock feature'),
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
          onPressed: () => context.pushNamed('verifyAccount'),
          child: const Text(
            'Verify',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
