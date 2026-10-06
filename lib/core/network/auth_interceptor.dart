import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';

import '../constants/api_endpoints.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage tokenStorage;
  final Dio refreshDio;
  final VoidCallback? onTokenExpired;

  Future<String>? _refreshFuture;

  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDio,
    this.onTokenExpired,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(
      ApiEndpoints.refresh,
    );

    // Không phải 401 hoặc chính API refresh bị 401 -> cho qua luôn
    if (!isUnauthorized || isRefreshCall) {
      return handler.next(err);
    }

    final refreshFuture = _refreshFuture ??= _refreshAccessToken();
    try {
      final newAccessToken = await refreshFuture;
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await refreshDio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      // Refresh thất bại (hết hạn, revoke, v.v.)
      await _handleSessionExpired(err, handler);
    } finally {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    }
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('No refresh token available.');
    }

    final refreshResponse = await refreshDio.post(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    final newAccessToken = refreshResponse.data['accessToken'] as String?;
    final newRefreshToken = refreshResponse.data['refreshToken'] as String?;

    if (newAccessToken == null || newAccessToken.isEmpty) {
      throw StateError('Refresh response did not contain an access token.');
    }

    await tokenStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
    return newAccessToken;
  }

  /// Dọn dẹp session, hủy các request đang chờ và kích hoạt callback logout
  Future<void> _handleSessionExpired(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await tokenStorage.clearSession();

    handler.reject(err);

    // Kích hoạt callback về UI/Bloc/Provider
    onTokenExpired?.call();
  }
}
