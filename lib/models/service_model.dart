import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/tag_model.dart';

class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final double latitude;
  final double longitude;
  final List<TagModel> tags;
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
      rate: double.tryParse(json['rate'].toString().replaceAll(",", "")) ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      tags: json['tags'] == null
          ? []
          : (json['tags'] as List)
              .map((tag) => TagModel.fromJson(tag))
              .toList(),
      extras: json['extras'] == null
          ? []
          : (json['extras'] as List)
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
      'tags': tags.map((extra) => extra.title).toList(),
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
