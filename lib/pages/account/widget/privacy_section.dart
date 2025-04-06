import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySection extends StatefulWidget {
  const PrivacySection({super.key});

  @override
  State<PrivacySection> createState() => _PrivacySectionState();
}

class _PrivacySectionState extends State<PrivacySection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Privacy", style: TextStyle(fontSize: 20)),
          AccountTileWidget(
              title: "Privacy Policy",
              icon: CupertinoIcons.shield,
              onPress: () {
                _launchUrl(context, Uri.parse(endpoint.privacyPolicy));
              }),
          AccountTileWidget(
              title: "Terms and Conditions",
              icon: CupertinoIcons.doc_plaintext,
              onPress: () {
                _launchUrl(context, Uri.parse(endpoint.termsAndConditions));
              }),
        ],
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      _showErrorModal('Could not launch $url');
    }
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
