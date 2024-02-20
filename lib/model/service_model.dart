import 'package:latlong2/latlong.dart';

class Service {
  String address;
  LatLng location;
  int ownerId;

  Service({
    required this.address,
    required this.location,
    required this.ownerId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      address: json['address'],
      location: json['location'],
      ownerId: json['ownderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'location': location,
      'ownerId': ownerId,
    };
  }
}
