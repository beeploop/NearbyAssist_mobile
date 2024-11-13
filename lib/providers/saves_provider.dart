import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';

class SavesProvider extends ChangeNotifier {
  final Map<String, DetailedServiceModel> _saves = {};

  List<DetailedServiceModel> getSaves() {
    return List.from(List.from(_saves.values).reversed);
  }

  bool isSaved(String id) {
    return _saves.containsKey(id);
  }

  Future<void> refetchSaves() async {
    return Future.error('Unimplemented');
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
