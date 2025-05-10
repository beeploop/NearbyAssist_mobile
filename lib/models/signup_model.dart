import 'package:nearby_assist/config/constants.dart';

class SignupModel {
  String name;
  String email;
  String imageURL;
  String phone;
  String address;
  double latitude;
  double longitude;

  SignupModel({
    required this.name,
    required this.email,
    required this.imageURL,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
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
    };
  }

  void selfValidate() {
    if (name.isEmpty ||
        email.isEmpty ||
        imageURL.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        latitude == 0.0 ||
        longitude == 0.0) {
      throw "Don't leave empty fields";
    }

    if (phone.length != phoneNumberLength) {
      throw "Invalid phone number";
    }
  }
}
