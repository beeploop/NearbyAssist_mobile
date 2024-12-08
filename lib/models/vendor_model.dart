class VendorModel {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final double rating;
  final bool isRestricted;
  final List<String> expertise;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.rating,
    required this.isRestricted,
    required this.expertise,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      isRestricted: json['isRestricted'] == 1 ? true : false,
      expertise:
          json['expertise'] == null ? [] : List<String>.from(json['expertise']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'rating': rating,
      'isRestricted': isRestricted,
      'expertise': expertise,
    };
  }
}
