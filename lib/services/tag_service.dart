import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class TagService {
  Future<List<ExpertiseModel>> getExpertiseWithTags() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.expertiseList);

      return (response.data['expertises'] as List)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList();
    } catch (error) {
      logger.log('Error getting expertise with tags: ${error.toString()}');
      rethrow;
    }
  }
}
