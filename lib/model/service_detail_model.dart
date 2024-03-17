import 'package:nearby_assist/model/service_photos.dart';

class ServiceDetailModel {
  int id;
  int vendorId;
  String title;
  String description;
  String vendorName;
  String vendorImage;
  String serviceRate;
  String rating;
  String vendorRole;
  List<ServicePhoto> photos;
  dynamic reviewCountMap;

  ServiceDetailModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.vendorName,
    required this.vendorImage,
    required this.serviceRate,
    required this.rating,
    required this.vendorRole,
    required this.photos,
    required this.reviewCountMap,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['Id'],
      vendorId: json['VendorId'],
      title: json['Title'],
      description: json['Description'],
      vendorName: json['VendorName'],
      vendorImage: json['VendorImage'],
      serviceRate: json['Rate'],
      rating: json['Rating'],
      vendorRole: json['VendorRole'],
      photos: (json['Photos'] as List)
          .map((photo) => ServicePhoto.fromJson(photo))
          .toList(),
      reviewCountMap: json['ReviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'vendorName': vendorName,
      'vendorImage': vendorImage,
      'serviceRate': serviceRate,
      'rating': rating,
      'vendorRole': vendorRole,
    };
  }
}
