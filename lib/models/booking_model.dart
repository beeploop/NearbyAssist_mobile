import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/service_model.dart';

class BookingModel {
  String id;
  String vendor;
  String client;
  String vendorId;
  String clientId;
  double cost;
  String status;
  List<ServiceExtraModel> extras;
  ServiceModel service;

  BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      vendor: json['vendor'],
      client: json['client'],
      vendorId: json['vendorId'],
      clientId: json['clientId'],
      cost: double.tryParse(json['cost'].toString()) ?? 0.0,
      status: json['status'],
      extras: json['extras']
          .map<ServiceExtraModel>((extra) => ServiceExtraModel.fromJson(extra))
          .toList(),
      service: ServiceModel.fromJson(json['service']),
    );
  }
}
