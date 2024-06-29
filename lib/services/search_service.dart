import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/location_service.dart';

class SearchingService extends ChangeNotifier {
  bool _searching = false;
  List<Service> _serviceLocations = [];
  String _searchTerm = '';
  double _radius = 200;

  void _toggleSearching(bool val) {
    _searching = val;
    notifyListeners();
  }

  bool isSearching() => _searching;

  double getRadius() => _radius;

  void setRadius(double val) {
    if (val <= 100) {
      _radius = 100;
    } else {
      _radius = val;
    }
    notifyListeners();
  }

  void updateSearch(BuildContext context) async {
    // Get the user's location if not yet gotten
    final hasLocationPermission =
        await getIt.get<LocationService>().checkPermissions(context);
    if (hasLocationPermission == false) {
      return;
    }

    _toggleSearching(true);

    await getIt.get<LocationService>().getCurrentLocation();

    final result = await _fetchServices();
    _serviceLocations = result;
    notifyListeners();

    _toggleSearching(false);
  }

  Future<void> searchService(BuildContext context, String search) async {
    search = search.trim();
    if (search.isEmpty) return;
    _searchTerm = search;

    // Get the user's location if not yet gotten
    final hasLocationPermission =
        await getIt.get<LocationService>().checkPermissions(context);
    if (hasLocationPermission == false) {
      return;
    }

    _toggleSearching(true);

    await getIt.get<LocationService>().getCurrentLocation();

    final result = await _fetchServices();
    _serviceLocations = result;
    notifyListeners();

    _toggleSearching(false);

    if (context.mounted) {
      context.goNamed('map');
    }
  }

  String lastSearch() => _searchTerm;

  Future<List<Service>> _fetchServices() async {
    final location = getIt.get<LocationService>().getLocation();

    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('error retrieving user token');
      }

      final url =
          '/backend/v1/public/services/search?q=$_searchTerm&lat=${location.latitude}&long=${location.longitude}&radius=$_radius';

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['services'];
      return data.map((service) {
        return Service.fromJson(service);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching service: $e');
      return [];
    }
  }

  List<Service> getServiceLocations() => _serviceLocations;
}
