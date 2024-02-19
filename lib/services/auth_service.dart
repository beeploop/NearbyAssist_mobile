import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:http/http.dart' as http;

enum AuthResult { success, failed }

class AuthService {
  static void mockLogin(BuildContext context) async {
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

    await _registerUser(user);

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

  static Future<void> _registerUser(UserInfo user) async {
    try {
      final resp = await http.post(
        Uri.parse('$backendServer/v1/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );
      if (resp.statusCode == 201) {
        debugPrint('user registered');
        return;
      }

      throw Exception(resp.body);
    } catch (e) {
      debugPrint('server responded with an error: $e');
    }
  }
}
