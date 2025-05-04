import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/account/settings/widget/setting_item.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:provider/provider.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(),
        body: buildListView(),
      ),
    );
  }

  ListView buildListView() {
    return ListView(
      children: [
        Consumer<UserProvider>(
          builder: (context, auth, child) {
            return SettingItem(
              title: "Sync Account",
              subtitle: "Update user information to latest values",
              icon: CupertinoIcons.arrow_2_circlepath,
              onPress: () => _syncAccount(auth),
            );
          },
        ),
        SettingItem(
          title: "Update Tags",
          subtitle: "Force update service tags",
          icon: CupertinoIcons.tag,
          onPress: _updateTags,
        ),
        SettingItem(
          title: "Healthcheck",
          subtitle: "Check status and connection of the server",
          icon: CupertinoIcons.waveform_path,
          onPress: _healthcheck,
        ),
        const Divider(),
        const SizedBox(height: 10),
        SettingItem(
          title: "Clear Data",
          subtitle: "Clear cached data and logout",
          icon: CupertinoIcons.clear,
          onPress: _clearData,
        ),
        const SizedBox(height: 10),
        SettingItem(
          title: "Welcome Page Type",
          subtitle: "Switch version of welcome page to use",
          icon: CupertinoIcons.compass,
          onPress: () {},
          trailing: _useWelcomePageV2(),
        ),
      ],
    );
  }

  Widget _useWelcomePageV2() {
    return Consumer<SystemSettingProvider>(builder: (context, provider, _) {
      bool toggled = provider.isWelcomePageV2;

      return Switch(
        value: toggled,
        onChanged: (value) {
          switch (value) {
            case true:
              SystemSettingProvider().changeWelcomePage(WelcomePageType.type2);
            case false:
              SystemSettingProvider().changeWelcomePage(WelcomePageType.type1);
          }
        },
      );
    });
  }

  Future<void> _syncAccount(UserProvider auth) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      await context.read<UserProvider>().syncAccount();
      _showSuccessSnackbar('Account information synced');
    } catch (error) {
      _showErrorSnackbar(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _updateTags() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      await context.read<ExpertiseProvider>().fetchExpertise();
      _showSuccessSnackbar('Tags updated');
    } catch (error) {
      _showErrorSnackbar(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _healthcheck() async {
    logger.logDebug('called healtCheck in app_settings_page.dart');

    final loader = context.loaderOverlay;

    try {
      loader.show();

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
      logger.logError(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _clearData() async {
    await context.read<UserProvider>().clearData();
    await SecureStorage().clearAll();
    await GoogleAuthService().logout();

    if (!mounted) return;

    showCustomSnackBar(
      context,
      "Data cleared",
      textColor: Colors.white,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      closeIconColor: Colors.white,
    );
  }

  void _showSuccessSnackbar(String message) {
    showCustomSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  void _showErrorSnackbar(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }
}
