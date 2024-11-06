import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerImage(),
            const SizedBox(height: 20),
            _accountSection(),
            const Divider(),
            const SizedBox(height: 20),
            _privacySection(),
            const Divider(),
            const SizedBox(height: 20),
            _othersSection(),
            const Divider(),
            const SizedBox(height: 20),
            AccountTileWidget(
                title: "Logout",
                icon: CupertinoIcons.square_arrow_left,
                textColor: Colors.red,
                iconColor: Colors.red,
                endIcon: false,
                onPress: () => _logout(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    throw UnimplementedError();
  }

  Future<void> _logout(BuildContext context) async {
    context.read<AuthProvider>().logout();

    showCustomSnackBar(
      context,
      "Logout",
      textColor: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      closeIconColor: Colors.white,
    );
  }

  Widget _accountSection() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Settings", style: TextStyle(fontSize: 20)),
          AccountTileWidget(
              title: "Profile",
              icon: CupertinoIcons.person,
              onPress: () => context.pushNamed("profile")),
          AccountTileWidget(
              title: "Manage Services",
              icon: CupertinoIcons.tray_full,
              onPress: () => context.pushNamed("manage")),
          AccountTileWidget(
              title: "Settings",
              icon: CupertinoIcons.gear,
              onPress: () => context.pushNamed("settings")),
        ],
      ),
    );
  }

  Widget _privacySection() {
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
                _launchUrl(context, Uri.parse(""));
              }),
          AccountTileWidget(
              title: "Terms and Conditions",
              icon: CupertinoIcons.doc_plaintext,
              onPress: () {
                _launchUrl(context, Uri.parse(""));
              }),
        ],
      ),
    );
  }

  Widget _othersSection() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Other", style: TextStyle(fontSize: 20)),
          AccountTileWidget(
              title: "Report and Feedback",
              icon: CupertinoIcons.exclamationmark_bubble,
              onPress: () => context.pushNamed("reportIssue")),
          AccountTileWidget(
              title: "Contact Support",
              icon: CupertinoIcons.bubble_left_bubble_right,
              onPress: () {
                showCustomSnackBar(
                  context,
                  "This feature is under development",
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.yellow[300],
                );
              }),
          AccountTileWidget(
              title: "Information",
              icon: CupertinoIcons.info,
              onPress: () => context.pushNamed("information")),
        ],
      ),
    );
  }

  Widget _bannerImage() {
    final user = context.read<AuthProvider>().user;

    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 40,
              foregroundImage: AssetImage(user.imageUrl),
            ),
            const SizedBox(height: 10),
            Text(
              user.name,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
