import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:nearby_assist/config/constants.dart';

class LocationService extends ChangeNotifier {
  Location location = Location();
  LatLng _currentLocation = defaultLocation;

  LatLng getLocation() {
    return _currentLocation;
  }

  void _setLocation(double latitude, double longitude) {
    _currentLocation = LatLng(latitude, longitude);
    notifyListeners();
  }

  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    try {
      final locationData = await location.getLocation();
      _setLocation(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      debugPrint('=== error getting location: $e');
    }
  }
}
