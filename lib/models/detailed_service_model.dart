import 'package:nearby_assist/models/rating_count_model.dart';
import 'package:nearby_assist/models/service_image_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class DetailedServiceModel {
  final RatingCountModel ratingCount;
  ServiceModel service;
  final VendorModel vendor;

  DetailedServiceModel({
    required this.ratingCount,
    required this.service,
    required this.vendor,
  });

  factory DetailedServiceModel.fromJson(Map<String, dynamic> json) {
    return DetailedServiceModel(
      ratingCount: RatingCountModel.fromJson(json['countPerRating']),
      service: ServiceModel.fromJson(json['service']),
      vendor: VendorModel.fromJson(json['vendor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingCount': ratingCount.toJson(),
      'service': service.toJson(),
      'vendor': vendor.toJson(),
    };
  }

  DetailedServiceModel copyWithUpdatedService(ServiceModel service) {
    this.service = service;
    return this;
  }

  DetailedServiceModel copyWithNewImages(List<ServiceImageModel> images) {
    service.images = images;
    return this;
  }
}
