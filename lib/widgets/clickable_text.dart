import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({super.key, required this.url});

  final Uri url;

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw Exception("Could not launch url: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          const TextSpan(text: "I agree to the "),
          TextSpan(
            style: const TextStyle(color: Colors.blue),
            text: "terms and conditions",
            recognizer: TapGestureRecognizer()..onTap = _launchUrl,
          ),
        ],
      ),
    );
  }
}
