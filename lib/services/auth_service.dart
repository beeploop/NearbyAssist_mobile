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
import 'package:nearby_assist/services/data_manager_service.dart';
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
      getIt.get<DataManagerService>().saveAccessToken(resp.accessToken!);

      final userData = await FacebookAuth.instance.getUserData();
      UserInfo user = UserInfo.fromJson(userData);

      final loginResponse = await _loginUser(user);
      user.userId = loginResponse?.userId;

      getIt.get<AuthModel>().login(user);
      getIt.get<DataManagerService>().saveUser(user);
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
      final res = await _logoutUser();
      if (res != null) {
        throw res;
      }

      await FacebookAuth.instance.logOut();
      getIt.get<AuthModel>().logout();
      getIt.get<DataManagerService>().clearData();

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

  static Future<LoginResponse?> _loginUser(UserInfo user) async {
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

      final response = jsonDecode(resp.body);
      LoginResponse loginResponse = LoginResponse.fromJson(response);

      return loginResponse;
    } catch (e) {
      debugPrint('server responded with an error on login: $e');
      return null;
    }
  }

  static Future<Exception?> _logoutUser() async {
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
      return null;
    } catch (e) {
      debugPrint('server responded with an error on logout: $e');
      return Exception(e);
    }
  }
}

class LoginResponse {
  String token;
  int userId;

  LoginResponse({
    required this.token,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userId: json['userId'],
    );
  }
}
