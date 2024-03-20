import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/services/feature_flag_service.dart';

enum AuthResult { success, failed }

class AuthService {
  static void mockLogin(BuildContext context) async {
    getIt.get<FeatureFlagService>().backendConnection = false;
    getIt.get<AuthModel>().login(mockUser);

    if (context.mounted) {
      context.goNamed('home');
    }
  }

  static Future<void> login(BuildContext context) async {
    getIt.get<FeatureFlagService>().backendConnection = true;

    try {
      final resp = await FacebookAuth.instance.login();

      if (resp.status == LoginStatus.failed) {
        throw Exception('Facebook login failed');
      }

      getIt.get<AuthModel>().setAccessToken(resp.accessToken!);

      final userData = await FacebookAuth.instance.getUserData();
      UserInfo user = UserInfo.fromJson(userData);

      getIt.get<AuthModel>().login(user);

      await _loginUser(user);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
      }
    }

    if (context.mounted) {
      context.goNamed('home');
    }
  }

  static logout(BuildContext context) async {
    try {
      _logoutUser();

      await FacebookAuth.instance.logOut();
      getIt.get<AuthModel>().logout();
      getIt.get<AuthModel>().setAccessToken(null);

      if (context.mounted) {
        context.goNamed('login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot logout at the moment'),
          ),
        );
      }
    }
  }

  static Future<void> _loginUser(UserInfo user) async {
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();

    try {
      final resp = await http.post(
        Uri.parse('$serverAddr/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );
      if (resp.statusCode != 201) {
        throw Exception(resp.body);
      }

      debugPrint('user registered: ${resp.body}');
    } catch (e) {
      debugPrint('server responded with an error on login: $e');
    }
  }

  static Future<void> _logoutUser() async {
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();
    final user = getIt.get<AuthModel>().getUser();

    try {
      final resp = await http.post(
        Uri.parse('$serverAddr/v1/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );

      if (resp.statusCode != 200) {
        throw Exception(resp.body);
      }

      debugPrint('user logged out: ${resp.body}');
    } catch (e) {
      debugPrint('server responded with an error on logout: $e');
    }
  }
}
