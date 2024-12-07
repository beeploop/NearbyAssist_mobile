class ExpertiseModel {
  String id;
  String title;
  List<String> tags = [];

  ExpertiseModel({
    required this.id,
    required this.title,
    required this.tags,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
    return ExpertiseModel(
      id: json['id'],
      title: json['title'],
      tags: List<String>.from(json['tags']),
    );
  }
}
