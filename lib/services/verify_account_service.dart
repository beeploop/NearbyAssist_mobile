import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/verify_account_model.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/image_resize_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class VerifyAccountService {
  Future<void> verify(VerifyAccountModel payload) async {
    logger.logDebug('called verify in verify_account_service.dart');

    try {
      final data = FormData.fromMap({
        'user': jsonEncode(payload),
        'files': [
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, payload.frontId),
            filename: 'frontId',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, payload.backId),
            filename: 'backId',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, payload.selfie),
            filename: 'face',
            contentType: MediaType('image', 'jpeg'),
          ),
        ]
      });

      final api = ApiService.authenticated();
      await api.dio.post(endpoint.verifyAccount, data: data);
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
