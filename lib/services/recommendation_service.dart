import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';

class RecommendationService {
  final defaultLimit = 4;

  Future<dynamic> fetchRecommendations() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(
        endpoint.recommendations,
        queryParameters: {"limit": defaultLimit},
      );

      return response.data;
    } catch (error) {
      logger.logDebug(error.toString());
      rethrow;
    }
  }
}
