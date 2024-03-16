class VendorModel {
  String name;
  String role;
  double rating;
  dynamic reviewCount;
  Map<int, int> reviewCountMap = {};

  VendorModel({
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewCount,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      name: json['Name'],
      role: json['Role'],
      rating: json['Rating'],
      reviewCount: json['ReviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
