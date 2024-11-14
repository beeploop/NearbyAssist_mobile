class VendorModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final double rating;
  final bool restricted;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.rating,
    required this.restricted,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      restricted: json['restricted'] == 1 ? true : false,
    );
  }
}
