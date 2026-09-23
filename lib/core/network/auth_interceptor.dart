import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio retryDio;
  bool _isRefreshing = false;
  final _pendingRequests = <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  AuthInterceptor({
    required this.storage,
    required this.retryDio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        _pendingRequests.add((options: err.requestOptions, handler: handler));
        return;
      }

      _isRefreshing = true;
      try {
        final refreshToken = await storage.read(key: 'refresh_token');
        if (refreshToken == null || refreshToken.isEmpty) {
          handler.reject(err);
          return;
        }

        final refreshResponse = await retryDio.post(
          ApiEndpoints.refresh,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = refreshResponse.data['accessToken'] as String?;
        final newRefreshToken = refreshResponse.data['refreshToken'] as String?;

        if (newAccessToken != null) {
          await storage.write(key: 'access_token', value: newAccessToken);
          if (newRefreshToken != null) {
            await storage.write(key: 'refresh_token', value: newRefreshToken);
          }

          // Retry pending requests
          for (final pending in _pendingRequests) {
            pending.options.headers['Authorization'] = 'Bearer $newAccessToken';
            pending.handler.resolve(await retryDio.fetch(pending.options));
          }
          _pendingRequests.clear();

          // Retry the current failed request
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          handler.resolve(await retryDio.fetch(err.requestOptions));
          return;
        }
      } catch (e) {
        await storage.deleteAll();
        handler.reject(err);
        return;
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }
}
