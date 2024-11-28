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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            )),
        const SizedBox(height: 6),
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
