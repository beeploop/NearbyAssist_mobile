import 'package:dio/dio.dart';
import 'package:nearby_assist/interceptors/auth_interceptor.dart';
import 'package:nearby_assist/interceptors/query_param_encoding_interceptor.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';

class ApiService {
  static final ApiService _unAuthInstance = ApiService._unauthenticated();
  static final ApiService _authInstance = ApiService._authenticated();

  factory ApiService.unauthenticated() => _unAuthInstance;
  factory ApiService.authenticated() => _authInstance;

  final _options = BaseOptions(
    baseUrl: SystemSettingProvider().serverURL,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(minutes: 10),
    sendTimeout: const Duration(minutes: 10),
    responseType: ResponseType.json,
  );

  late Dio dio;

  ApiService._unauthenticated() {
    dio = Dio(_options);
    dio.interceptors.add(QueryParamEncodingInterceptor());
  }

  ApiService._authenticated() {
    dio = Dio(_options);
    dio.interceptors.add(QueryParamEncodingInterceptor());
    dio.interceptors.add(AuthInterceptor(_options));
  }
}
