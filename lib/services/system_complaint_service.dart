import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:nearby_assist/services/logger_service.dart';

class SystemComplaintService extends ChangeNotifier {
  List<File> _systemComplaintImages = [];
  bool _isUploading = false;

  bool isUploading() => _isUploading;
  void toggleLoading() {
    _isUploading = !_isUploading;
    notifyListeners();
  }

  void setSystemComplaintImages(List<File> images) {
    _systemComplaintImages = images;
    notifyListeners();
  }

  void clearSystemComplaintImages() {
    _systemComplaintImages.clear();
    notifyListeners();
  }

  List<File> getSystemComplaintImages() {
    return _systemComplaintImages;
  }

  Future<SystemComplaintResult> fileSystemComplaint(
      SystemComplaintModel complaint) async {
    try {
      toggleLoading();

      final formData = FormData.fromMap({
        'title': complaint.title,
        'detail': complaint.detail,
        'files': [
          ..._systemComplaintImages.map((image) {
            final file = image.path.split('/').last.split('.').last;

            return MultipartFile.fromBytes(
              image.readAsBytesSync(),
              filename: 'image',
              contentType: MediaType('image', file),
            );
          }).toList(),
        ]
      });

      const url = "/api/v1/complaints/system";
      final request = DioRequest();
      final response = await request.multipart(
        url,
        formData,
        (int send, int total) {
          ConsoleLogger().log('=== send: $send, total: $total');
        },
        expectedStatus: HttpStatus.created,
      );

      if (response.statusCode != HttpStatus.created) {
        throw Exception(response.data);
      }

      return SystemComplaintResult(
        message: response.data['message'],
        success: true,
      );
    } catch (e) {
      return SystemComplaintResult(message: '$e', success: false);
    } finally {
      toggleLoading();
      _systemComplaintImages.clear();
      notifyListeners();
    }
  }
}

class SystemComplaintModel {
  String title;
  String detail;

  SystemComplaintModel({
    required this.title,
    required this.detail,
  });
}

class SystemComplaintResult {
  final String message;
  final bool success;

  SystemComplaintResult({required this.message, required this.success});
}
