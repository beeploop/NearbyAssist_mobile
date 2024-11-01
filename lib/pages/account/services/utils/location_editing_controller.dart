import 'package:latlong2/latlong.dart';

class LocationEditingController {
  LatLng _location;

  LocationEditingController({
    required initialLocation,
  }) : _location = initialLocation;

  LatLng get location => _location;

  void setLocation(LatLng location) {
    _location = location;
  }
}
