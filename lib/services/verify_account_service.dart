import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

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
    required Uint8List? face,
  }) async {
    try {
      if (!_isValid(
        name: name,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
        idType: idType,
        idNumber: idNumber,
        frontId: frontId,
        backId: backId,
        face: face,
      )) {
        throw Exception('InvalidInput');
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
            frontId!,
            filename: 'frontId',
            contentType: MediaType('image', 'jpeg'),
          ),
          MultipartFile.fromBytes(
            backId!,
            filename: 'backId',
          ),
          MultipartFile.fromBytes(
            face!,
            filename: 'face',
          ),
        ]
      });

      final api = ApiService.authenticated();
      await api.dio.post(
        endpoint.verifyAccount,
        data: data,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw 'You already submitted an application';
      }

      rethrow;
    } catch (error) {
      logger.log('Error submitting account verification: ${error.toString()}');
      rethrow;
    }
  }

  bool _isValid({
    required String name,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
    required ValidID idType,
    required String idNumber,
    required Uint8List? frontId,
    required Uint8List? backId,
    required Uint8List? face,
  }) {
    if (idType == ValidID.none) {
      return false;
    }

    if (frontId == null) {
      return false;
    }

    if (backId == null) {
      return false;
    }

    if (face == null) {
      return false;
    }

    if (latitude == 0 || longitude == 0) {
      return false;
    }

    if (name.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        idNumber.isEmpty ||
        frontId.isEmpty ||
        backId.isEmpty ||
        face.isEmpty) {
      return false;
    }

    if (phone.length != 11) {
      return false;
    }

    return true;
  }
}
