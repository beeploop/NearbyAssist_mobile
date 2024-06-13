class VendorInfoModel {
  int vendorId;
  String vendor;
  String imageUrl;
  double rating;
  String job;

  VendorInfoModel({
    required this.vendorId,
    required this.vendor,
    required this.imageUrl,
    required this.rating,
    required this.job,
  });

  factory VendorInfoModel.fromJson(Map<String, dynamic> json) {
    return VendorInfoModel(
      vendorId: json['vendorId'],
      vendor: json['vendor'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      job: json['job'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'vendor': vendor,
      'imageUrl': imageUrl,
      'rating': rating,
      'job': job,
    };
  }
}
