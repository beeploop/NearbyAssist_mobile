class ServiceInfoModel {
  int serviceId;
  String description;
  double rate;
  double latitude;
  double longitude;
  List<String> tags;

  ServiceInfoModel({
    required this.serviceId,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    required this.tags,
  });

  factory ServiceInfoModel.fromJson(Map<String, dynamic> json) {
    return ServiceInfoModel(
      serviceId: json['serviceId'],
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'description': description,
      'rate': rate,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
    };
  }
}
