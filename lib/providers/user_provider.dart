import 'package:flutter/foundation.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/change_address_model.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/social_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/one_signal_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';
import 'package:nearby_assist/services/user_account_service.dart';
import 'package:nearby_assist/services/vendor_application_service.dart';

enum AuthStatus { authenticated, unauthenticated }

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user ?? placeHolderUser;

  AuthStatus get status =>
      _user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;

  Future<void> updateUser(UserModel user) async {
    _user = user;
    SecureStorage().saveUser(user);
    notifyListeners();
  }

  void login(UserModel user) {
    _user = user;
    OneSignalService().updateUser(user);
    notifyListeners();
  }

  Future<void> syncAccount() async {
    try {
      final service = UserAccountService();
      final user = await service.syncAccount();

      await SecureStorage().saveUser(user);
      _user = user;

      notifyListeners();
    } catch (error, trace) {
      logger.logError(error.toString());
      logger.logError(trace);
      rethrow;
    }
  }

  Future<void> addSocial(NewSocial data) async {
    try {
      if (_user == null) {
        throw 'null user';
      }

      final service = UserAccountService();
      final social = await service.addSocial(data);

      _user!.socials.add(social);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSocial(String socialId) async {
    try {
      if (_user == null) {
        throw 'null user';
      }

      await UserAccountService().removeSocial(socialId);

      _user!.socials.removeWhere((social) => social.id == socialId);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addExpertise(
      ExpertiseModel expertise, Uint8List supportingDoc) async {
    try {
      final service = VendorApplicationService();
      await service.applyAgain(
        expertiseId: expertise.id,
        supportingDoc: supportingDoc,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDBL(int value) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.post('${endpoint.udpateDBL}/$value');

      _user?.dbl = value;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeAddress(String address) async {
    try {
      final location = await LocationService().getLocation();

      final data = ChangeAddressModel(
        address: address,
        location: LocationModel(
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );

      final api = ApiService.authenticated();
      await api.dio.put(endpoint.changeAddress, data: data.toJson());

      _user?.address = address;
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
