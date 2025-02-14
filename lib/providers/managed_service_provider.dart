import 'package:flutter/foundation.dart';
import 'package:nearby_assist/models/add_extra_model.dart';
import 'package:nearby_assist/models/detailed_service_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/update_service_model.dart';
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

  DetailedServiceModel getServiceUnsafe(String id) {
    return _serviceDetails[id]!;
  }

  Future<void> addService(ServiceModel service) async {
    final response = await ManageServicesService().add(service);

    _services[response.id] = response;
    notifyListeners();
  }

  Future<void> updateService(
      UpdateServiceModel updatedData, List<ServiceExtraModel> extras) async {
    await ManageServicesService().update(updatedData);

    final service = ServiceModel(
      id: updatedData.id,
      vendorId: updatedData.vendorId,
      title: updatedData.title,
      description: updatedData.description,
      rate: updatedData.rate,
      tags: updatedData.tags,
      extras: extras,
      latitude: updatedData.latitude,
      longitude: updatedData.longitude,
    );

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

  Future<void> addExtra(AddExtraModel newExtra) async {
    final response = await ManageServicesService().addExtra(newExtra);

    final detail = await getService(newExtra.serviceId);
    detail.service.extras.add(response);

    final updatedService = ServiceModel(
      id: detail.service.id,
      vendorId: detail.service.vendorId,
      title: detail.service.title,
      description: detail.service.description,
      rate: detail.service.rate,
      extras: detail.service.extras,
      tags: detail.service.tags,
      latitude: detail.service.latitude,
      longitude: detail.service.longitude,
    );

    _services[updatedService.id] = updatedService;

    if (_serviceDetails.containsKey(updatedService.id)) {
      final old = _serviceDetails[updatedService.id]!;
      final updated = old.copyWithUpdatedService(updatedService);
      _serviceDetails[updated.service.id] = updated;
    }

    notifyListeners();
  }

  Future<void> deleteServiceExtra(String serviceId, String extraId) async {
    await ManageServicesService().deleteExtra(extraId);

    final detail = await getService(serviceId);

    detail.service.extras.removeWhere((extra) => extra.id == extraId);

    final updatedService = ServiceModel(
      id: detail.service.id,
      vendorId: detail.service.vendorId,
      title: detail.service.title,
      description: detail.service.description,
      rate: detail.service.rate,
      extras: detail.service.extras,
      tags: detail.service.tags,
      latitude: detail.service.latitude,
      longitude: detail.service.longitude,
    );

    _services[updatedService.id] = updatedService;

    if (_serviceDetails.containsKey(updatedService.id)) {
      final old = _serviceDetails[updatedService.id]!;
      final updated = old.copyWithUpdatedService(updatedService);
      _serviceDetails[updated.service.id] = updated;
    }

    notifyListeners();
  }

  Future<void> editServiceExtra(
      String serviceId, ServiceExtraModel updatedExtra) async {
    await ManageServicesService().updateExtra(updatedExtra);

    final detail = await getService(serviceId);

    final updatedService = ServiceModel(
      id: detail.service.id,
      vendorId: detail.service.vendorId,
      title: detail.service.title,
      description: detail.service.description,
      rate: detail.service.rate,
      tags: detail.service.tags,
      extras: detail.service.extras.map((extra) {
        if (extra.id != updatedExtra.id) {
          return extra;
        }

        return ServiceExtraModel(
          id: extra.id,
          title: updatedExtra.title,
          description: updatedExtra.description,
          price: updatedExtra.price,
        );
      }).toList(),
      latitude: detail.service.latitude,
      longitude: detail.service.longitude,
    );

    _services[updatedService.id] = updatedService;

    if (_serviceDetails.containsKey(updatedService.id)) {
      final old = _serviceDetails[updatedService.id]!;
      final updated = old.copyWithUpdatedService(updatedService);
      _serviceDetails[updated.service.id] = updated;
    }

    notifyListeners();
  }
}
