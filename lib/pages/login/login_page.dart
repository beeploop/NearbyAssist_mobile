import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/login/tester_settings_modal.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
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
              ),
              const SizedBox(height: 60),
              _loginButton(),
              const Spacer(),
              Text(appVersion, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return FilledButton.icon(
      onPressed: _login,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.green.shade900),
      ),
      icon: const FaIcon(
        FontAwesomeIcons.google,
        color: Colors.white,
        size: 16,
      ),
      label: const Text(
        "Continue with Google",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      final gAuth = GoogleAuthService();
      final gUser = await gAuth.login();

      final auth = AuthService();
      final user = await auth.login(gUser);

      _onLoginSuccess(user);
    } on GoogleNullUserException catch (error) {
      _showErrorModal(error.message);
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _onLoginSuccess(UserModel user) {
    context.read<UserProvider>().login(user);
    context.goNamed('search');
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
