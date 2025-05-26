import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class LocationEditingController extends ChangeNotifier {
  bool _hasChanged = false;
  LatLng _location;

  LocationEditingController({
    required LatLng initialLocation,
  }) : _location = initialLocation;

  LatLng get location => _location;
  bool get hasChanged => _hasChanged;

  void setLocation(LatLng location) {
    _location = location;
    _hasChanged = true;
    notifyListeners();
  }
}
