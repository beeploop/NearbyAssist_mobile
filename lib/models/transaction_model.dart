import 'package:nearby_assist/models/service_extra_model.dart';

enum TransactionStatus { pending, confirmed, done, rejected, cancelled }

class TransactionModel {
  String id;
  String vendor;
  String client;
  String vendorId;
  String clientId;
  double cost;
  TransactionStatus status;
  List<ServiceExtraModel> extras;
  MinimalServiceModel service;

  TransactionModel({
    required this.id,
    required this.vendor,
    required this.client,
    required this.vendorId,
    required this.clientId,
    required this.cost,
    required this.status,
    required this.extras,
    required this.service,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      vendor: json['vendor'],
      client: json['client'],
      vendorId: json['vendorId'],
      clientId: json['clientId'],
      cost: double.tryParse(json['cost'].toString()) ?? 0.0,
      status: switch (json['status']) {
        'pending' => TransactionStatus.pending,
        'confirmed' => TransactionStatus.confirmed,
        'done' => TransactionStatus.done,
        'rejected' => TransactionStatus.rejected,
        _ => TransactionStatus.cancelled,
      },
      extras: ((json['extras'] ?? []) as List)
          .map<ServiceExtraModel>((extra) => ServiceExtraModel.fromJson(extra))
          .toList(),
      service: MinimalServiceModel.fromJson(json['service']),
    );
  }

  TransactionModel copyWithNewStatus(TransactionStatus status) {
    this.status = status;
    return this;
  }
}

class MinimalServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final double latitude;
  final double longitude;

  MinimalServiceModel({
    this.id = '',
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.latitude,
    required this.longitude,
  });

  factory MinimalServiceModel.fromJson(Map<String, dynamic> json) {
    return MinimalServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      rate: double.tryParse(json['rate'].toString().replaceAll(",", "")) ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'rate': rate.toString(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  MinimalServiceModel copyWithNewId(String newId) {
    return MinimalServiceModel(
      id: newId,
      vendorId: vendorId,
      title: title,
      description: description,
      rate: rate,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
