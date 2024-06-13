class ServiceImageModel {
  int imageId;
  String imageUrl;

  ServiceImageModel({
    required this.imageId,
    required this.imageUrl,
  });

  factory ServiceImageModel.fromJson(Map<String, dynamic> json) {
    return ServiceImageModel(
      imageId: json['imageId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'imageUrl': imageUrl,
    };
  }
}
