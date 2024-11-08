import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nearby_assist/config/valid_id.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';

class VerifyAccountService {
  Future<void> verify({
    required String name,
    required String address,
    required ValidID idType,
    required String idNumber,
    required Uint8List? frontId,
    required Uint8List? backId,
    required Uint8List? face,
  }) async {
    try {
      if (!_isValid(
        name: name,
        address: address,
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
        'address': address,
        'idType': idType.value,
        'idNumber': idNumber,
        'files': [
          MultipartFile.fromBytes(
            frontId!,
            filename: 'frontId',
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
      await api.dio.post(endpoint.verifyAccount, data: data);
    } catch (error) {
      logger.log('Error submitting account verification: ${error.toString()}');
      rethrow;
    }
  }

  bool _isValid({
    required String name,
    required String address,
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

    if (name.isEmpty ||
        address.isEmpty ||
        idNumber.isEmpty ||
        frontId.isEmpty ||
        backId.isEmpty ||
        face.isEmpty) {
      return false;
    }

    return true;
  }
}
