import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/services/logger_service.dart';

class VendorRegisterService extends ChangeNotifier {
  bool _loading = false;

  bool isLoading() => _loading;

  void _toggleLoading() {
    _loading = !_loading;
    notifyListeners();
  }

  Future<void> registerVendor({
    required String job,
    required File policeClearance,
    required File supportingDocument,
  }) async {
    _toggleLoading();

    try {
      const url = '/api/v1/applications';

      final formData = FormData.fromMap({
        'job': job,
        'files': [
          MultipartFile.fromBytes(
            supportingDocument.readAsBytesSync(),
            filename: 'supportingDocument',
          ),
          MultipartFile.fromBytes(
            policeClearance.readAsBytesSync(),
            filename: 'policeClearance',
          ),
        ]
      });

      final request = DioRequest();
      await request.multipart(
        url,
        formData,
        (int send, int total) {
          ConsoleLogger().log('=== send: $send, total: $total');
        },
        expectedStatus: HttpStatus.created,
      );
    } catch (e) {
      rethrow;
    } finally {
      _toggleLoading();
    }
  }
}
