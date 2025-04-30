import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearby_assist/models/social_model.dart';

IconData siteIcon(SocialType social) {
  switch (social) {
    case SocialType.twitter:
      return FontAwesomeIcons.twitter;
    case SocialType.instagram:
      return FontAwesomeIcons.instagram;
    case SocialType.facebook:
      return FontAwesomeIcons.facebook;
    case SocialType.messenger:
      return FontAwesomeIcons.facebookMessenger;
    case SocialType.linkedin:
      return FontAwesomeIcons.linkedin;
    case SocialType.other:
      return FontAwesomeIcons.chrome;
  }
}
