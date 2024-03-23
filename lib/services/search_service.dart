import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:http/http.dart' as http;

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
    final serverAddr = getIt.get<SettingsModel>().getServerAddr();

    try {
      final resp = await http.get(
        Uri.parse(
            '$serverAddr/v1/services/search?q=$_searchTerm&lat=${location.latitude}&long=${location.longitude}&radius=$_radius'),
      );

      if (resp.statusCode != 200) {
        throw HttpException(
            'request responded with status code: ${resp.statusCode}');
      }

      List<Service> result = [];
      List services = jsonDecode(resp.body);
      for (var service in services) {
        final s = Service.fromJson(service);
        result.add(s);
      }

      return result;
    } catch (e) {
      debugPrint('======= error fetching search result: $e');
      return [];
    }
  }

  List<Service> getServiceLocations() => _serviceLocations;
}
