import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class UserAccountService {
  Future<void> addSocial(String url) async {
    try {
      final api = ApiService.authenticated();

      await api.dio.post(
        endpoint.addSocial,
        data: {'url': url},
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSocial(String url) async {
    try {
      final api = ApiService.authenticated();

      await api.dio.delete(
        endpoint.deleteSocial,
        data: {'url': url},
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel> syncAccount() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.me);

      return UserModel.fromJson(response.data['user']);
    } catch (error) {
      rethrow;
    }
  }
}
