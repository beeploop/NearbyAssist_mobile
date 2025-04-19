import 'package:flutter/foundation.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/one_signal_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:nearby_assist/services/user_account_service.dart';

enum AuthStatus { authenticated, unauthenticated }

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user ?? placeHolderUser;

  AuthStatus get status =>
      _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

  void login(UserModel user) {
    _user = user;
    OneSignalService().updateUser(user);
    notifyListeners();
  }

  Future<void> syncAccount() async {
    try {
      final service = UserAccountService();
      final user = await service.syncAccount();

      final store = SecureStorage();
      await store.saveUser(user);

      _user = user;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addSocial(String url) async {
    try {
      if (_user == null) {
        throw 'null user';
      }

      final service = UserAccountService();
      await service.addSocial(url);

      _user!.socials.add(url);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSocial(String url) async {
    try {
      if (_user == null) {
        throw 'null user';
      }

      final service = UserAccountService();
      await service.removeSocial(url);

      _user!.socials.removeWhere((social) => social == url);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    OneSignalService().updateUser(null);

    notifyListeners();
  }

  Future<void> tryLoadUser() async {
    try {
      final store = SecureStorage();
      final user = await store.getUser();

      login(user);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> clearData() async {
    final store = SecureStorage();
    await store.clearAll();

    await logout();
  }
}
