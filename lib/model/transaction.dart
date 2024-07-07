class Transaction {
  int id;
  String client;
  String vendor;
  String status;
  String createdAt;

  Transaction({
    required this.id,
    required this.client,
    required this.vendor,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      client: json['client'],
      vendor: json['vendor'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'vendor': vendor,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
