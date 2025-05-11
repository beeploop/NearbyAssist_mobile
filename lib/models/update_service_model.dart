import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/tag_model.dart';

class UpdateServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double price;
  final PricingType pricingType;
  final List<TagModel> tags;

  UpdateServiceModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.price,
    required this.pricingType,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'price': price.toString(),
      'pricingType': pricingType.name,
      'tags': tags.map((tag) => tag.title).toList(),
    };
  }
}
