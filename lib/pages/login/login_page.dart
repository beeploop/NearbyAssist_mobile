import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';
import 'package:nearby_assist/pages/login/tester_settings_modal.dart';
import 'package:nearby_assist/pages/login/verification/verification_page.dart';
import 'package:nearby_assist/pages/login/widget/login_page_logo.dart';
import 'package:nearby_assist/pages/widget/clickable_text.dart';
import 'package:nearby_assist/pages/widget/google_auth_button.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:provider/provider.dart';
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
            onPressed: _showTesterMenu,
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

                const LoginPageLogo(),
                const SizedBox(height: 60),

                // Signin with Google
                GoogleAuthButton(
                  label: 'Login with Google',
                  successCallback: _handleLogin,
                  errorCallback: _onError,
                ),
                const SizedBox(height: 20),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 10),
                    Text('or'),
                    SizedBox(width: 10),
                    Expanded(child: Divider())
                  ],
                ),
                const SizedBox(height: 20),

                // Signup with Google
                GoogleAuthButton(
                  filled: false,
                  label: 'Signup with Google',
                  successCallback: _handleRegister,
                  errorCallback: _onError,
                ),
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

  Future<void> _handleLogin(ThirdPartyLoginPayloadModel user) async {
    try {
      final userProvider = context.read<UserProvider>();

      final loggedInUser = await AuthService().signin(user);
      userProvider.login(loggedInUser);

      if (!mounted) return;
      context.goNamed('search');
    } on DioException catch (error) {
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      showGenericErrorModal(context, message: error.toString());
    }
  }

  void _handleRegister(ThirdPartyLoginPayloadModel user) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VerificationPage(
          user: user,
          onSuccessCallback: () => context.goNamed('search'),
        ),
      ),
    );
  }

  void _showTesterMenu() {
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
}
