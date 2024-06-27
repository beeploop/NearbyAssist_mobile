import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart' as constants;

class TextHeading extends StatelessWidget {
  const TextHeading({super.key, required this.title, this.style});

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: style ??
          const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: constants.headingFontSize,
          ),
    );
  }
}
