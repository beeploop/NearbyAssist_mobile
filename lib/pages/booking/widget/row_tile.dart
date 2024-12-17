import 'package:flutter/material.dart';

class RowTile extends StatelessWidget {
  const RowTile({
    super.key,
    required this.label,
    required this.text,
    this.bold = false,
    this.withLeftPad = false,
  });

  final String label;
  final String text;
  final bool bold;
  final bool withLeftPad;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (withLeftPad) const SizedBox(width: 16),
        Text(label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            )),
        const Spacer(),
        Text(text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey[900],
            )),
      ],
    );
  }
}
