import 'package:nearby_assist/models/expertise_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;
  bool isVendor;
  bool isRestricted;
  String? address;
  String? phone;
  double? latitude;
  double? longitude;
  List<ExpertiseModel> expertise;
  List<String> socials;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
    required this.isVendor,
    required this.isRestricted,
    this.address,
    this.phone,
    this.latitude,
    this.longitude,
    required this.expertise,
    required this.socials,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      isVerified: json['isVerified'],
      isVendor: json['isVendor'],
      isRestricted: json['isRestricted'],
      address: json['address'] == "" ? null : json['address'],
      phone: json['phone'] == "" ? null : json['phone'],
      latitude: json['latitude'] == 0 ? null : json['latitude'],
      longitude: json['longitude'] == 0 ? null : json['longitude'],
      expertise: json['expertises'] == null
          ? []
          : (json['expertises'] as List)
              .map((e) => ExpertiseModel.fromJson(e))
              .toList(),
      socials:
          json['socials'] == null ? [] : List<String>.from(json['socials']),
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
      'isRestricted': isRestricted,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'expertises': expertise.map((e) => e.toJson()).toList(),
      'socials': socials,
    };
  }
}
