class ServiceImageModel {
  String id;
  String url;

  ServiceImageModel({
    required this.id,
    required this.url,
  });

  factory ServiceImageModel.fromJson(Map<String, dynamic> json) {
    return ServiceImageModel(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
