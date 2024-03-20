import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManagerService {
  Future<void> saveUser(UserInfo user) async {
    final userJson = jsonEncode(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', userJson);
  }

  Future<UserInfo?> retrieveUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString('userInfo');
    if (userString == null) {
      return null;
    }

    final userJson = jsonDecode(userString);
    final user = User.fromJson(userJson);

    return UserInfo(
      userId: user.userId,
      name: user.name,
      email: user.email,
      imageUrl: user.imageUrl,
    );
  }

  Future<void> saveAccessToken(AccessToken token) async {
    final tokenJson = jsonEncode(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', tokenJson);
  }

  Future<AccessToken?> retrieveAccessToken() async {
    final prefs = await SharedPreferences.getInstance();

    final tokenString = prefs.getString('accessToken');
    if (tokenString == null) {
      return null;
    }

    final accessToken = jsonDecode(tokenString);
    final token = AccessToken.fromJson(accessToken);

    return token;
  }

  Future<void> loadData() async {
    final user = await retrieveUser();
    if (user != null) {
      getIt.get<AuthModel>().login(user);
    }

    final token = await retrieveAccessToken();
    if (token != null) {
      getIt.get<AuthModel>().setAccessToken(token);
    }
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('userInfo');
    await prefs.remove('accessToken');
  }
}

class User {
  String name;
  String email;
  String imageUrl;
  int userId;

  User({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
    );
  }
}
