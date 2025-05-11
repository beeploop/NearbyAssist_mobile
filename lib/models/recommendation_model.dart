import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/tag_model.dart';

class RecommendationModel {
  String id;
  String vendorId;
  String vendor;
  String thumbnail;
  String title;
  String description;
  double rating;
  double price;
  PricingType pricingType;
  List<TagModel> tags;

  RecommendationModel({
    required this.id,
    required this.vendorId,
    required this.vendor,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.rating,
    required this.price,
    required this.pricingType,
    required this.tags,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'],
      vendorId: json['vendorId'],
      vendor: json['vendor'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      description: json['description'],
      rating: double.parse(json['rating']),
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
    );
  }
}
