import 'package:dio/dio.dart';
import 'package:nearby_assist/interceptors/auth_interceptor.dart';
import 'package:nearby_assist/main.dart';

class ApiService {
  static final ApiService _unAuthInstance = ApiService._unauthenticated();
  static final ApiService _authInstance = ApiService._authenticated();

  factory ApiService.unauthenticated() => _unAuthInstance;
  factory ApiService.authenticated() => _authInstance;

  final _options = BaseOptions(
    baseUrl: endpoint.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    responseType: ResponseType.json,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  late Dio dio;

  ApiService._unauthenticated() {
    dio = Dio(_options);
  }

  ApiService._authenticated() {
    dio = Dio(_options);
    dio.interceptors.add(AuthInterceptor());
  }
}
