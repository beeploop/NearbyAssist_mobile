import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/assets.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherSectionV2 extends StatefulWidget {
  const OtherSectionV2({super.key});

  @override
  State<OtherSectionV2> createState() => _OtherSectionV2State();
}

class _OtherSectionV2State extends State<OtherSectionV2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Other", style: TextStyle(fontSize: 14)),
          AccountTileWidget(
              title: "Report Bug",
              fontSize: 14,
              icon: CupertinoIcons.exclamationmark_bubble,
              onPress: () => context.pushNamed("reportIssue")),
          AccountTileWidget(
              title: "Privacy Policy",
              fontSize: 14,
              icon: CupertinoIcons.shield,
              onPress: () {
                _launchUrl(context, Uri.parse(endpoint.privacyPolicy));
              }),
          AccountTileWidget(
              title: "Terms and Conditions",
              fontSize: 14,
              icon: CupertinoIcons.doc_plaintext,
              onPress: () {
                _launchUrl(context, Uri.parse(endpoint.termsAndConditions));
              }),
          AccountTileWidget(
            title: "Information & Licenses",
            fontSize: 14,
            icon: CupertinoIcons.info,
            onPress: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => LicensePage(
                  applicationName: appName,
                  applicationVersion: appVersion,
                  applicationLegalese: appLegalese,
                  applicationIcon: Image.asset(
                    Assets.splashIcon,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
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
