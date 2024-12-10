class ServiceExtraModel {
  String id;
  String title;
  String description;
  double price;

  ServiceExtraModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  factory ServiceExtraModel.fromJson(Map<String, dynamic> json) {
    return ServiceExtraModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
