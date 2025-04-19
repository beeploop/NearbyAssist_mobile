import 'dart:typed_data';

import 'package:nearby_assist/config/valid_id.dart';

class SignupModel {
  String name;
  String email;
  String imageURL;
  String phone;
  String address;
  double latitude;
  double longitude;
  ValidID idType;
  String referenceNumber;
  Uint8List frontId;
  Uint8List backId;
  Uint8List selfie;

  SignupModel({
    required this.name,
    required this.email,
    required this.imageURL,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.idType,
    required this.referenceNumber,
    required this.frontId,
    required this.backId,
    required this.selfie,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageURL,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'idType': idType.value,
      'referenceNumber': referenceNumber,
    };
  }

  void selfValidate() {
    if (name.isEmpty ||
        email.isEmpty ||
        imageURL.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        idType == ValidID.none ||
        referenceNumber.isEmpty ||
        latitude == 0.0 ||
        longitude == 0.0) {
      throw "Don't leave empty fields";
    }
  }
}
