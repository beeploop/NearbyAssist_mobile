import 'package:nearby_assist/models/tag_model.dart';

class RecommendationModel {
  String id;
  String vendorId;
  String vendor;
  String thumbnail;
  String title;
  String description;
  double rating;
  double rate;
  List<TagModel> tags;

  RecommendationModel({
    required this.id,
    required this.vendorId,
    required this.vendor,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.rating,
    required this.rate,
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
      rate: double.tryParse(json['rate'].toString().replaceAll(",", "")) ?? 0.0,
      tags: ((json['tags'] ?? []) as List)
          .map((tag) => TagModel.fromJson(tag))
          .toList(),
    );
  }
}
