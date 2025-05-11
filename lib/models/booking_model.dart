import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/minimal_user_model.dart';
import 'package:nearby_assist/models/pricing_type.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/tag_model.dart';

enum BookingStatus { pending, confirmed, done, rejected, cancelled }

class BookingModel {
  String id;
  MinimalUserModel vendor;
  MinimalUserModel client;
  MinimalServiceModel service;
  List<ServiceExtraModel> extras;
  int quantity;
  double cost;
  BookingStatus status;
  String qrSignature;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? scheduledAt;
  String? cancelReason;
  String cancelledById;

  BookingModel({
    required this.id,
    required this.vendor,
    required this.client,
    required this.service,
    required this.extras,
    required this.quantity,
    required this.cost,
    required this.status,
    required this.qrSignature,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduledAt,
    required this.cancelReason,
    required this.cancelledById,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      vendor: MinimalUserModel.fromJson(json['vendor']),
      client: MinimalUserModel.fromJson(json['client']),
      service: MinimalServiceModel.fromJson(json['service']),
      extras: ((json['extras'] ?? []) as List)
          .map<ServiceExtraModel>((extra) => ServiceExtraModel.fromJson(extra))
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
      scheduledAt: json['scheduledAt'] != ''
          ? DateTime.parse(json['scheduledAt'])
          : null,
      cancelReason: json['cancelReason'],
      cancelledById: json['cancelledById'],
    );
  }

  BookingModel copyWith({
    BookingStatus? status,
    DateTime? updatedAt,
    DateTime? scheduledAt,
    String? cancelReason,
  }) {
    return BookingModel(
      id: id,
      vendor: vendor,
      client: client,
      service: service,
      extras: extras,
      quantity: quantity,
      cost: cost,
      status: status ?? this.status,
      qrSignature: qrSignature,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelledById: cancelledById,
    );
  }

  double total() {
    final base = switch (service.pricingType) {
      PricingType.fixed => service.price,
      PricingType.perHour => service.price * quantity,
      PricingType.perDay => service.price * quantity,
    };

    return extras.fold<double>(base, (prev, extra) => prev + extra.price);
  }
}

class MinimalServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double price;
  final PricingType pricingType;
  final List<TagModel> tags;
  final LocationModel location;

  MinimalServiceModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.price,
    required this.pricingType,
    required this.tags,
    required this.location,
  });

  factory MinimalServiceModel.fromJson(Map<String, dynamic> json) {
    return MinimalServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
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
      tags: List.from(
        ((json['tags'] ?? []) as List).map((tag) => TagModel.fromJson(tag)),
      ),
      location: LocationModel.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'price': price.toString(),
      'pricingType': pricingType.name,
      'tags': tags,
      'location': location.toJson(),
    };
  }
}
