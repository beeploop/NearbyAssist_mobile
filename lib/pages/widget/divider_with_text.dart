import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 10),
        Text(text),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
      ],
    );
  }
}
