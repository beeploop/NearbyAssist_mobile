import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/auth_service.dart';
import 'package:nearby_assist/services/google_auth_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _handleLoginWithGoogle,
      icon: const FaIcon(
        FontAwesomeIcons.google,
        color: Colors.white,
        size: 16,
      ),
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size.fromHeight(50),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      label: const Text(
        "Continue with Google",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _handleLoginWithGoogle() async {
    try {
      final gAuth = GoogleAuthService();
      final gUser = await gAuth.login();

      final auth = AuthService();
      final user = await auth.thirdPartyLogin(gUser);

      _onLoginSuccess(user);
    } on GoogleNullUserException catch (error) {
      _onError(error.message);
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    }
  }

  void _onLoginSuccess(UserModel user) {
    context.read<UserProvider>().login(user);
    context.goNamed('search');
  }

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
