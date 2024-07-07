import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart' as constants;

class TextHeading extends StatelessWidget {
  const TextHeading({
    super.key,
    required this.title,
    this.style,
    this.alignment,
    this.fontSize,
  });

  final String title;
  final TextStyle? style;
  final TextAlign? alignment;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: alignment ?? TextAlign.center,
      style: style ??
          TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize ?? constants.headingFontSize,
          ),
    );
  }
}
