import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/models/social_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;
  bool isVendor;
  bool isRestricted;
  String address;
  String phone;
  double? latitude;
  double? longitude;
  List<ExpertiseModel> expertise;
  List<SocialModel> socials;
  int dbl;
  bool hasPendingVerification;
  bool hasPendingApplication;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
    required this.isVendor,
    required this.isRestricted,
    required this.address,
    required this.phone,
    this.latitude,
    this.longitude,
    required this.expertise,
    required this.socials,
    required this.dbl,
    required this.hasPendingVerification,
    required this.hasPendingApplication,
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
      expertise: ((json['expertises'] ?? []) as List)
          .map((expertise) => ExpertiseModel.fromJson(expertise))
          .toList(),
      socials: ((json['socials'] ?? []) as List)
          .map((social) => SocialModel.fromJson(social))
          .toList(),
      dbl: json['dbl'],
      hasPendingVerification: json['hasPendingVerification'],
      hasPendingApplication: json['hasPendingApplication'],
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
      'socials': socials.map((social) => social.toJson()).toList(),
      'dbl': dbl,
      'hasPendingVerification': hasPendingVerification,
      'hasPendingApplication': hasPendingApplication,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
    bool? hasPendingVerification,
    bool? hasPendingApplication,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      imageUrl: imageUrl,
      isVendor: isVendor,
      isVerified: isVerified,
      isRestricted: isRestricted,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude,
      longitude: longitude,
      expertise: expertise,
      socials: socials,
      dbl: dbl,
      hasPendingVerification:
          hasPendingVerification ?? this.hasPendingVerification,
      hasPendingApplication:
          hasPendingApplication ?? this.hasPendingApplication,
    );
  }
}
