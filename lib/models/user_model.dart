class UserModel {
  String id;
  String name;
  String email;
  String imageUrl;
  bool isVerified;
  bool isVendor;
  String? address;
  double? latitude;
  double? longitude;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isVerified,
    required this.isVendor,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      isVerified: json['isVerified'],
      isVendor: json['isVendor'],
      address: json['address'] == "" ? null : json['address'],
      latitude: json['latitude'] == 0 ? null : json['latitude'],
      longitude: json['longitude'] == 0 ? null : json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'isVerified': isVerified,
      'isVendor': isVendor,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
