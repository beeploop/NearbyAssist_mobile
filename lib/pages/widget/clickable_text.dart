import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({
    super.key,
    required this.text,
    required this.clickableText,
    required this.onClick,
    this.textColor,
    this.clickableTextColor,
  });

  final String text;
  final String clickableText;
  final Color? textColor;
  final Color? clickableTextColor;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: textColor ?? Colors.black),
        children: [
          TextSpan(text: text),
          TextSpan(
            style: TextStyle(color: clickableTextColor ?? Colors.blue),
            text: clickableText,
            recognizer: TapGestureRecognizer()..onTap = onClick,
          ),
        ],
      ),
    );
  }
}
