import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/pretty_json.dart';

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
            onPress: _updateInfo,
          ),
          AccountTileWidget(
            title: "Update Tags",
            subtitle: "Force update service tags",
            icon: CupertinoIcons.tag,
            endIcon: false,
            onPress: _updateTags,
          ),
          AccountTileWidget(
            title: "Healthcheck",
            subtitle: "Check status and connection of the server",
            icon: CupertinoIcons.waveform_path,
            endIcon: false,
            onPress: _healthcheck,
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
            onPress: _disableAccount,
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

  Future<void> _updateInfo() async {
    showCustomSnackBar(
      context,
      "This feature is under development",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellow[300],
    );
  }

  void _disableAccount() async {
    showCustomSnackBar(
      context,
      "This feature is under development",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellow[300],
    );
  }

  void _updateTags() async {
    showCustomSnackBar(
      context,
      "This feature is under development",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellow[300],
    );
  }

  void _healthcheck() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.healthcheck);

      if (!mounted) throw Exception('connection not mounted');

      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          icon: const Icon(CupertinoIcons.info_circle),
          title: const Text('Healthcheck'),
          content: Text(prettyJSON(response.data)),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('close'),
            ),
          ],
        ),
      );
    } catch (error) {
      logger.log(error.toString());
    }
  }

  void _clearData() async {
    showCustomSnackBar(
      context,
      "This feature is under development",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellow[300],
    );
  }
}
