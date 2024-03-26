class MyService {
  final int id;
  final String title;
  final String description;
  final String category;
  final String rate;

  MyService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.rate,
  });

  factory MyService.fromJson(Map<String, dynamic> json) {
    return MyService(
      id: json['Id'],
      title: json['Title'],
      description: json['Description'],
      category: json['Category'],
      rate: json['Rate'],
    );
  }
}
