import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/reverse_geocoding_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class GeocodingService {
  Future<ReverseGeocodingModel> lookupAddress(
      double latitude, double longitude) async {
    logger.logDebug('called lookupAddress in geocoding_service.dart');

    try {
      final api = ApiService.unauthenticated();
      final response = await api.dio.get(
        endpoint.reverseGeocoding,
        queryParameters: {
          'format': 'json',
          'lat': latitude,
          'lon': longitude,
          'addressdetails': 1,
          'zoom': 18,
        },
      );

      return ReverseGeocodingModel.fromJson(response.data);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
