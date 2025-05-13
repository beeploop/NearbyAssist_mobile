import 'package:nearby_assist/models/service_model.dart';

class SearchResultModel {
  String id;
  String vendorName;
  double suggestibility;
  double price;
  double rating;
  double latitude;
  double longitude;
  int completedBookings;
  double distance;
  ServiceModel? service;

  SearchResultModel({
    required this.id,
    required this.vendorName,
    required this.suggestibility,
    required this.price,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.completedBookings,
    required this.distance,
    this.service,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'],
      vendorName: json['vendorName'],
      suggestibility: double.parse(json['suggestibility'].toString()),
      price: double.tryParse(json['price']) ?? 0.0,
      rating: double.tryParse(json['rating']) ?? 0.0,
      latitude: json['latitude'],
      longitude: json['longitude'],
      completedBookings: int.parse(json['completedBookings'].toString()),
      distance: double.parse(json['distance'].toString()),
      service: ServiceModel.fromJson(json['service']),
    );
  }
}
