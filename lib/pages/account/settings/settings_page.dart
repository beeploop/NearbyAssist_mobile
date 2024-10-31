import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          AccountTileWidget(
            title: "Sync Account",
            subtitle: "Update user information to latest values",
            icon: CupertinoIcons.arrow_2_circlepath,
            endIcon: false,
            onPress: () => _updateInfo(context),
          ),
          AccountTileWidget(
            title: "Update Tags",
            subtitle: "Force update service tags",
            icon: CupertinoIcons.tag,
            endIcon: false,
            onPress: () => _updateTags(context),
          ),
          const Divider(),
          const SizedBox(height: 10),
          AccountTileWidget(
            title: "Clear Data",
            subtitle: "Clear cached data and logout",
            icon: CupertinoIcons.clear,
            endIcon: false,
            onPress: _clearData,
          ),
          AccountTileWidget(
            title: "Disable Account",
            subtitle: "Temporarily disable your account",
            icon: CupertinoIcons.nosign,
            endIcon: false,
            onPress: () => _disableAccount(context),
          ),
          AccountTileWidget(
            title: "Delete Account",
            textColor: Colors.red,
            subtitle: "Delete your account and saved data",
            icon: CupertinoIcons.trash,
            iconColor: Colors.red,
            endIcon: false,
            onPress: _clearData,
          ),
        ],
      ),
    );
  }

  void _updateInfo(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is under development"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _disableAccount(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is under development"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _updateTags(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is under development"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _clearData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This feature is under development"),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
