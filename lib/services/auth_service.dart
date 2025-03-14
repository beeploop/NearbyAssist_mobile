import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/third_party_login_payload_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/diffie_hellman.dart';
import 'package:nearby_assist/services/one_signal_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class AuthService {
  Future<UserModel> thirdPartyLogin(ThirdPartyLoginPayloadModel payload) async {
    try {
      final signedUser = await _serverLoginViaThirdParty(payload);

      final store = SecureStorage();
      await store.saveUser(signedUser);

      final dh = DiffieHellman();
      await dh.register();

      return signedUser;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel> _serverLoginViaThirdParty(
      ThirdPartyLoginPayloadModel payload) async {
    try {
      final api = ApiService.unauthenticated();
      final response = await api.dio.post(
        endpoint.thirdPartyLogin,
        data: payload.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      final store = SecureStorage();
      await store.saveToken(TokenType.accessToken, accessToken);
      await store.saveToken(TokenType.refreshToken, refreshToken);

      return UserModel.fromJson(response.data['user']);
    } catch (error) {
      logger.log('Error on login: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _signOutToServer();

      final store = SecureStorage();
      await store.clearAll();

      OneSignalService().updateUser(null);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _signOutToServer() async {
    try {
      final store = SecureStorage();
      final refreshToken = await store.getToken(TokenType.refreshToken);
      if (refreshToken == null) {
        throw Exception('NoToken');
      }

      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.logout,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (error) {
      logger.log('Error on logout: ${error.toString()}');
      rethrow;
    }
  }
}
