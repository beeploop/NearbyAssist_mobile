import 'package:nearby_assist/models/location_model.dart';
import 'package:nearby_assist/models/minimal_user_model.dart';
import 'package:nearby_assist/models/service_extra_model.dart';
import 'package:nearby_assist/models/tag_model.dart';

enum BookingStatus { pending, confirmed, done, rejected, cancelled }

class BookingModel {
  String id;
  MinimalUserModel vendor;
  MinimalUserModel client;
  MinimalServiceModel service;
  List<ServiceExtraModel> extras;
  double cost;
  BookingStatus status;
  String qrSignature;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? scheduledAt;
  String? cancelReason;

  BookingModel({
    required this.id,
    required this.vendor,
    required this.client,
    required this.service,
    required this.extras,
    required this.cost,
    required this.status,
    required this.qrSignature,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduledAt,
    required this.cancelReason,
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
      cost: double.tryParse(json['cost'].toString()) ?? 0.0,
      status: switch (json['status']) {
        'pending' => BookingStatus.pending,
        'confirmed' => BookingStatus.confirmed,
        'done' => BookingStatus.done,
        'rejected' => BookingStatus.rejected,
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
      cost: cost,
      status: status ?? this.status,
      qrSignature: qrSignature,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  double total() {
    return extras.fold<double>(
      service.rate,
      (prev, extra) => prev + extra.price,
    );
  }
}

class MinimalServiceModel {
  final String id;
  final String vendorId;
  final String title;
  final String description;
  final double rate;
  final List<TagModel> tags;
  final LocationModel location;

  MinimalServiceModel({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.rate,
    required this.tags,
    required this.location,
  });

  factory MinimalServiceModel.fromJson(Map<String, dynamic> json) {
    return MinimalServiceModel(
      id: json['id'],
      vendorId: json['vendorId'],
      title: json['title'],
      description: json['description'],
      rate: double.tryParse(json['rate'].toString().replaceAll(",", "")) ?? 0.0,
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
      'rate': rate.toString(),
      'tags': tags,
      'location': location.toJson(),
    };
  }
}
