import 'dart:convert';

import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/request/token.dart';
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
    final user = UserInfo.fromJson(userJson);

    return UserInfo(
      userId: user.userId,
      name: user.name,
      email: user.email,
      image: user.image,
    );
  }

  Future<void> saveTokens(Token token) async {
    final tokenJson = jsonEncode(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokens', tokenJson);
  }

  Future<Token?> retrieveTokens() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTokens = prefs.getString('tokens');
    if (savedTokens == null) {
      return null;
    }

    final tokenJson = jsonDecode(savedTokens);
    final tokens = Token.fromJson(tokenJson);

    return tokens;
  }

  Future<void> loadData() async {
    final user = await retrieveUser();
    if (user != null) {
      getIt.get<AuthModel>().saveUser(user);
    }

    final savedTokens = await retrieveTokens();
    if (savedTokens != null) {
      getIt.get<AuthModel>().setUserTokens(savedTokens);
    }
  }

  Future<Exception?> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    final isUserRemoved = await prefs.remove('userInfo');
    final isTokensRemoved = await prefs.remove('tokens');

    if (isUserRemoved != true || isTokensRemoved != true) {
      return Exception("failed to clear user data");
    }

    return null;
  }
}
