import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user';
  static const String _tokenKey = 'tokens';

  Future<void> saveUser(UserInfo user) async {
    final userJson = jsonEncode(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userJson);
  }

  Future<UserInfo> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final userString = prefs.getString(_userKey);
      if (userString == null) {
        throw Exception("No user saved");
      }

      final userJson = jsonDecode(userString);
      return UserInfo.fromJson(userJson);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<void> saveTokens(Token token) async {
    final tokenJson = jsonEncode(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, tokenJson);
  }

  Future<Token> retrieveTokens() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final savedTokens = prefs.getString(_tokenKey);
      if (savedTokens == null) {
        throw Exception("No tokens saved");
      }

      final tokenJson = jsonDecode(savedTokens);
      return Token.fromJson(tokenJson);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<void> loadData() async {
    try {
      final user = await getUser();
      getIt.get<AuthModel>().saveUser(user);

      final tokens = await retrieveTokens();
      getIt.get<AuthModel>().saveTokens(tokens);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      // rethrow;
    }
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}
