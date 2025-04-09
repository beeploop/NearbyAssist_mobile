class PostReviewModel {
  final String serviceId;
  final String bookingId;
  final int rating;
  final String text;

  PostReviewModel({
    required this.serviceId,
    required this.bookingId,
    required this.rating,
    required this.text,
  });

  factory PostReviewModel.fromJson(Map<String, dynamic> json) {
    return PostReviewModel(
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
