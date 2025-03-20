import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class DetailedVendorModel {
  VendorModel vendor;
  List<ServiceModel> services;

  DetailedVendorModel({
    required this.vendor,
    required this.services,
  });

  factory DetailedVendorModel.fromJson(Map<String, dynamic> json) {
    return DetailedVendorModel(
      vendor: VendorModel.fromJson(json['vendor']),
      services: List<ServiceModel>.from(
        (json['services'] as List)
            .map((service) => ServiceModel.fromJson(service)),
      ),
    );
  }
}
