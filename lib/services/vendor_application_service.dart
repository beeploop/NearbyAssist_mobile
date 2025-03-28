import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';

class VendorApplicationService {
  Future<void> apply({
    required ExpertiseModel expertise,
    required Uint8List supportingDoc,
    required Uint8List policeClearance,
  }) async {
    logger.logDebug('called apply in vendor_application_service.dart');

    try {
      final data = FormData.fromMap({
        'expertiseId': expertise.id,
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
      logger.logError(error.toString());
      if (error.response?.statusCode == 400) {
        throw error.response?.data['message'];
      }

      rethrow;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
