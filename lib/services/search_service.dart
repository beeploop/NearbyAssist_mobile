import 'package:geolocator/geolocator.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class SearchService {
  Future<List<SearchResultModel>> findServices({
    required Position userPos,
    required List<String> tags,
  }) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.search, queryParameters: {
        'q': tags.map((tag) => tag.replaceAll(' ', '_')).join(','),
        'l': '${userPos.latitude},${userPos.longitude}',
      });

      return (response.data['services'] as List).map((service) {
        return SearchResultModel.fromJson(service);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }
}
