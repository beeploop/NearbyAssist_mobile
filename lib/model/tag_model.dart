class TagModel {
  final String title;

  TagModel({
    required this.title,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }
}
