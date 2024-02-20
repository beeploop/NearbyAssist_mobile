import 'package:flutter/material.dart';
import 'package:nearby_assist/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _customButton(
              'Login with features',
              () => AuthService.login(context),
            ),
            _customButton(
              'Login without features',
              () => AuthService.mockLogin(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, Function() controller) {
    return ElevatedButton.icon(
      onPressed: () async {
        await controller();
      },
      icon: const Icon(
        Icons.facebook,
        color: Colors.white,
      ),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blue),
      ),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
