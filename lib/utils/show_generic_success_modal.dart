import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showGenericSuccessModal(
  BuildContext context, {
  String? title,
  required String message,
  List<Widget>? moreActions,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.green,
          size: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title ?? 'Success',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(message),
        actions: [
          if (moreActions != null) ...moreActions,

          // Okay button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
