import 'package:nearby_assist/main.dart';
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
}
