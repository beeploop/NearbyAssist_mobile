import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class MapLocationService extends ChangeNotifier {
  LatLng? _location;

  void clear() {
    _location = null;
    notifyListeners();
  }

  String getLatlongString() {
    if (_location == null) {
      return '';
    }
    return '${_location!.latitude}, ${_location!.longitude}';
  }

  LatLng? getLocation() {
    return _location;
  }

  void setLocation(LatLng location) {
    _location = location;
    notifyListeners();
  }
}
