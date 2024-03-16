class Service {
  int id;
  String title;
  String description;
  int rate;
  double latitude;
  double longitude;
  int ownerId;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['Id'],
      title: json['Title'],
      description: json['Description'],
      rate: json['Rate'],
      latitude: json['Latitude'] as double,
      longitude: json['Longitude'] as double,
      ownerId: json['Vendor'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rate': rate,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
    };
  }
}
