import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onPress: _logout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      _showErrorModal('Could not launch $url');
    }
  }

  Future<void> _logout() async {
    try {
      await GoogleAuthService().logout();
      await AuthService().logout();
      _onLogoutSuccess();
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _onLogoutSuccess() {
    context.read<UserProvider>().logout();

    showCustomSnackBar(
      context,
      "Logout",
      textColor: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      closeIconColor: Colors.white,
    );
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
              title: "Transactions",
              icon: CupertinoIcons.arrow_right_arrow_left_square,
              onPress: () => context.pushNamed("transactions")),
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
              title: "Information & Licenses",
              icon: CupertinoIcons.info,
              onPress: () => context.pushNamed("information")),
        ],
      ),
    );
  }

  Widget _bannerImage() {
    final user = context.watch<UserProvider>().user;

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
              foregroundImage: CachedNetworkImageProvider(user.imageUrl),
              backgroundImage: const AssetImage('assets/images/profile.png'),
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
