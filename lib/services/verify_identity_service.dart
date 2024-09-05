import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/request/dio_request.dart';

class VerifyIdentityService extends ChangeNotifier {
  bool _isLoading = false;

  bool isLoading() {
    return _isLoading;
  }

  void toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<VerifyIdentityResult> verifyIdentity({
    required String name,
    required String address,
    required String idType,
    required String idNumber,
    required File frontId,
    required File backId,
    required File face,
  }) async {
    try {
      toggleLoading();

      final formData = FormData.fromMap({
        'name': name,
        'address': address,
        'idType': idType,
        'idNumber': idNumber,
        'files': [
          MultipartFile.fromBytes(
            frontId.readAsBytesSync(),
            filename: 'frontId',
          ),
          MultipartFile.fromBytes(
            backId.readAsBytesSync(),
            filename: 'backId',
          ),
          MultipartFile.fromBytes(
            face.readAsBytesSync(),
            filename: 'face',
          ),
        ]
      });

      const url = "/v1/public/verification/identity";

      final request = DioRequest();
      final response = await request.multipart(
        url,
        formData,
        (int send, int total) {
          debugPrint('=== send: $send, total: $total');
        },
        expectedStatus: HttpStatus.created,
      );

      return VerifyIdentityResult(
        success: true,
        message: response.data['message'],
      );
    } catch (e) {
      debugPrint('Error verifying identity: $e');
      return VerifyIdentityResult(success: false, message: '$e');
    } finally {
      toggleLoading();
    }
  }
}

class VerifyIdentityResult {
  bool success;
  String message;

  VerifyIdentityResult({
    required this.success,
    required this.message,
  });
}
