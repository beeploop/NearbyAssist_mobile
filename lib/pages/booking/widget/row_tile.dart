import 'package:flutter/material.dart';

class RowTile extends StatelessWidget {
  const RowTile({
    super.key,
    required this.label,
    required this.text,
    this.bold = false,
  });

  final String label;
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 16,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: Colors.grey[800],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(text, style: style),
      ],
    );
  }
}
