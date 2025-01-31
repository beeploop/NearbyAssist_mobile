class ReviewModel {
  String? id;
  final String serviceId;
  final String transactionId;
  final int rating;
  final String text;

  ReviewModel({
    this.id,
    required this.serviceId,
    required this.transactionId,
    required this.rating,
    required this.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'],
      transactionId: json['transactionId'],
      rating: json['rating'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'transactionId': transactionId,
      'rating': rating,
      'text': text,
    };
  }
}
