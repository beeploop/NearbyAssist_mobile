class MinimalUserModel {
  final String id;
  final String name;
  final String imageUrl;

  MinimalUserModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory MinimalUserModel.fromJson(Map<String, dynamic> json) {
    return MinimalUserModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
