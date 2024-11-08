import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final store = SecureStorage();
    final accessToken = await store.getToken(TokenType.accessToken);
    if (accessToken == null) {
      handler.reject(DioException(requestOptions: options));
    }

    options.headers['Authorization'] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      await _refreshToken();
      return handler.resolve(await _retry(err.requestOptions));
    }

    super.onError(err, handler);
  }

  Future<void> _refreshToken() async {
    try {
      final store = SecureStorage();

      final refreshToken = await store.getToken(TokenType.refreshToken);
      if (refreshToken == null) {
        throw Exception('NoToken');
      }

      final api = ApiService.authenticated();
      final response = await api.dio.post(
        endpoint.refresh,
        data: {'refreshToken': refreshToken},
      );

      await store.saveToken(
          TokenType.accessToken, response.data['accessToken']);
    } catch (error) {
      logger.log('Error refreshing token ${error.toString()}');
      rethrow;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final store = SecureStorage();
    final accessToken = await store.getToken(TokenType.accessToken);
    if (accessToken == null) {
      throw Exception('NoToken');
    }

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );

    final dio = Dio();
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
