import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:nearby_assist/services/image_resize_service.dart';

class VerifyAccountService {
  Future<void> verify({
    required String name,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
    required ValidID idType,
    required String idNumber,
    required Uint8List? frontId,
    required Uint8List? backId,
    required Uint8List? selfie,
  }) async {
    logger.logDebug('called verify in verify_account_service.dart');

    try {
      if (idType == ValidID.none) {
        throw Exception('Select an ID Type');
      }

      if (frontId == null || backId == null || selfie == null) {
        throw Exception('Select images');
      }

      if (latitude == 0 || longitude == 0) {
        throw Exception('Problem retrieving geolocation');
      }

      if (name.isEmpty ||
          phone.isEmpty ||
          address.isEmpty ||
          idNumber.isEmpty) {
        throw Exception("Don't leave empty fields");
      }

      if (phone.length != 11) {
        throw Exception('Invalid phone');
      }

      final data = FormData.fromMap({
        'name': name,
        'phone': phone,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'idType': idType.value,
        'idNumber': idNumber,
        'files': [
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, frontId),
            filename: 'frontId',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, backId),
            filename: 'backId',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            await compute(ImageResizeService.resize, selfie),
            filename: 'face',
            contentType: MediaType('image', 'jpeg'),
          ),
        ]
      });

      final api = ApiService.authenticated();
      await api.dio.post(endpoint.verifyAccount, data: data);
    } on DioException catch (error) {
      logger.logError(error.toString());
      if (error.response?.statusCode == 400) {
        throw 'You already submitted an application';
      }

      rethrow;
    } catch (error) {
      logger.logError(error.toString());
      rethrow;
    }
  }
}
