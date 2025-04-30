import 'dart:convert';

import 'package:nearby_assist/models/social_model.dart';

class VendorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final double rating;
  final List<String> expertise;
  final List<SocialModel> socials;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.expertise,
    required this.socials,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      expertise:
          json['expertise'] == null ? [] : List<String>.from(json['expertise']),
      socials: ((json['socials'] ?? []) as List)
          .map((social) => SocialModel.fromJson(social))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'rating': rating,
      'expertise': expertise,
      'socials': jsonEncode(socials.map((social) => social.toJson()).toList()),
    };
  }
}
