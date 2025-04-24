import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/tag_model.dart';

class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final List<TagModel> tags;
  final List<ServiceExtraModel> extras;
  List<ServiceImageModel> images;
  final LocationModel location;
  bool disabled;

  ServiceModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.tags,
    required this.extras,
    required this.images,
    required this.location,
    required this.disabled,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      rate: double.tryParse(json['rate'].toString().replaceAll(",", "")) ?? 0.0,
      tags: ((json['tags'] ?? []) as List)
          .map((tag) => TagModel.fromJson(tag))
          .toList(),
      extras: ((json['extras'] ?? []) as List)
          .map((extra) => ServiceExtraModel.fromJson(extra))
          .toList(),
      images: ((json['images'] ?? []) as List)
          .map((image) => ServiceImageModel.fromJson(image))
          .toList(),
      location: LocationModel.fromJson(json['location']),
      disabled: json['disabled'],
    );
  }
}
