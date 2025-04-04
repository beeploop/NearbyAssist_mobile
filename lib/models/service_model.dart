import 'package:latlong2/latlong.dart';
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
  final LatLng location;

  ServiceModel({
    this.id = '',
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    this.tags = const [],
    this.extras = const [],
    this.images = const [],
    required this.location,
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
      location: LatLng.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'location': location,
      'tags': tags.map((extra) => extra.title).toList(),
      'extras': extras.map((extra) => extra.toJson()).toList(),
      'images': images.map((image) => image.toJson()).toList(),
    };
  }

  ServiceModel copyWithNewId(String newId) {
    return ServiceModel(
      id: newId,
      vendorId: vendorId,
      title: title,
      description: description,
      rate: rate,
      location: location,
      tags: tags,
      extras: extras,
      images: images,
    );
  }
}
