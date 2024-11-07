import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/service_model.dart';

class ServicesProvider extends ChangeNotifier {
  final List<ServiceModel> _services = [
    testLocations[Random().nextInt(testLocations.length - 1)],
    testLocations[Random().nextInt(testLocations.length - 1)],
  ];

  List<ServiceModel> get services => _services;

  void add(ServiceModel service) {
    _services.add(service);
    notifyListeners();
  }

  void replaceAll(List<ServiceModel> services) {
    _services.clear();
    _services.addAll(services);
    notifyListeners();
  }

  ServiceModel getById(String id) {
    return _services.firstWhere((service) => service.id == id);
  }
}
