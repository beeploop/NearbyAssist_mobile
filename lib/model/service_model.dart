class Service {
  String id;
  double suggestability;
  int rank;
  String vendor;
  double latitude;
  double longitude;

  Service({
    required this.id,
    required this.suggestability,
    required this.rank,
    required this.vendor,
    required this.latitude,
    required this.longitude,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      suggestability: json['suggestability'],
      rank: json['rank'],
      vendor: json['vendor'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': suggestability,
      'rank': rank,
      'vendor': vendor,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
