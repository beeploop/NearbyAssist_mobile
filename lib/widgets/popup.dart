import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  const PopUp({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
  });

  final String title;
  final String subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        if (actions != null) ...actions!,
      ],
    );
  }
}
