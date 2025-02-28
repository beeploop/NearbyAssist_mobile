class VendorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final double rating;
  final bool isRestricted;
  final List<String> expertise;
  final List<String> socials;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.isRestricted,
    required this.expertise,
    required this.socials,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating']),
      isRestricted: json['isRestricted'] == 1 ? true : false,
      expertise:
          json['expertise'] == null ? [] : List<String>.from(json['expertise']),
      socials:
          json['socials'] == null ? [] : List<String>.from(json['socials']),
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
      'socials': socials,
    };
  }
}
