import 'package:nearby_assist/models/expertise_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;
  bool isVendor;
  String? address;
  double? latitude;
  double? longitude;
  List<ExpertiseModel> expertise;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
    required this.isVendor,
    this.address,
    this.latitude,
    this.longitude,
    required this.expertise,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      isVerified: json['isVerified'],
      isVendor: json['isVendor'],
      address: json['address'] == "" ? null : json['address'],
      latitude: json['latitude'] == 0 ? null : json['latitude'],
      longitude: json['longitude'] == 0 ? null : json['longitude'],
      expertise: json['expertises'] == null
          ? []
          : (json['expertises'] as List)
              .map((e) => ExpertiseModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'isVendor': isVendor,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'expertise': expertise.map((e) => e.toJson()).toList(),
    };
  }
}
