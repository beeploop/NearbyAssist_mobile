class ReviewModel {
  String? id;
  final String serviceId;
  final String bookingId;
  final int rating;
  final String text;

  ReviewModel({
    this.id,
    required this.serviceId,
    required this.bookingId,
    required this.rating,
    required this.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      serviceId: json['serviceId'],
      bookingId: json['bookingId'],
      rating: json['rating'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'bookingId': bookingId,
      'rating': rating,
      'text': text,
    };
  }
}
