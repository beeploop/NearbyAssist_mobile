import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color textColor = Colors.black,
  Duration duration = const Duration(seconds: 1),
  Color? backgroundColor = Colors.white,
  ShapeBorder? shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  bool dismissable = true,
  Color closeIconColor = Colors.black,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: shape,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: backgroundColor,
        showCloseIcon: dismissable,
        closeIconColor: closeIconColor,
      ),
    );
}
