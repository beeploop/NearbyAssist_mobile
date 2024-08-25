class MyService {
  String id;
  String vendorId;
  String description;
  double rate;
  double latitude;
  double longitude;

  MyService({
    required this.id,
    required this.vendorId,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
  });

  factory MyService.fromJson(Map<String, dynamic> json) {
    return MyService(
      id: json['id'],
      vendorId: json['vendorId'],
      description: json['description'],
      rate: double.parse(json['rate']),
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
