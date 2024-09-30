import 'package:flutter/foundation.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/location_service.dart';

class RoutingService extends ChangeNotifier {
  final Map<String, List<List<num>>> _routeCache = {};

  Future<List<List<num>>> getRoute(String serviceId) async {
    try {
      if (!_routeCache.containsKey(serviceId)) {
        if (kDebugMode) {
          print("Routing service cache miss");
        }

        final route = await _findRoute(serviceId);
        _routeCache[serviceId] = route;

        return route;
      }

      if (kDebugMode) {
        print("Routing service cache hit");
      }
      return _routeCache[serviceId]!;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<List<num>>> _findRoute(String serviceId) async {
    try {
      final location = getIt.get<LocationService>().getLocation();

      final url =
          '/api/v1/services/route/$serviceId?origin=${location.latitude},${location.longitude}';
      final request = DioRequest();
      final response = await request.get(url);

      return decodePolyline(response.data['polyline']);
    } catch (err) {
      rethrow;
    }
  }
}
