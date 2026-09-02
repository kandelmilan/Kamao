// It will: Load BASE_URL  , Configure Dio , Set timeouts , Add interceptors , Handle common request options
// Every repository will use this client.
import 'package:dio/dio.dart';
import 'package:kamao/core/core.dart';
import 'package:requests_inspector/requests_inspector.dart';

class ApiConfig {
  final Dio dio;

  ApiConfig() : dio = Dio(_baseOptions()) {
    // Separate Dio, same config, NO interceptors — used only by
    // AuthInterceptor for refresh + retry, to avoid infinite refresh loops.
    final refreshDio = Dio(_baseOptions());

    dio.interceptors.add(ApiInterceptor(refreshDio));
    dio.interceptors.add(RequestsInspectorInterceptor());
  }

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: 'https://aayurise.gyanbato.com/api/v1',
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      sendTimeout: AppConstants.sendTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }
}
