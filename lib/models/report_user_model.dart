import 'dart:typed_data';

import 'package:nearby_assist/config/report.dart';

class ReportUserModel {
  final String userId;
  final ReportCategory category;
  String? bookingId;
  final String reason;
  final String detail;
  final List<Uint8List> images;

  ReportUserModel({
    required this.userId,
    required this.category,
    this.bookingId,
    required this.reason,
    required this.detail,
    required this.images,
  });
}
