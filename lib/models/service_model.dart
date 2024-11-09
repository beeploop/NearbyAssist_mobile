class ServiceModel {
  final String id;
  final String vendorId;
  final String description;
  final double rate;
  final double latitude;
  final double longitude;
  final List<String> tags;

  ServiceModel({
    required this.id,
    required this.vendorId,
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
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
    );
  }
}
