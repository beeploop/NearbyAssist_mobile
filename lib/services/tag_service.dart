import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/utils/pretty_json.dart';

class TagService {
  Future<List<ExpertiseModel>> getExpertiseWithTags() async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.expertiseList);

      logger.log(prettyJSON(response.data));

      return (response.data['expertises'] as List)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList();
    } catch (error) {
      logger.log('Error getting expertise with tags: ${error.toString()}');
      rethrow;
    }
  }
}
