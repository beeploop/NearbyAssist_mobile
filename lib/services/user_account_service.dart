import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/social_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class UserAccountService {
  Future<SocialModel> addSocial(NewSocial social) async {
    try {
      final api = ApiService.authenticated();
      final response =
          await api.dio.post(endpoint.addSocial, data: social.toJson());

      return SocialModel(
        id: response.data['id'],
        site: social.site,
        title: social.title,
        url: social.url,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSocial(String id) async {
    try {
      final api = ApiService.authenticated();
      await api.dio.delete('${endpoint.deleteSocial}/$id');
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
      logger.logError(error.toString());
      rethrow;
    }
  }
}
