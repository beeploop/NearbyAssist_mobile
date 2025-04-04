class BookingQrCodeData {
  final String clientId;
  final String vendorId;
  final String bookingId;
  final String signature;

  BookingQrCodeData({
    required this.clientId,
    required this.vendorId,
    required this.bookingId,
    required this.signature,
  });

  factory BookingQrCodeData.fromJson(Map<String, dynamic> json) {
    return BookingQrCodeData(
      clientId: json['clientId'],
      vendorId: json['vendorId'],
      bookingId: json['bookingId'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'vendorId': vendorId,
      'bookingId': bookingId,
      'signature': signature,
    };
  }

  Map<String, dynamic> toJsonNoSignature() {
    return {
      'clientId': clientId,
      'vendorId': vendorId,
      'bookingId': bookingId,
    };
  }
}
