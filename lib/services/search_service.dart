import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/services/feature_flag_service.dart';
import 'package:nearby_assist/services/location_service.dart';
import 'package:http/http.dart' as http;

class SearchingService extends ChangeNotifier {
  bool _searching = false;
  List<Service> _serviceLocations = [];
  String _searchTerm = '';

  void _toggleSearching(bool val) {
    _searching = val;
    notifyListeners();
  }

  bool isSearching() => _searching;

  Future<void> searchService(BuildContext context, String search) async {
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

    if (getIt.get<FeatureFlagService>().backendConnection) {
      await _fetchServices();
    }

    _toggleSearching(false);

    if (context.mounted) {
      context.goNamed('map');
    }
  }

  String lastSearch() => _searchTerm;

  Future<void> _fetchServices() async {
    final location = getIt.get<LocationService>().getLocation();

    try {
      final resp = await http.get(
        Uri.parse(
            '$backendServer/v1/locations/vicinity?lat=${location.latitude}&long=${location.longitude}'),
      );

      if (resp.statusCode != 200) {
        throw HttpException(
            'request responded with status code: ${resp.statusCode}');
      }

      List services = jsonDecode(resp.body);
      for (var service in services) {
        final s = Service.fromJson(service);
        _serviceLocations.add(s);
      }
    } catch (e) {
      debugPrint('$e');
      _serviceLocations = [];
    }

    notifyListeners();
  }

  List<Service> getServiceLocations() => _serviceLocations;
}
