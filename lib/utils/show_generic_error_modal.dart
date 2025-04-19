import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showGenericErrorModal(
  BuildContext context, {
  String? title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          CupertinoIcons.xmark_circle_fill,
          color: Colors.red,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title ?? 'Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

