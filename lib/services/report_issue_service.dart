import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:nearby_assist/services/image_resize_service.dart';

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

      final resizedImages = <MultipartFile>[];
      for (final image in images) {
        final resized = await compute(ImageResizeService.resize, image);
        resizedImages.add(MultipartFile.fromBytes(
          resized,
          filename: 'image',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final data = FormData.fromMap({
        'title': title,
        'detail': detail,
        'files': resizedImages,
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
      final resizedImages = <MultipartFile>[];
      for (final image in images) {
        final resized = await compute(ImageResizeService.resize, image);
        resizedImages.add(MultipartFile.fromBytes(
          resized,
          filename: 'image',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final data = FormData.fromMap({
        'userId': userId,
        'reason': reason,
        'detail': detail,
        'files': resizedImages,
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
