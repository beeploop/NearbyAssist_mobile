import 'package:nearby_assist/models/new_extra.dart';
import 'package:nearby_assist/models/tag_model.dart';

class NewService {
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final List<TagModel> tags;
  final List<NewExtra> extras;

  NewService({
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.tags,
    required this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'tags': tags.map((tag) => tag.title).toList(),
      'extras': extras.map((extra) => extra.toJson()).toList(),
    };
  }
}
