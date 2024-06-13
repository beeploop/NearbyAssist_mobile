import 'package:flutter/material.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:nearby_assist/services/request/authenticated_request.dart';

class RoutingService extends ChangeNotifier {
  Future<List<List<num>>> findRoute(int serviceId) async {
    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('No tokens found');
      }

      final location = getIt.get<LocationService>().getLocation();

      final request = AuthenticatedRequest<Map<String, dynamic>>(
        accessToken: tokens.accessToken,
      );
      final endpoint =
          '/backend/v1/public/services/route/$serviceId?origin=${location.latitude},${location.longitude}';
      final response = await request.getRequest(endpoint);

      final polyline = decodePolyline(response['polyline']);
      return polyline;
    } catch (e) {
      debugPrint('Error: $e');
      return [];
    }
  }
}
