import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/backend_login_response.dart';
import 'package:nearby_assist/model/request/logout_request.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/request/dio_request.dart';
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

  static Future<BackendLoginResponse?> _loginToBackend(
      FacebookLoginResponse user) async {
    try {
      final request = DioRequest();
      final response = await request.post(
        "/backend/auth/client/login",
        jsonEncode(user),
        requireAuth: false,
        expectedStatus: HttpStatus.created,
      );

      final loginResponse = BackendLoginResponse.fromJson(response.data);

      return loginResponse;
    } catch (e) {
      debugPrint('server responded with an error on login: $e');
      return null;
    }
  }

  static logout(BuildContext context) async {
    try {
      await _logoutToBackend();

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

  static Future<void> _logoutToBackend() async {
    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('User not logged in');
      }

      final logoutRequest = LogoutRequest(token: tokens.refreshToken);

      final request = DioRequest();
      final response = await request.post(
        "/backend/auth/logout",
        jsonEncode(logoutRequest),
      );

      print(response.data);
    } catch (e) {
      debugPrint('server responded with an error on logout: $e');
      rethrow;
    }
  }
}
