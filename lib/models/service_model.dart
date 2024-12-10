import 'package:nearby_assist/models/service_extra_model.dart';

class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final double latitude;
  final double longitude;
  final List<String> tags;
  final List<ServiceExtraModel> extras;

  ServiceModel({
    this.id = '',
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    this.tags = const [],
    this.extras = const [],
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
      extras: (json['extras'] as List)
          .map((extra) => ServiceExtraModel.fromJson(extra))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
      'extras': extras.map((extra) => extra.toJson()).toList(),
    };
  }

  ServiceModel copyWithNewId(String newId) {
    return ServiceModel(
      id: newId,
      vendorId: vendorId,
      title: title,
      description: description,
      rate: rate,
      latitude: latitude,
      longitude: longitude,
      tags: tags,
      extras: extras,
    );
  }
}
