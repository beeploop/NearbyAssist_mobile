class ServiceInfoModel {
  String id;
  String description;
  double rate;
  double latitude;
  double longitude;
  List<String> tags;

  ServiceInfoModel({
    required this.id,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    required this.tags,
  });

  factory ServiceInfoModel.fromJson(Map<String, dynamic> json) {
    return ServiceInfoModel(
      id: json['id'],
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'rate': rate,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
    };
  }
}
