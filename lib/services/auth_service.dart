import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/backend_login_response.dart';
import 'package:nearby_assist/model/request/logout_request.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/request/dio_request.dart';

enum AuthResult { success, failed }

class AuthService {
  static Future<void> loginToFacebook() async {
    try {
      final resp = await FacebookAuth.instance.login();

      if (resp.status == LoginStatus.failed) {
        throw Exception('Facebook login failed');
      }

      final facebookUserData = await FacebookAuth.instance.getUserData();
      final user = FacebookLoginResponse.fromJson(facebookUserData);

      final loginResponse = await _loginToBackend(user);

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

      await getIt.get<AuthModel>().saveUser(completeUserData);
      await getIt.get<AuthModel>().saveTokens(tokens);
    } catch (e) {
      debugPrint('error login to facebook: $e');
      rethrow;
    }
  }

  static Future<BackendLoginResponse> _loginToBackend(
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
      debugPrint('error login to backend: $e');
      rethrow;
    }
  }

  static logout() async {
    try {
      await _logoutToBackend();

      await FacebookAuth.instance.logOut();
      await getIt.get<AuthModel>().logout();
    } catch (e) {
      debugPrint('error logging out: ${e.toString()}');
      rethrow;
    }
  }

  static Future<void> _logoutToBackend() async {
    try {
      final tokens = getIt.get<AuthModel>().getTokens();
      debugPrint('logging out with token: ${tokens.refreshToken}');

      final request = DioRequest();
      final response = await request.post(
        "/backend/auth/logout",
        jsonEncode(LogoutRequest(
          token: tokens.refreshToken,
        )),
      );

      debugPrint(response.data["message"]);
    } catch (e) {
      debugPrint('Error on logout: $e');
      rethrow;
    }
  }
}
