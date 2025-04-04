import 'package:latlong2/latlong.dart';
import 'package:nearby_assist/models/tag_model.dart';

class UpdateServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final List<TagModel> tags;
  final LatLng location;

  UpdateServiceModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.tags,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'tags': tags.map((tag) => tag.title).toList(),
      'location': location,
    };
  }
}
