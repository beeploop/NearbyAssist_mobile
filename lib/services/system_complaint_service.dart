import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nearby_assist/services/request/authenticated_request.dart';

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
      final request = AuthenticatedRequest<Map<String, dynamic>>();
      final response = await request.multipartRequest(
        "/backend/v1/public/complaints/system",
        _systemComplaintImages,
        [
          SystemComplaintFormData(key: "title", value: complaint.title),
          SystemComplaintFormData(key: "detail", value: complaint.detail),
        ],
      );

      return SystemComplaintResult(message: response['message'], success: true);
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

class SystemComplaintFormData {
  final String key;
  final String value;

  SystemComplaintFormData({required this.key, required this.value});
}

class SystemComplaintResult {
  final String message;
  final bool success;

  SystemComplaintResult({required this.message, required this.success});
}
