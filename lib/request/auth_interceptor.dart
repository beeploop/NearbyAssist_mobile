import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      if (options.headers["requireAuth"] == null ||
          options.headers["requireAuth"] == false) {
        options.headers.remove("requireAuth");
        return handler.next(options);
      }

      final tokens = getIt.get<AuthModel>().getTokens();

      options.headers["Authorization"] = "Bearer ${tokens.accessToken}";
      options.headers.remove("requireAuth");
      return handler.next(options);
    } catch (e) {
      return handler.reject(
        DioException(requestOptions: options, error: e),
        true,
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      try {
        final newAccessToken = await refreshToken();

        err.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";
        return handler.resolve(await _retry(err.requestOptions));
      } catch (e) {
        return handler.reject(DioException(requestOptions: err.requestOptions));
      }
    }

    handler.next(err);
  }

  Future<String> refreshToken() async {
    try {
      final tokens = getIt.get<AuthModel>().getTokens();

      const url = "/api/v1/user/refresh";
      final request = DioRequest();
      final response = await request.post(
        url,
        {'refreshToken': tokens.refreshToken},
      );

      final updatedToken = Token(
        accessToken: response.data['accessToken'],
        refreshToken: tokens.refreshToken,
      );

      getIt.get<AuthModel>().saveTokens(updatedToken);
      await getIt.get<StorageService>().saveTokens(updatedToken);

      if (response.statusCode != HttpStatus.ok) {
        throw Exception("Failed to refresh token");
      }

      return response.data['accessToken'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> _retry(RequestOptions options) async {
    try {
      final tokens = getIt.get<AuthModel>().getTokens();

      final newOptions = Options(
        method: options.method,
        headers: {
          "Authorization": "Bearer ${tokens.accessToken}",
        },
      );

      final request = DioRequest();
      final response = await request.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: newOptions,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
