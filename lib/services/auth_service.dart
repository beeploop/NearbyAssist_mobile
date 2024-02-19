import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/user_info.dart';

enum AuthResult { success, failed }

class AuthService {
  static void mockLogin(BuildContext context) {
    getIt.get<AuthModel>().login(mockUser);
    if (context.mounted) {
      context.goNamed('home');
    }
  }

  static Future<void> login(BuildContext context) async {
    final resp = await FacebookAuth.instance.login();

    if (resp.status == LoginStatus.failed) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
      }
    }

    final userData = await FacebookAuth.instance.getUserData();
    UserInfo user = UserInfo.fromJson(userData);

    getIt.get<AuthModel>().login(user);

    if (context.mounted) {
      context.goNamed('home');
    }
  }

  static logout(BuildContext context) async {
    await FacebookAuth.instance.logOut();
    getIt.get<AuthModel>().logout();

    if (context.mounted) {
      context.goNamed('login');
    }
  }
}
