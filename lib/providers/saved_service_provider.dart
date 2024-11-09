import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';

class SavedServiceProvider extends ChangeNotifier {
  final Map<String, DetailedServiceModel> _saves = {};

  List<DetailedServiceModel> getSaves() {
    return List.from(_saves.values);
  }

  bool isSaved(String id) {
    return _saves.containsKey(id);
  }

  void save(DetailedServiceModel service) {
    _saves[service.service.id] = service;
    notifyListeners();
  }

  void unsave(String id) {
    _saves.remove(id);
    notifyListeners();
  }
}
