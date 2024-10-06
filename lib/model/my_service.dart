class MyService {
  String id;
  String vendorId;
  String description;
  String rate;
  String latitude;
  String longitude;
  List<String> tags = [];

  MyService({
    required this.id,
    required this.vendorId,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    required this.tags,
  });

  factory MyService.fromJson(Map<String, dynamic> json) {
    return MyService(
      id: json['id'],
      vendorId: json['vendorId'],
      description: json['description'],
      rate: json['rate'] as String,
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      tags: (json['tags'] as List).map((tag) => tag.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'description': description,
      'rate': rate,
      'latitude': double.parse(latitude),
      'longitude': double.parse(longitude),
      'tags': tags,
    };
  }
}
