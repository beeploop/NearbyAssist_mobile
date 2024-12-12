import 'package:nearby_assist/models/service_extra_model.dart';

class BookingModel {
  final String vendorId;
  final String clientId;
  final String serviceId;
  final String totalCost;
  final List<ServiceExtraModel> extras;

  BookingModel({
    required this.vendorId,
    required this.clientId,
    required this.serviceId,
    required this.totalCost,
    required this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'clientId': clientId,
      'serviceId': serviceId,
      'cost': totalCost,
      'extras': extras.map((e) => e.toJson()).toList(),
    };
  }
}
