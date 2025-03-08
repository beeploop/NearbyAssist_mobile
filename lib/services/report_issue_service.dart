import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class ReportIssueService {
  Future<void> reportIssue({
    required String title,
    required String detail,
    required List<Uint8List> images,
  }) async {
    try {
      if (title.isEmpty || detail.isEmpty || images.isEmpty) {
        throw "Don't leave empty fields";
      }

      final data = FormData.fromMap({
        'title': title,
        'detail': detail,
        'files': [
          ...images.map((image) => MultipartFile.fromBytes(
                image,
                filename: 'image',
                contentType: MediaType('image', 'jpeg'),
              )),
        ],
      });

      final api = ApiService.unauthenticated();
      await api.dio.post(endpoint.reportBug, data: data);
    } on DioException catch (error) {
      throw error.response?.data['message'];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> reportUser({
    required String userId,
    required String reason,
    required String detail,
    required List<Uint8List> images,
  }) async {
    try {
      final data = FormData.fromMap({
        'userId': userId,
        'reason': reason,
        'detail': detail,
        'files': [
          ...images.map((image) => MultipartFile.fromBytes(
                image,
                filename: 'image',
                contentType: MediaType('image', 'jpeg'),
              )),
        ],
      });

      final api = ApiService.authenticated();
      await api.dio.post(endpoint.reportUser, data: data);
    } on DioException catch (error) {
      throw error.response?.data['message'];
    } catch (error) {
      rethrow;
    }
  }
}
