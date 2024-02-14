import 'package:flutter/material.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthModel extends ChangeNotifier {
  AuthStatus _isLoggedIn = AuthStatus.unauthenticated;

  AuthStatus getLoginStatus() {
    return _isLoggedIn;
  }

  void login() {
    _isLoggedIn = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
