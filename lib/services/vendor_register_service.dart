import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/request/dio_request.dart';

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
      const url = '/v1/public/application';

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
      final response = request.multipart(
        url,
        formData,
        (int send, int total) {
          debugPrint('=== send: $send, total: $total');
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('===== Error: $e');
      }
    } finally {
      _toggleLoading();
    }
  }
}
