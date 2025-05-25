import 'package:nearby_assist/models/new_extra.dart';
import 'package:nearby_assist/models/pricing_type.dart';

class NewService {
  final String vendorId;
  final String title;
  final String description;
  final double price;
  final PricingType pricingType;
  final List<String> tags;
  final List<NewExtra> extras;

  NewService({
    required this.vendorId,
    required this.title,
    required this.description,
    required this.price,
    required this.pricingType,
    required this.tags,
    required this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'price': price.toString(),
      'pricingType': pricingType.name,
      'tags': tags.map((tag) => tag).toList(),
      'extras': extras.map((extra) => extra.toJson()).toList(),
    };
  }
}
