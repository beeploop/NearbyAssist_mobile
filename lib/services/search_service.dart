import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/service_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/location_service.dart';

class SearchingService extends ChangeNotifier {
  bool _searching = false;
  List<Service> _serviceLocations = [];
  List<String> _tags = [];
  List<String> _selectedTags = [];

  void _toggleSearching(bool val) {
    _searching = val;
    notifyListeners();
  }

  bool isSearching() => _searching;

  void setTags(List<String> tags) {
    _tags = tags;
    notifyListeners();
  }

  List<String> getTags() => _tags;

  void addSelectedTag(List<String>? tags) {
    _selectedTags = tags ?? [];
    notifyListeners();
  }

  List<String> getSelectedTags() => _selectedTags;

  void updateSearch(BuildContext context) async {
    // Get the user's location if not yet gotten
    final hasLocationPermission =
        await getIt.get<LocationService>().checkPermissions();
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

  Future<void> searchService() async {
    try {
      _toggleSearching(true);

      // Get the user's location if not yet gotten
      final hasLocationPermission =
          await getIt.get<LocationService>().checkPermissions();
      if (hasLocationPermission == false) {
        //throw Exception("Location permission not granted");
        getIt.get<LocationService>().getCurrentLocation();
      }

      final result = await _fetchServices();
      _serviceLocations = result;
    } catch (err) {
      _serviceLocations.clear();
      rethrow;
    } finally {
      _toggleSearching(false);
      notifyListeners();
    }
  }

  Future<List<Service>> _fetchServices() async {
    try {
      final location = getIt.get<LocationService>().getLocation();

      if (_selectedTags.isEmpty) {
        throw Exception('No tags selected');
      }
      final tags = _selectedTags.map((e) => e.replaceAll(' ', '_')).join(',');

      final url =
          '/api/v1/services/search?q=$tags&l=${location.latitude},${location.longitude}';

      final request = DioRequest();
      final response = await request.get(url);

      List data = response.data['services'];
      return data.map((service) {
        return Service.fromJson(service);
      }).toList();
    } catch (err) {
      rethrow;
    }
  }

  List<Service> getServiceLocations() => _serviceLocations;
}
