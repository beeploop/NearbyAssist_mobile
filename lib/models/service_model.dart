class ServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final double latitude;
  final double longitude;
  final List<String> tags;

  ServiceModel({
    this.id = '',
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    this.tags = const [],
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
    };
  }

  ServiceModel copyWithNewId(String newId) {
    return ServiceModel(
      id: newId,
      vendorId: vendorId,
      title: title,
      description: description,
      rate: rate,
      latitude: latitude,
      longitude: longitude,
      tags: tags,
    );
  }
}
