import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/image_resize_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

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
            await compute(ImageResizeService.resize, supportingDoc),
            filename: 'supportingDocument',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, policeClearance),
            filename: 'policeClearance',
            contentType: MediaType('image', 'jpeg'),
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
