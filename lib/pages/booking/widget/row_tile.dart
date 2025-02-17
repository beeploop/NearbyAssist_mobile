import 'package:auto_size_text/auto_size_text.dart';
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
        AutoSizeText(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        AutoSizeText(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey.shade900,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
