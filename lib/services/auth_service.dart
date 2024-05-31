import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/backend_login_response.dart';
import 'package:nearby_assist/model/request/logout_request.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:http/http.dart' as http;
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/services/data_manager_service.dart';

enum AuthResult { success, failed }

class AuthService {
  static Future<void> loginToFacebook(BuildContext context) async {
    try {
      final resp = await FacebookAuth.instance.login();

      if (resp.status == LoginStatus.failed) {
        throw Exception('Facebook login failed');
      }

      final facebookUserData = await FacebookAuth.instance.getUserData();
      final user = FacebookLoginResponse.fromJson(facebookUserData);

      final loginResponse = await _loginToBackend(user);
      if (loginResponse == null) {
        throw Exception('Login failed');
      }

      final completeUserData = UserInfo(
        name: user.name,
        email: user.email,
        image: user.image,
        userId: loginResponse.userId,
      );

      final tokens = Token(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      await getIt.get<DataManagerService>().saveUser(completeUserData);
      await getIt.get<DataManagerService>().saveTokens(tokens);

      getIt.get<AuthModel>().saveUser(completeUserData);
      getIt.get<AuthModel>().setUserTokens(tokens);

      if (context.mounted) {
        context.goNamed('home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
      }
    }
  }

  static logout(BuildContext context) async {
    try {
      final logoutResponse = await _logoutToBackend();
      if (logoutResponse != null) {
        throw logoutResponse;
      }

      await FacebookAuth.instance.logOut();

      getIt.get<AuthModel>().logout();
      final clearDataResponse =
          await getIt.get<DataManagerService>().clearData();
      if (clearDataResponse != null) {
        throw clearDataResponse;
      }

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

  static Future<BackendLoginResponse?> _loginToBackend(
      FacebookLoginResponse user) async {
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();

    try {
      final resp = await http.post(
        Uri.parse('$serverAddr/backend/auth/client/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );
      if (resp.statusCode != 201) {
        throw Exception(resp.body);
      }

      final response = jsonDecode(resp.body);
      final loginResponse = BackendLoginResponse.fromJson(response);

      return loginResponse;
    } catch (e) {
      debugPrint('server responded with an error on login: $e');
      return null;
    }
  }

  static Future<Exception?> _logoutToBackend() async {
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();
    final tokens = getIt.get<AuthModel>().getUserTokens();

    if (tokens == null) {
      return Exception('User not logged in');
    }

    final logoutRequest = LogoutRequest(token: tokens.refreshToken);

    try {
      final resp = await http.post(
        Uri.parse('$serverAddr/backend/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(logoutRequest),
      );

      if (resp.statusCode != 200) {
        throw Exception(resp.body);
      }

      return null;
    } catch (e) {
      debugPrint('server responded with an error on logout: $e');
      return Exception(e);
    }
  }
}
