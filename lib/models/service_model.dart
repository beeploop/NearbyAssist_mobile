import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';

enum ServiceStatus {
  underReview(title: 'under_review'),
  accepted(title: 'accepted'),
  rejected(title: 'rejected');

  const ServiceStatus({required this.title});
  final String title;
}

class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double price;
  final PricingType pricingType;
  final List<String> tags;
  final List<ServiceExtraModel> extras;
  List<ServiceImageModel> images;
  final LocationModel location;
  bool disabled;
  ServiceStatus status;
  String rejectReason;

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
    required this.status,
    required this.rejectReason,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString().replaceAll(",", "").trim()),
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
      tags:
          ((json['tags'] ?? []) as List).map((tag) => tag.toString()).toList(),
      extras: ((json['extras'] ?? []) as List)
          .map((extra) => ServiceExtraModel.fromJson(extra))
          .toList(),
      images: ((json['images'] ?? []) as List)
          .map((image) => ServiceImageModel.fromJson(image))
          .toList(),
      location: LocationModel.fromJson(json['location']),
      disabled: json['disabled'],
      status: () {
        switch (json['status']) {
          case 'under_review':
            return ServiceStatus.underReview;
          case 'accepted':
            return ServiceStatus.accepted;
          case 'rejected':
            return ServiceStatus.rejected;
          default:
            return ServiceStatus.underReview;
        }
      }(),
      rejectReason: json['rejectReason'],
    );
  }

  ServiceModel copyWith({
    String? title,
    String? description,
    double? price,
    PricingType? pricingType,
    List<String>? tags,
    List<ServiceExtraModel>? extras,
    ServiceStatus? status,
    String? rejectReason,
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
      status: status ?? this.status,
      rejectReason: rejectReason ?? this.rejectReason,
    );
  }
}
