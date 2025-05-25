class ExpertiseModel {
  String id;
  String title;

  ExpertiseModel({
    required this.id,
    required this.title,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
    return ExpertiseModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
