import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/widgets/bottom_modal_settings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt.get<AuthService>(),
      builder: (context, _) {
        final loading = getIt.get<AuthService>().isLoading();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () => _openBottomModal(),
                    icon: const Icon(Icons.info_outlined),
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLoginButton(
                      text: "Continue with FaceBook",
                      icon: Icons.facebook_outlined,
                      color: Colors.blue,
                      onPress: () => _login(context),
                    ),
                  ],
                ),
              ),
            ),
            if (loading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.grey),
              ),
            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      if (kDebugMode) {
        final data = await getIt.get<AuthService>().backendLogin(fakeUser);
        final tokens = Token(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );

        await getIt.get<AuthModel>().saveUser(data.user);
        await getIt.get<AuthModel>().saveTokens(tokens);
      } else {
        final user = await getIt.get<AuthService>().facebookLogin();
        final data = await getIt.get<AuthService>().backendLogin(user);
        final tokens = Token(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );

        await getIt.get<AuthModel>().saveUser(data.user);
        await getIt.get<AuthModel>().saveTokens(tokens);
      }

      final dh = DiffieHellman();
      await dh.register();

      if (context.mounted) {
        context.goNamed('home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error logging in with Facebook. Error: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  void _openBottomModal() {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: const BottomModalSetting(),
      ),
    );
  }
}

class CustomLoginButton extends StatelessWidget {
  const CustomLoginButton({
    super.key,
    required this.onPress,
    required this.text,
    required this.icon,
    this.color,
    this.textColor,
    this.iconColor,
  });

  final Future<void> Function() onPress;
  final String text;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await onPress();
      },
      icon: Icon(
        icon,
        color: iconColor ?? Colors.white,
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color ?? Colors.green),
      ),
      label: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
    );
  }
}
