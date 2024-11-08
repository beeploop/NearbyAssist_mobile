import 'package:dio/dio.dart';

class QueryParamEncodingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.queryParameters.isEmpty) {
      super.onRequest(options, handler);
      return;
    }

    final params = _getParams(options.queryParameters);
    handler.next(
      options.copyWith(
        path: _normalizeUrl(options.path, params),
        queryParameters: Map.from({}),
      ),
    );
  }

  String _getParams(Map<String, dynamic> params) {
    String result = '';
    params.forEach((key, value) {
      result += '$key=$value&';
    });

    return result;
  }

  String _normalizeUrl(String url, String params) {
    if (url.contains('?')) {
      return '$url&$params';
    }

    return '$url?$params';
  }
}
