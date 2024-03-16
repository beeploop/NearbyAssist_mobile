class VendorModel {
  int id;
  String name;
  String role;
  double rating;
  dynamic reviewCount;
  Map<int, int> reviewCountMap = {};

  VendorModel({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviewCount,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['Id'],
      name: json['Name'],
      role: json['Role'],
      rating: json['Rating'],
      reviewCount: json['ReviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}
