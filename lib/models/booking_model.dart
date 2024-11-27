import 'package:nearby_assist/config/employment_type.dart';

class BookingModel {
  final String vendorId;
  final String clientId;
  final String serviceId;
  final String startDate;
  final String endDate;
  final String cost;
  final EmploymentType employmentType;

  BookingModel({
    required this.vendorId,
    required this.clientId,
    required this.serviceId,
    required this.startDate,
    required this.endDate,
    required this.cost,
    required this.employmentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'clientId': clientId,
      'serviceId': serviceId,
      'startDate': startDate,
      'endDate': endDate,
      'cost': cost,
      'employmentType': employmentType.value,
    };
  }
}
