import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class DetailedVendorModel {
  VendorModel vendor;
  List<Service> services;

  DetailedVendorModel({
    required this.vendor,
    required this.services,
  });

  factory DetailedVendorModel.fromJson(Map<String, dynamic> json) {
    return DetailedVendorModel(
      vendor: VendorModel.fromJson(json['vendor']),
      services: List<Service>.from(
        (json['services'] as List).map((service) => Service.fromJson(service)),
      ),
    );
  }
}

class Service {
  final String id;
  final String title;
  final String description;
  final String price;
  final double latitude;
  final double longitude;
  final List<String> tags;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.tags = const [],
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
    );
  }

  ServiceModel toServiceModel(String vendorId) {
    return ServiceModel(
      id: id,
      title: title,
      vendorId: vendorId,
      description: description,
      rate: double.parse(price),
      latitude: latitude,
      longitude: longitude,
      tags: tags,
    );
  }
}
