class BookingExtraModel {
  String bookingId;
  String title;
  String description;
  double price;

  BookingExtraModel({
    required this.bookingId,
    required this.title,
    required this.description,
    required this.price,
  });

  factory BookingExtraModel.fromJson(Map<String, dynamic> json) {
    return BookingExtraModel(
      bookingId: json['bookingId'],
      title: json['title'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'title': title,
      'description': description,
      'price': price.toString(),
    };
  }
}
