import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class AuthService {
  Future<UserModel> login() async {
    try {
      final api = ApiService.unauthenticated();
      final response = await api.dio.post(
        endpoint.login,
        data: fakeUser.toJson(),
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      final store = SecureStorage();
      await store.store(TokenType.accessToken, accessToken);
      await store.store(TokenType.refreshToken, refreshToken);

      return UserModel.fromJson(response.data['user']);
    } catch (error) {
      logger.log('Error on login: ${error.toString()}');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final store = SecureStorage();
      final refreshToken = await store.get(TokenType.refreshToken);
      if (refreshToken == null) {
        throw Exception('NoToken');
      }

      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.logout,
        data: {'refreshToken': refreshToken},
      );
    } catch (error) {
      logger.log('Error on logout: ${error.toString()}');
      rethrow;
    }
  }
}
