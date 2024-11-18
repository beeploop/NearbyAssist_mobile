import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/services/saves_service.dart';

class SavesProvider extends ChangeNotifier {
  final Map<String, DetailedServiceModel> _saves = {};

  List<DetailedServiceModel> getSaves() {
    return List.from(List.from(_saves.values).reversed);
  }

  bool isSaved(String id) {
    return _saves.containsKey(id);
  }

  Future<void> refetchSaves() async {
    try {
      final saves = await SavesService().getSaves();

      for (final item in saves) {
        _saves[item.service.id] = item;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> save(DetailedServiceModel service) async {
    _saves[service.service.id] = service;
    notifyListeners();

    try {
      await SavesService().save(service);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> unsave(String id) async {
    _saves.remove(id);
    notifyListeners();

    try {
      await SavesService().unsave(id);
    } catch (error) {
      rethrow;
    }
  }
}
