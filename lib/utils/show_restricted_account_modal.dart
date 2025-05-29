import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAccountRestrictedModal(BuildContext context) {
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
      title: Text(
        'Feature disabled',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: const Text(
          "Feature temporarily disabled because this account is restricted"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
