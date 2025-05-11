import 'package:nearby_assist/models/service_model.dart';

class SearchResultModel {
  String id;
  String vendorName;
  double suggestionScore;
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
    required this.suggestionScore,
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
      suggestionScore: double.parse(json['suggestionScore'].toString()),
      price: double.parse(json['price'].toString()),
      rating: double.parse(json['rating'].toString()),
      latitude: json['latitude'],
      longitude: json['longitude'],
      completedBookings: int.parse(json['completedBookings'].toString()),
      distance: double.parse(json['distance'].toString()),
      service: ServiceModel.fromJson(json['service']),
    );
  }
}
