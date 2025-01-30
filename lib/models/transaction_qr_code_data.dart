class TransactionQrCodeData {
  final String clientId;
  final String vendorId;
  final String transactionId;
  final String signature;

  TransactionQrCodeData({
    required this.clientId,
    required this.vendorId,
    required this.transactionId,
    required this.signature,
  });

  factory TransactionQrCodeData.fromJson(Map<String, dynamic> json) {
    return TransactionQrCodeData(
      clientId: json['clientId'],
      vendorId: json['vendorId'],
      transactionId: json['transactionId'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'vendorId': vendorId,
      'transactionId': transactionId,
      'signature': signature,
    };
  }

  Map<String, dynamic> toJsonNoSignature() {
    return {
      'clientId': clientId,
      'vendorId': vendorId,
      'transactionId': transactionId,
    };
  }
}
