import 'package:nearby_assist/models/service_extra_model.dart';

class BookingRequestModel {
  final String vendorId;
  final String clientId;
  final String serviceId;
  final int quantity;
  final String totalCost;
  final List<ServiceExtraModel> extras;
  final String requestedStart;
  final String requestedEnd;

  BookingRequestModel({
    required this.vendorId,
    required this.clientId,
    required this.serviceId,
    required this.quantity,
    required this.totalCost,
    required this.extras,
    required this.requestedStart,
    required this.requestedEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'clientId': clientId,
      'serviceId': serviceId,
      'quantity': quantity,
      'cost': totalCost,
      'extras': extras.map((extra) => extra.toJson()).toList(),
      'requestedStart': requestedStart,
      'requestedEnd': requestedEnd,
    };
  }
}
