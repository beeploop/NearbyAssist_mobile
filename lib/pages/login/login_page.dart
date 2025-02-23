import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/pages/login/tester_settings_modal.dart';
import 'package:nearby_assist/pages/widget/clickable_text.dart';
import 'package:nearby_assist/pages/widget/google_login_button.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis),
            onPressed: () => _showTesterSettings(),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const SizedBox(height: 60),

                _logo(),
                const SizedBox(height: 60),

                // Login Button
                const GoogleLoginButton(),
                const SizedBox(height: 20),

                // Privacy Policy and T&C
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClickableText(
                        text: '',
                        clickableText: 'Privacy Policy',
                        onClick: () =>
                            _launchUrl(Uri.parse(endpoint.privacyPolicy)),
                      ),
                      const VerticalDivider(),
                      ClickableText(
                        text: '',
                        clickableText: 'Terms & Condition',
                        onClick: () => _launchUrl(
                          Uri.parse(endpoint.termsAndConditions),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Bottom padding
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: const AutoSizeText(
          appVersion,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _logo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Column(
          children: [
            Image.asset('assets/icon/login-icon.png'),
            Text(
              "NearbyAssist",
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 90,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      _onError('Could not open URL');
    }
  }

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      textColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showTesterSettings() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: double.infinity,
        child: const TesterSettingsModal(),
      ),
    );
  }
}
