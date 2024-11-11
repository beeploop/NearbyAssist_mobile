import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/secure_storage.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  AuthStatus get status =>
      _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

  Future<void> login(UserModel user) async {
    _user = user;

    final store = SecureStorage();
    await store.saveUser(user);

    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;

    final store = SecureStorage();
    await store.clearAll();

    notifyListeners();
  }

  Future<void> tryLoadUser() async {
    final store = SecureStorage();
    final user = await store.getUser();
    if (user == null) {
      return;
    }

    login(user);
  }
}
