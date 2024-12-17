import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/secure_storage.dart';

enum AuthStatus { authenticated, unauthenticated }

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  AuthStatus get status =>
      _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

  Future<void> login(UserModel user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  Future<void> tryLoadUser() async {
    try {
      final store = SecureStorage();
      final user = await store.getUser();

      login(user);
    } catch (error) {
      logger.log('No logged in user');
      rethrow;
    }
  }

  Future<void> clearData() async {
    final store = SecureStorage();
    await store.clearAll();

    await logout();
  }
}
