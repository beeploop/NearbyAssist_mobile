import 'package:nearby_assist/models/booking_extra_model.dart';
import 'package:nearby_assist/models/minimal_user_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';

enum BookingStatus { pending, confirmed, done, rejected, cancelled }

class BookingModel {
  String id;
  MinimalUserModel vendor;
  MinimalUserModel client;
  String serviceId;
  String serviceTitle;
  String serviceDescription;
  double price;
  PricingType pricingType;
  List<BookingExtraModel> extras;
  int quantity;
  double cost;
  BookingStatus status;
  String qrSignature;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime requestedStart;
  DateTime requestedEnd;
  DateTime? scheduleStart;
  DateTime? scheduleEnd;
  String? cancelReason;
  String cancelledById;

  BookingModel({
    required this.id,
    required this.vendor,
    required this.client,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.price,
    required this.pricingType,
    required this.extras,
    required this.quantity,
    required this.cost,
    required this.status,
    required this.qrSignature,
    required this.createdAt,
    required this.updatedAt,
    required this.requestedStart,
    required this.requestedEnd,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.cancelReason,
    required this.cancelledById,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      vendor: MinimalUserModel.fromJson(json['vendor']),
      client: MinimalUserModel.fromJson(json['client']),
      serviceId: json['serviceId'],
      serviceTitle: json['serviceTitle'],
      serviceDescription: json['serviceDescription'],
      price:
          double.tryParse(json['price'].toString().replaceAll(",", "")) ?? 0.0,
      pricingType: () {
        switch (json['pricingType']) {
          case 'fixed':
            return PricingType.fixed;
          case 'per_hour':
            return PricingType.perHour;
          case 'per_day':
            return PricingType.perDay;
          default:
            return PricingType.fixed;
        }
      }(),
      extras: ((json['extras'] ?? []) as List)
          .map<BookingExtraModel>((extra) => BookingExtraModel.fromJson(extra))
          .toList(),
      quantity: json['quantity'],
      cost: double.tryParse(json['cost'].toString()) ?? 0.0,
      status: switch (json['status']) {
        'pending' => BookingStatus.pending,
        'confirmed' => BookingStatus.confirmed,
        'done' => BookingStatus.done,
        'rejected' => BookingStatus.rejected,
        'cancelled' => BookingStatus.cancelled,
        _ => BookingStatus.cancelled,
      },
      qrSignature: json['qrSignature'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != '' ? DateTime.parse(json['updatedAt']) : null,
      requestedStart: DateTime.parse(json['requestedStart']),
      requestedEnd: DateTime.parse(json['requestedEnd']),
      scheduleStart: json['scheduleStart'] != ''
          ? DateTime.parse(json['scheduleStart'])
          : null,
      scheduleEnd: json['scheduleEnd'] != ''
          ? DateTime.parse(json['scheduleEnd'])
          : null,
      cancelReason: json['cancelReason'],
      cancelledById: json['cancelledById'],
    );
  }

  BookingModel copyWith({
    BookingStatus? status,
    DateTime? updatedAt,
    DateTime? scheduleStart,
    DateTime? scheduleEnd,
    String? cancelReason,
    String? cancelledById,
  }) {
    return BookingModel(
      id: id,
      vendor: vendor,
      client: client,
      serviceId: serviceId,
      serviceTitle: serviceTitle,
      serviceDescription: serviceDescription,
      price: price,
      pricingType: pricingType,
      extras: extras,
      quantity: quantity,
      cost: cost,
      status: status ?? this.status,
      qrSignature: qrSignature,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requestedStart: requestedStart,
      requestedEnd: requestedEnd,
      scheduleStart: scheduleStart ?? this.scheduleStart,
      scheduleEnd: scheduleEnd ?? this.scheduleEnd,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelledById: cancelledById ?? this.cancelledById,
    );
  }

  double total() {
    final base = switch (pricingType) {
      PricingType.fixed => price,
      PricingType.perHour => price * quantity,
      PricingType.perDay => price * quantity,
    };

    return extras.fold<double>(base, (prev, extra) => prev + extra.price);
  }

  @override
  String toString() {
    return '{id: $id, client: ${client.name}, start: $scheduleStart, end: $scheduleEnd}';
  }
}
