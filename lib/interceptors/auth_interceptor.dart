import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/providers/token_change_notifier.dart';
import 'package:nearby_assist/services/api_service.dart';
import 'package:nearby_assist/services/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final BaseOptions _options;

  AuthInterceptor(BaseOptions options) : _options = options;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final store = SecureStorage();
    final accessToken = await store.getToken(TokenType.accessToken);
    if (accessToken == null) {
      handler.reject(DioException(requestOptions: options));
      return;
    }

    options.headers['Authorization'] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final bool isPossibleAuthError = (err.error is SocketException &&
            err.error.toString().toLowerCase().contains('broken pipe')) ||
        err.response?.statusCode == HttpStatus.unauthorized;

    if (isPossibleAuthError) {
      try {
        await _refreshToken();

        try {
          final response = await _retry(err.requestOptions);
          handler.resolve(response);
        } on DioException catch (error) {
          handler.reject(DioException.badResponse(
            statusCode: error.response?.statusCode ?? HttpStatus.unauthorized,
            requestOptions: error.requestOptions,
            response:
                error.response ?? Response(requestOptions: RequestOptions()),
          ));
        } catch (error) {
          handler.reject(DioException.badResponse(
            statusCode: HttpStatus.unauthorized,
            requestOptions: RequestOptions(),
            response: Response(requestOptions: RequestOptions()),
          ));
          return;
        }
      } catch (error) {
        handler.reject(DioException.badResponse(
          statusCode: HttpStatus.unauthorized,
          requestOptions: err.requestOptions,
          response: Response(requestOptions: RequestOptions()),
        ));
        return;
      }
    }

    handler.reject(err);
  }

  Future<void> _refreshToken() async {
    logger.logDebug('refresh token called');

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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      await store.saveToken(
        TokenType.accessToken,
        response.data['accessToken'],
      );

      TokenChangeNotifier().notifyTokenRefreshed();
    } catch (error) {
      rethrow;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    logger.logDebug('called retry in auth_interceptor.dart');

    final store = SecureStorage();
    final accessToken = await store.getToken(TokenType.accessToken);
    if (accessToken == null) {
      throw Exception('NoToken');
    }

    final RequestOptions originalOptions = requestOptions;

    final dynamic retryFormData;
    if (originalOptions.data is FormData) {
      final oldData = originalOptions.data as FormData;

      final newData = FormData();
      newData.fields.addAll(oldData.fields);

      for (final entry in oldData.files) {
        try {
          newData.files.add(MapEntry(
            entry.key,
            entry.value.clone(),
          ));
        } catch (error) {
          logger.logError(error.toString());
          rethrow;
        }
      }

      retryFormData = newData;
    } else {
      retryFormData = originalOptions.data;
    }

    try {
      final Options options = Options(
        method: originalOptions.method,
        headers: {
          ...originalOptions.headers,
          'Authorization': 'Bearer $accessToken',
        },
        contentType: originalOptions.contentType,
      );

      final dio = Dio(_options);

      return await dio.request(
        originalOptions.path,
        data: retryFormData,
        queryParameters: originalOptions.queryParameters,
        options: options,
      );
    } catch (error) {
      rethrow;
    }
  }
}
