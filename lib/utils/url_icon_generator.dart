import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData iconFromURL(String url) {
  if (url.contains(RegExp('linkedin'))) {
    return FontAwesomeIcons.linkedin;
  }

  if (url.contains(RegExp('facebook'))) {
    return FontAwesomeIcons.facebook;
  }

  if (url.contains(RegExp('github'))) {
    return FontAwesomeIcons.github;
  }

  return FontAwesomeIcons.chrome;
}
