import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/widgets/custom_list_tile_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = getIt.get<AuthModel>().getUser();
  final addr = getIt.get<SettingsModel>().getServerAddr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _bannerImage(),
          Expanded(
            child: ListView(children: [
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
              CustomListTileWidget(
                  title: "Logout",
                  icon: Icons.logout_outlined,
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  endIcon: false,
                  onPress: () => _logout(context)),
              const SizedBox(height: 20),
            ]),
          ),
        ]),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open url'),
          ),
        );
      } else {
        ConsoleLogger().log('Could not open url: $url');
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await getIt.get<AuthModel>().logout();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error logging out. Please try again later.'),
        ));
      } else {
        ConsoleLogger().log(e);
      }
    }
  }

  Widget _accountSection() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Account Settings", style: TextStyle(fontSize: 20)),
          CustomListTileWidget(
              title: "Profile",
              icon: Icons.person_outlined,
              onPress: () => context.pushNamed("profile")),
          CustomListTileWidget(
              title: "Manage Services",
              icon: Icons.shopping_bag_outlined,
              onPress: () => context.pushNamed("services")),
          CustomListTileWidget(
              title: "Settings",
              icon: Icons.settings_outlined,
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
          CustomListTileWidget(
              title: "Privacy Policy",
              icon: Icons.privacy_tip_outlined,
              onPress: () {
                _launchUrl(context, Uri.parse("$addr/privacy_policy"));
              }),
          CustomListTileWidget(
              title: "Terms and Conditions",
              icon: Icons.document_scanner_outlined,
              onPress: () {
                _launchUrl(context, Uri.parse("$addr/terms_and_conditions"));
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
          CustomListTileWidget(
              title: "Report and Feedback",
              icon: Icons.feedback_outlined,
              onPress: () => context.pushNamed("report")),
          CustomListTileWidget(
              title: "Contact Support",
              icon: Icons.support_agent_outlined,
              onPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('This feature is under development'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }),
          CustomListTileWidget(
              title: "Information",
              icon: Icons.info_outlined,
              onPress: () => context.pushNamed("information")),
        ],
      ),
    );
  }

  Widget _bannerImage() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 40,
          right: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                foregroundImage: CachedNetworkImageProvider(
                  user.imageUrl.startsWith("http")
                      ? user.imageUrl
                      : '$addr/resource/${user.imageUrl}',
                ),
                onForegroundImageError: (object, stacktrace) {
                  ConsoleLogger().log(
                    'Error loading network image',
                  );
                },
                backgroundImage: const AssetImage('assets/images/avatar.png'),
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
      ],
    );
  }
}
