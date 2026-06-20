import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';

/// Dio HTTP client singleton configured for the NestJS backend.
/// Currently unused (mock data), but ready for backend integration.
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  /// Set the auth token for authenticated requests.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token on logout.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

/// Interceptor that adds auth token from storage if available.
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token expiry — redirect to login
    }
    handler.next(err);
  }
}
