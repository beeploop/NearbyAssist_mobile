class ServiceReviewModel {
  final String id;
  final String bookingId;
  final int rating;
  final String text;
  final String createdAt;
  final String reviewee;
  final String revieweeImage;

  ServiceReviewModel({
    required this.id,
    required this.bookingId,
    required this.rating,
    required this.text,
    required this.createdAt,
    required this.reviewee,
    required this.revieweeImage,
  });

  factory ServiceReviewModel.fromJson(Map<String, dynamic> json) {
    return ServiceReviewModel(
      id: json['id'],
      bookingId: json['bookingId'],
      rating: json['rating'],
      text: json['text'],
      createdAt: json['createdAt'],
      reviewee: json['revieweeName'],
      revieweeImage: json['revieweeImageUrl'],
    );
  }
}
