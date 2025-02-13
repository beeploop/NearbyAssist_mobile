class AddExtraModel {
  final String serviceId;
  final String title;
  final String description;
  final double price;

  AddExtraModel({
    required this.serviceId,
    required this.title,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'title': title,
      'description': description,
      'price': price,
    };
  }
}
