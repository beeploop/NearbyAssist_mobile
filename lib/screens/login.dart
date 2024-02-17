import 'package:flutter/material.dart';
import 'package:nearby_assist/controller/auth_controller.dart';

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
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     debugPrint('facebook login');
            //     await AuthController.login(context);
            //   },
            //   icon: const Icon(
            //     Icons.facebook,
            //     color: Colors.white,
            //   ),
            //   style: const ButtonStyle(
            //     backgroundColor: MaterialStatePropertyAll(Colors.blue),
            //   ),
            //   label: const Text(
            //     'Login with Facebook',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     debugPrint('mock login');
            //     AuthController.mockLogin(context);
            //   },
            //   icon: const Icon(
            //     Icons.facebook,
            //     color: Colors.white,
            //   ),
            //   style: const ButtonStyle(
            //     backgroundColor: MaterialStatePropertyAll(Colors.blue),
            //   ),
            //   label: const Text(
            //     'Mock Facebook Login',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            _customButton(
              'Login with Facebook',
              () => AuthController.login(context),
            ),
            _customButton(
              'Mock Login',
              () => AuthController.mockLogin(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customButton(String text, Function() controller) {
    return ElevatedButton.icon(
      onPressed: () async {
        debugPrint(text);
        // AuthController.mockLogin(context);
        await controller();
      },
      icon: const Icon(
        Icons.facebook,
        color: Colors.white,
      ),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blue),
      ),
      label: const Text(
        'Mock Facebook Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
