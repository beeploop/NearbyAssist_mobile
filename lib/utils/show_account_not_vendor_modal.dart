import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showAccountNotVendorModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(
        CupertinoIcons.exclamationmark_triangle,
        color: Colors.amber,
        size: 40,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Feature unavailable'),
      content: const Text(
          'You need to have an expertise in order to start offering services'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        TextButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            backgroundColor: WidgetStatePropertyAll(Colors.green.shade800),
          ),
          onPressed: () {
            context.pop();
            context.pushNamed('vendorApplication');
          },
          child: const Text('Apply', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
