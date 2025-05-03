import 'package:flutter/material.dart';

class PopularSearchChip extends StatelessWidget {
  const PopularSearchChip({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onPressed: () => onPressed(),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.green.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide.none,
    );
  }
}
