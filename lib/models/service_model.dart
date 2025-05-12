import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/tag_model.dart';

class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double price;
  final PricingType pricingType;
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
    required this.price,
    required this.pricingType,
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
      price:
          double.tryParse(json['price'].toString().replaceAll(",", "")) ?? 0.0,
      pricingType: () {
        switch (json['pricingType']) {
          case 'fixed':
            return PricingType.fixed;
          case 'per_hour':
            return PricingType.perHour;
          case 'per_day':
            return PricingType.perDay;
          default:
            return PricingType.fixed;
        }
      }(),
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

  ServiceModel copyWith({
    String? title,
    String? description,
    double? price,
    PricingType? pricingType,
    List<TagModel>? tags,
    List<ServiceExtraModel>? extras,
  }) {
    return ServiceModel(
      id: id,
      vendorId: vendorId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      pricingType: pricingType ?? this.pricingType,
      tags: tags ?? this.tags,
      extras: extras ?? this.extras,
      location: location,
      images: images,
      disabled: disabled,
    );
  }
}
