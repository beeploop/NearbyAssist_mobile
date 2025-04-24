import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/models/service_review_model.dart';
import 'package:nearby_assist/models/vendor_model.dart';

class DetailedServiceModel {
  ServiceModel service;
  final VendorModel vendor;
  final List<int> ratings;
  final List<ServiceReviewModel> reviews;

  DetailedServiceModel({
    required this.service,
    required this.vendor,
    required this.ratings,
    required this.reviews,
  });

  factory DetailedServiceModel.fromJson(Map<String, dynamic> json) {
    return DetailedServiceModel(
      service: ServiceModel.fromJson(json['service']),
      vendor: VendorModel.fromJson(json['vendor']),
      ratings: List.from(json['ratings']),
      reviews: List.from((json['reviews'] as List)
          .map((review) => ServiceReviewModel.fromJson(review))
          .toList()),
    );
  }
}
