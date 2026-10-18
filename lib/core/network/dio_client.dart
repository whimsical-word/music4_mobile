import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_endpoints.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio dio;
  late final Dio retryDio;

  DioClient({
    TokenStorage? tokenStorage,
    BaseOptions? baseOptions,
    VoidCallback? onTokenExpired,
  }) {
    final storage = tokenStorage ?? TokenStorage();

    final options =
        baseOptions ??
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: ApiEndpoints.connectTimeout,
          receiveTimeout: ApiEndpoints.receiveTimeout,
          headers: {'Content-Type': 'application/json'},
        );

    retryDio = Dio(options);

    dio = Dio(options);

    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: storage,
        refreshDio: retryDio,
        onTokenExpired: onTokenExpired,
      ),
    );

    if (kDebugMode) {
      final logger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      );

      dio.interceptors.add(logger);
      retryDio.interceptors.add(logger);
    }
  }
}
