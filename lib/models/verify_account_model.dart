import 'package:flutter/foundation.dart';
import 'package:nearby_assist/config/constants.dart';
import 'package:nearby_assist/config/valid_id.dart';

class VerifyAccountModel {
  String name;
  String phone;
  String address;
  double latitude;
  double longitude;
  ValidID idType;
  String referenceNumber;
  Uint8List frontId;
  Uint8List backId;
  Uint8List selfie;

  VerifyAccountModel({
    required this.name,
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
        phone.isEmpty ||
        address.isEmpty ||
        idType == ValidID.none ||
        referenceNumber.isEmpty ||
        latitude == 0.0 ||
        longitude == 0.0) {
      throw "Don't leave empty fields";
    }

    if (phone.length != phoneNumberLength) {
      throw "Invalid phone number";
    }
  }
}
