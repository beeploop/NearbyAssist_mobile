import 'dart:math';
import 'package:flutter/material.dart';

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(200), // Red value (0-255)
    255,
    random.nextInt(120), // Blue value (0-255)
    1, // Opacity (1 for fully opaque)
  );
}
