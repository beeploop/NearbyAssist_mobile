import 'package:nearby_assist/models/location_model.dart';

class ChangeAddressModel {
  String address;
  LocationModel location;

  ChangeAddressModel({
    required this.address,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'location': location.toJson(),
    };
  }
}
