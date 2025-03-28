import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class TagService {
  Future<List<ExpertiseModel>> getExpertiseWithTags() async {
    logger.logDebug('called getExpertiseWithTags in tag_service.dart');

    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.expertiseList);

      return (response.data['expertises'] as List)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList();
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
