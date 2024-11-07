import 'package:dio/dio.dart';
import 'package:nearby_assist/main.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late Dio dio;

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: endpoint.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }
}
