import 'package:nearby_assist/models/rating_count_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class DetailedServiceModel {
  final RatingCountModel ratingCount;
  final ServiceModel service;
  final VendorModel vendor;
  final List<ServiceImageModel> images;

  DetailedServiceModel({
    required this.ratingCount,
    required this.service,
    required this.vendor,
    required this.images,
  });

  factory DetailedServiceModel.fromJson(Map<String, dynamic> json) {
    return DetailedServiceModel(
      ratingCount: RatingCountModel.fromJson(json['countPerRating']),
      service: ServiceModel.fromJson(json['serviceInfo']),
      vendor: VendorModel.fromJson(json['vendorInfo']),
      images: (json['serviceImages'] as List)
          .map((image) => ServiceImageModel.fromJson(image))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingCount': ratingCount.toJson(),
      'service': service.toJson(),
      'vendor': vendor.toJson(),
      'images': List.from(
        images.map((image) => image.toJson()).toList(),
      )
    };
  }
}
