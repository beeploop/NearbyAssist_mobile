import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/location_service.dart';

class RoutingService extends ChangeNotifier {
  Future<List<List<num>>> findRoute(int serviceId) async {
    try {
      final location = getIt.get<LocationService>().getLocation();

      final url =
          '/v1/public/services/route/$serviceId?origin=${location.latitude},${location.longitude}';

      final request = DioRequest();
      final response = await request.get(url);

      return decodePolyline(response.data['polyline']);
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }
}
