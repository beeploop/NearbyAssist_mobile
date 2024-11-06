import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/login/tester_settings_modal.dart';
import 'package:nearby_assist/providers/auth_provider.dart';
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
            icon: const Icon(CupertinoIcons.gear),
            onPressed: () => _showTesterSettings(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: 160,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png'),
                    const Text(
                      "NearbyAssist",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
    return TextButton.icon(
      onPressed: _login,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue[500]),
      ),
      icon: const Icon(
        Icons.facebook_outlined,
        color: Colors.white,
      ),
      label: const Text(
        "Continue with Facebook",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      _onLoginSuccess(fakeUser);
    } catch (error) {
      _showErrorModal(error.toString());
    }
  }

  void _onLoginSuccess(UserModel user) {
    context.read<AuthProvider>().login(user);
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
