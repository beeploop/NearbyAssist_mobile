import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/services/manage_services_service.dart';

class ManagedServiceProvider extends ChangeNotifier {
  final Map<String, ServiceModel> _services = {};
  Map<String, DetailedServiceModel> _serviceDetails = {};

  List<ServiceModel> getServices() {
    return _services.values.toList().reversed.toList();
  }

  Future<DetailedServiceModel> getService(String id) async {
    if (_serviceDetails.containsKey(id)) {
      return _serviceDetails[id]!;
    }

    try {
      final service = ManageServicesService();
      final response = await service.getService(id);

      _serviceDetails[id] = response;
      notifyListeners();

      return response;
    } catch (error) {
      rethrow;
    }
  }

  void add(ServiceModel service) {
    _services[service.id] = service;
    notifyListeners();
  }

  void update(ServiceModel service) {
    _services[service.id] = service;

    if (_serviceDetails.containsKey(service.id)) {
      final old = _serviceDetails[service.id]!;
      final updated = old.copyWithUpdatedService(service);
      _serviceDetails[updated.service.id] = updated;
    }

    notifyListeners();
  }

  Future<void> refreshServices(String id) async {
    try {
      final service = ManageServicesService();
      final response = await service.fetchServices(id);

      for (var service in response.services) {
        _services[service.id] = service.toServiceModel(response.vendor.id);
      }

      _serviceDetails = {};

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
