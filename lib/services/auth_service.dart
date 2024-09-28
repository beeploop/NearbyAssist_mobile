import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/backend_login_response.dart';
import 'package:nearby_assist/model/request/logout_request.dart';
import 'package:nearby_assist/model/request/facebook_login_response.dart';
import 'package:nearby_assist/request/dio_request.dart';

enum AuthResult { success, failed }

class AuthService extends ChangeNotifier {
  bool _loading = false;

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<FacebookLoginResponse> facebookLogin() async {
    _toggleLoading();

    try {
      final resp = await FacebookAuth.instance.login();

      if (resp.status == LoginStatus.failed) {
        throw Exception('Facebook login failed');
      }

      final facebookUserData = await FacebookAuth.instance.getUserData();
      return FacebookLoginResponse.fromJson(facebookUserData);
    } catch (e) {
      debugPrint('error login to facebook: $e');
      rethrow;
    } finally {
      _toggleLoading();
    }
  }

  Future<BackendLoginResponse> backendLogin(FacebookLoginResponse user) async {
    try {
      final request = DioRequest();
      final response = await request.post(
        "/api/v1/user/login",
        jsonEncode(user),
        requireAuth: false,
        expectedStatus: HttpStatus.created,
      );

      return BackendLoginResponse.fromJson(response.data);
    } catch (e) {
      debugPrint('error login to backend: $e');
      rethrow;
    }
  }

  logout() async {
    try {
      await backendLogout();

      await FacebookAuth.instance.logOut();
      await getIt.get<AuthModel>().logout();
    } catch (e) {
      debugPrint('error logging out: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> backendLogout() async {
    try {
      final tokens = getIt.get<AuthModel>().getTokens();
      debugPrint('logging out with token: ${tokens.refreshToken}');

      final request = DioRequest();
      final response = await request.post(
        "/api/v1/user/logout",
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
