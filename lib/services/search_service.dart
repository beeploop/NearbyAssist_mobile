import 'package:geolocator/geolocator.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/location_service.dart';

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

  Future<DetailedServiceModel> getServiceDetails(String id) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get('${endpoint.serviceDetails}/$id');
      return DetailedServiceModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<List<num>>> getRouteToService(String id) async {
    try {
      final userPos = await LocationService().getLocation();

      final api = ApiService.authenticated();
      final response = await api.dio.get(
        '${endpoint.findRoute}/$id',
        queryParameters: {
          'origin': '${userPos.latitude},${userPos.longitude}',
        },
      );

      return decodePolyline(response.data['polyline']);
    } catch (error) {
      rethrow;
    }
  }
}
