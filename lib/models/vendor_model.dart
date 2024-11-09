class VendorModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String job;

  VendorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.job,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['vendorId'],
      name: json['vendor'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      job: json['job'],
    );
  }
}
