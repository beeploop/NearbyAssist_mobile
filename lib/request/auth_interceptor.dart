import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/auth_model.dart';
import 'package:nearby_assist/request/dio_request.dart';
import 'package:nearby_assist/model/request/token.dart';
import 'package:nearby_assist/services/data_manager_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.headers["requireAuth"] == null ||
        options.headers["requireAuth"] == false) {
      options.headers.remove("requireAuth");
      return handler.next(options);
    }

    final tokens = getIt.get<AuthModel>().getUserTokens();
    if (tokens == null) {
      return handler.reject(DioException(requestOptions: options), true);
    }

    options.headers["Authorization"] = "Bearer ${tokens.accessToken}";
    options.headers.remove("requireAuth");
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('=== error: ${err.response}');
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
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception('User not logged in');
      }

      const url = "/backend/auth/refresh";

      final request = DioRequest();
      final response = await request.post(
        url,
        {
          'token': tokens.refreshToken,
        },
      );

      final updatedToken = Token(
        accessToken: response.data['accessToken'],
        refreshToken: tokens.refreshToken,
      );

      getIt.get<AuthModel>().setUserTokens(updatedToken);
      await getIt.get<DataManagerService>().saveTokens(updatedToken);

      if (response.statusCode != HttpStatus.ok) {
        throw Exception("Failed to refresh token");
      }

      return response.data['accessToken'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Response> _retry(RequestOptions options) async {
    try {
      final tokens = getIt.get<AuthModel>().getUserTokens();
      if (tokens == null) {
        throw Exception("User not logged in");
      }

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
      print("Error in retring request: ${e.toString()}");
      rethrow;
    }
  }
}
