class ServiceModel {
  String id;
  String vendor;
  String description;
  double latitude;
  double longitude;

  ServiceModel({
    required this.id,
    required this.vendor,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      vendor: json['vendor'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
