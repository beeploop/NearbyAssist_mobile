import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';

class VendorApplicationService {
  Future<void> apply({
    required String tag,
    required Uint8List supportingDoc,
    required Uint8List policeClearance,
  }) async {
    try {
      final data = FormData.fromMap({
        'job': tag,
        'files': [
          MultipartFile.fromBytes(
            supportingDoc,
            filename: 'supportingDocument',
          ),
          MultipartFile.fromBytes(
            policeClearance,
            filename: 'policeClearance',
          ),
        ],
      });

      final api = ApiService.authenticated();
      await api.dio.post(endpoint.vendorApplication, data: data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw 'You already submitted an application';
      }

      rethrow;
    } catch (error) {
      logger.log('Error applying for vendor: $error');
      rethrow;
    }
  }
}
