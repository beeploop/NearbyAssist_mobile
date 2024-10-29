import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/logger_service.dart';
import 'package:nearby_assist/widgets/custom_list_tile_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          CustomListTileWidget(
            title: "Update Information",
            subtitle: "Force update user information",
            icon: Icons.sync_outlined,
            endIcon: false,
            onPress: () => _updateInfo(context),
          ),
          CustomListTileWidget(
            title: "Update Tags",
            subtitle: "Force update service tags",
            icon: Icons.tag_outlined,
            endIcon: false,
            onPress: () => _updateTags(context),
          ),
          const Divider(),
          const SizedBox(height: 10),
          CustomListTileWidget(
            title: "Clear Data",
            subtitle: "Clear cached data and logs you out",
            icon: Icons.clear_all_outlined,
            endIcon: false,
            onPress: _clearData,
          ),
          CustomListTileWidget(
            title: "Disable Account",
            subtitle: "Temporarily disable your account",
            icon: Icons.disabled_by_default_outlined,
            endIcon: false,
            onPress: () => _disableAccount(context),
          ),
          CustomListTileWidget(
            title: "Delete Account",
            textColor: Colors.red,
            subtitle: "Delete your account and saved data",
            icon: Icons.delete_outlined,
            iconColor: Colors.red,
            endIcon: false,
            onPress: _clearData,
          ),
        ],
      ),
    );
  }

  void _updateInfo(BuildContext context) async {
    try {
      await getIt.get<SettingsModel>().updateUserInformation();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User information updated'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user information: ${e.toString()}'),
          ),
        );
      }
    }
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
    try {
      await getIt.get<SettingsModel>().updateSavedTags();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service tags updated')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occurred while trying to update service tags'),
          ),
        );
      }
    }
  }

  void _clearData() async {
    try {
      await getIt.get<AuthModel>().logout();
    } catch (err) {
      ConsoleLogger().log(err);
    }
  }
}
