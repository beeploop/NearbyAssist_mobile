import 'package:flutter/material.dart';
import 'package:nearby_assist/config/theme/app_colors.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InputChip(
        label: Text(label),
        onPressed: () => onPressed(),
        labelStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide.none,
      ),
    );
  }
}
