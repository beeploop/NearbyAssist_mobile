class Service {
  String address;
  double latitude;
  double longitude;
  int ownerId;

  Service({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      address: json['Address'],
      latitude: json['Latitude'] as double,
      longitude: json['Longitude'] as double,
      ownerId: json['OwnerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'ownerId': ownerId,
    };
  }
}
