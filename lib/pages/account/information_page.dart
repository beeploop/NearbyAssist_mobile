import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: appName,
      applicationVersion: appVersion,
      applicationLegalese: appLegalese,
      applicationIcon: Image.asset(
        'assets/images/splash_icon_android_12.png',
        width: 100,
        height: 100,
      ),
    );
  }
}
