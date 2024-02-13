import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  dynamic _userInfo;

  void setLoggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  bool getLoginStatus() {
    return _isLoggedIn;
  }

  void setUserInfo(UserInfo user) {
    _userInfo = user;
    notifyListeners();
  }

  UserInfo getUserInfo() => _userInfo as UserInfo;
}

class UserInfo {
  String name;
  String email;

  UserInfo({
    required this.name,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}
