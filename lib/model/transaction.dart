class Transaction {
  int id;
  String client;
  String vendor;
  String service;
  String status;

  Transaction({
    required this.id,
    required this.client,
    required this.vendor,
    required this.service,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['Id'],
      client: json['Client'],
      vendor: json['Vendor'],
      service: json['Service'],
      status: json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'vendor': vendor,
      'service': service,
      'status': status,
    };
  }
}
