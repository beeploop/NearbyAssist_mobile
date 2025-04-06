import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';

class OtherSection extends StatelessWidget {
  const OtherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Other", style: TextStyle(fontSize: 20)),
          AccountTileWidget(
              title: "Report Bug",
              icon: CupertinoIcons.exclamationmark_bubble,
              onPress: () => context.pushNamed("reportIssue")),
          AccountTileWidget(
            title: "Information & Licenses",
            icon: CupertinoIcons.info,
            onPress: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => LicensePage(
                  applicationName: appName,
                  applicationVersion: appVersion,
                  applicationLegalese: appLegalese,
                  applicationIcon: Image.asset(
                    'assets/images/splash_icon_android_12.png',
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
}
