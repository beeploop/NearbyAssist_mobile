import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/change_address/change_address_page.dart';
import 'package:nearby_assist/pages/account/profile/profile_settings/widget/profile_setting_tile.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ProfileSettingTile(
              icon: CupertinoIcons.home,
              title: 'Change address',
              onPress: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ChangeAddressPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
