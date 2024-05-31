import 'package:flutter/material.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/user_info.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthModel extends ChangeNotifier {
  AuthStatus _isLoggedIn = AuthStatus.unauthenticated;
  UserInfo? _userInfo;
  Token? _userTokens;

  void setUserTokens(Token token) {
    _userTokens = token;
    notifyListeners();
  }

  Token? getUserTokens() {
    return _userTokens;
  }

  AuthStatus getLoginStatus() {
    return _isLoggedIn;
  }

  void saveUser(UserInfo user) {
    _userInfo = UserInfo(
      userId: user.userId,
      name: user.name,
      email: user.email,
      image: user.image,
    );

    _isLoggedIn = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _userInfo = null;
    _isLoggedIn = AuthStatus.unauthenticated;
    _userTokens = null;

    notifyListeners();
  }

  UserInfo? getUser() {
    return _userInfo;
  }

  int? getUserId() {
    return _userInfo?.userId;
  }
}
