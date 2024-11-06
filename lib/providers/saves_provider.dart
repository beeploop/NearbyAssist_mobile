import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/service_model.dart';

class SavesProvider extends ChangeNotifier {
  final List<ServiceModel> _saves = [];

  List<ServiceModel> get saves => _saves;

  void save(ServiceModel service) {
    _saves.add(service);
    notifyListeners();
  }

  void unsave(ServiceModel service) {
    _saves.removeWhere((item) => item.id == service.id);
    notifyListeners();
  }

  bool includes(String id) {
    for (int i = 0; i < _saves.length; i++) {
      if (_saves[i].id == id) {
        return true;
      }
    }
    return false;
  }
}
