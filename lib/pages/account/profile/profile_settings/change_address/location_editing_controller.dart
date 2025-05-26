import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/main.dart';

class LocationEditingController extends ChangeNotifier {
  LatLng _location;

  LocationEditingController({
    required LatLng initialLocation,
  }) : _location = initialLocation;

  LatLng get location => _location;

  void setLocation(LatLng location) {
    logger.logDebug(
        'location updated to: ${location.latitude} ${location.longitude}');
    _location = location;
    notifyListeners();
  }
}
