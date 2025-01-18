import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/account/widget/account_tile_widget.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/pretty_json.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: buildListView(context),
        ),

        // Show loading overlay
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      children: [
        Consumer<UserProvider>(
          builder: (context, auth, child) {
            return AccountTileWidget(
              title: "Sync Account",
              subtitle: "Update user information to latest values",
              icon: CupertinoIcons.arrow_2_circlepath,
              endIcon: false,
              onPress: () => _syncAccount(auth),
            );
          },
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
          onPress: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                icon: const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.amber,
                  size: 30,
                ),
                title: const Text('Delete Account'),
                content: const Text(
                  'This action will delete all your user data. This action is not reversible, are you sure?',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      _deleteAccount();
                    },
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Colors.red),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _syncAccount(UserProvider auth) async {
    try {
      showLoader();

      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.me);

      final user = UserModel.fromJson(response.data['user']);

      final store = SecureStorage();
      await store.saveUser(user);

      await auth.login(user);

      _showSuccessModal('Account information synced');
    } catch (error) {
      _showErrorModal(error.toString());
    } finally {
      hideLoader();
    }
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
    try {
      showLoader();

      final provider = context.read<ExpertiseProvider>();

      await provider.fetchExpertise();
      final expertises = provider.expertise;

      final store = SecureStorage();
      await store.saveTags(expertises);

      _showSuccessModal('Tags updated');
    } catch (error) {
      _showErrorModal(error.toString());
    } finally {
      hideLoader();
    }
  }

  void _healthcheck() async {
    try {
      showLoader();

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
    } finally {
      hideLoader();
    }
  }

  void _clearData() async {
    await context.read<UserProvider>().clearData();

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

  void _deleteAccount() async {
    showCustomSnackBar(
      context,
      "This feature is under development",
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.yellow[300],
    );
  }

  void _showSuccessModal(String message) {
    showCustomSnackBar(
      context,
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  void _showErrorModal(String error) {
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
