import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/models/service_model.dart';

class ManagedServicesProvider extends ChangeNotifier {
  final List<ServiceModel> _services = [
    testLocations[Random().nextInt(testLocations.length - 1)],
  ];

  List<ServiceModel> get services => _services;

  void add(ServiceModel service) {
    _services.add(service);
    notifyListeners();
  }

  void edit(ServiceModel service) {
    //
  }
}
