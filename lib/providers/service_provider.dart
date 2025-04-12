import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/search_result_model.dart';
import 'package:nearby_assist/services/search_service.dart';

class ServiceProvider extends ChangeNotifier {
  List<SearchResultModel> _services = [];
  final Map<String, DetailedServiceModel> _serviceDetails = {};

  List<SearchResultModel> getServices() => _services;

  Future<DetailedServiceModel> getService(
    String id, {
    bool fresh = false,
  }) async {
    try {
      if (!fresh) {
        if (_serviceDetails.containsKey(id)) {
          return _serviceDetails[id]!;
        }
      }

      final detail = await SearchService().getServiceDetails(id, fresh: fresh);
      _serviceDetails[id] = detail;
      notifyListeners();

      return detail;
    } catch (error) {
      rethrow;
    }
  }

  void replaceAll(List<SearchResultModel> services) {
    _services = services;
    notifyListeners();
  }
}
