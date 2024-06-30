import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:nearby_assist/services/storage_service.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthModel extends ChangeNotifier {
  AuthStatus _isLoggedIn = AuthStatus.unauthenticated;
  UserInfo? _userInfo;
  Token? _userTokens;

  Future<void> saveTokens(Token token) async {
    _userTokens = token;
    await getIt.get<StorageService>().saveTokens(token);
    notifyListeners();
  }

  Token getTokens() {
    if (_userTokens == null) {
      throw Exception("No token to retrieve");
    }

    return _userTokens!;
  }

  UserInfo getUser() {
    if (_userInfo == null) {
      throw Exception("No user to retrieve");
    }

    return _userInfo!;
  }

  int getUserId() {
    if (_userInfo == null) {
      throw Exception("Cannot retrieve user id because no user is saved");
    }

    return _userInfo!.userId;
  }

  AuthStatus getLoginStatus() {
    return _isLoggedIn;
  }

  Future<void> saveUser(UserInfo user) async {
    _userInfo = user;
    _isLoggedIn = AuthStatus.authenticated;

    await getIt.get<StorageService>().saveUser(user);

    notifyListeners();
  }

  Future<void> logout() async {
    _userInfo = null;
    _isLoggedIn = AuthStatus.unauthenticated;
    _userTokens = null;

    await getIt.get<StorageService>().clearData();

    notifyListeners();
  }
}
