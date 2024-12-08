import 'package:nearby_assist/models/tag_model.dart';

class ExpertiseModel {
  String id;
  String title;
  List<TagModel> tags = [];

  ExpertiseModel({
    required this.id,
    required this.title,
    required this.tags,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
    return ExpertiseModel(
      id: json['id'],
      title: json['title'],
      tags: List<TagModel>.from(
        json['tags'].map(
          (tag) => TagModel.fromJson(tag),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }
}
