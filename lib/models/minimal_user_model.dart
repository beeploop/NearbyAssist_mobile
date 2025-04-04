class MinimalUserModel {
  final String id;
  final String name;

  MinimalUserModel({
    required this.id,
    required this.name,
  });

  factory MinimalUserModel.fromJson(Map<String, dynamic> json) {
    return MinimalUserModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
