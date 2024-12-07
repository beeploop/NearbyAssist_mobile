class TagModel {
  String? id;
  String title;

  TagModel({
    this.id,
    required this.title,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] ?? '',
      title: json['title'],
    );
  }
}
