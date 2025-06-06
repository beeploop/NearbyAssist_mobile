import 'package:geolocator/geolocator.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/location_service.dart';

class SearchService {
  Future<List<SearchResultModel>> findServices({
    required Position location,
    required List<String> tags,
    required double radius,
    required bool boundless,
  }) async {
    try {
      final api = ApiService.authenticated();
      final response = await api.dio.get(endpoint.search, queryParameters: {
        'q': tags.map((tag) => tag.replaceAll(' ', '_')).join(','),
        'l': '${location.latitude},${location.longitude}',
        'r': radius,
        'boundless': boundless,
        'preference': SystemSettingProvider()
            .criteriaRanking
            .map((criteria) => criteria.identifier)
            .join(','),
      });

      return (response.data['services'] as List).map((service) {
        return SearchResultModel.fromJson(service);
      }).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<DetailedServiceModel> getServiceDetails(
    String id, {
    bool fresh = false,
  }) async {
    logger.logDebug('called getServiceDetails in search_service.dart');

    try {
      final api = ApiService.authenticated();

      final response = switch (fresh) {
        true => await api.dio.get(
            '${endpoint.serviceDetails}/$id',
            queryParameters: {'fresh': 'true'},
          ),
        false => await api.dio.get('${endpoint.serviceDetails}/$id'),
      };

      return DetailedServiceModel.fromJson(response.data['detail']);
    } catch (error) {
      logger.logError(error.toString());
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
