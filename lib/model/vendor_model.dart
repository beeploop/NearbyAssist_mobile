class VendorModel {
  String name;
  double rating;
  dynamic reviewCount;
  Map<int, int> reviewCountMap = {};

  VendorModel({
    required this.name,
    required this.rating,
    required this.reviewCount,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      name: json['Name'],
      rating: json['Rating'],
      reviewCount: json['ReviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
