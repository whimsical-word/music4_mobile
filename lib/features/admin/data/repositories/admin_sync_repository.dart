import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart'
    show dioClientProvider;
import '../models/vector_sync_status.dart';

/// Readable error raised by [AdminSyncRepository].
class AdminSyncException implements Exception {
  final String message;

  const AdminSyncException(this.message);

  @override
  String toString() => message;
}

/// What the backend answered to "start a full synchronisation".
enum SyncStartResult {
  /// 202: running in the background now.
  started,

  /// 409: another run is still going.
  alreadyRunning,
}

/// Admin API of the recommendation index.
///
/// - `GET  /api/recommendations/sync/status`: SQL tracks vs Elasticsearch vectors.
/// - `POST /api/recommendations/sync`       : start a full synchronisation.
///
/// Both are ADMIN only: the backend answers 401 / 403 to everyone else.
class AdminSyncRepository {
  final DioClient _dioClient;

  AdminSyncRepository(this._dioClient);

  Future<VectorSyncStatus> getStatus() async {
    try {
      final response = await _dioClient.dio.get(
        ApiEndpoints.recommendationsSyncStatus,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const AdminSyncException('Dữ liệu trạng thái không hợp lệ');
      }
      return VectorSyncStatus.fromJson(data);
    } on DioException catch (e) {
      throw AdminSyncException(_handleError(e, forStatus: true));
    }
  }

  Future<SyncStartResult> startSync() async {
    try {
      await _dioClient.dio.post(ApiEndpoints.recommendationsSync);
      return SyncStartResult.started;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return SyncStartResult.alreadyRunning;
      throw AdminSyncException(_handleError(e, forStatus: false));
    }
  }

  String _handleError(DioException e, {required bool forStatus}) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) return 'Phiên đăng nhập đã hết hạn';
    if (statusCode == 403) return 'Chỉ tài khoản ADMIN mới dùng được chức năng này';
    if (statusCode == 404 && forStatus) {
      return 'Backend chưa có API trạng thái đồng bộ (cần cập nhật backend)';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Mạng quá yếu, thử lại sau';
    }

    return 'Lỗi kết nối máy chủ';
  }
}

final adminSyncRepositoryProvider = Provider<AdminSyncRepository>(
  (ref) => AdminSyncRepository(ref.watch(dioClientProvider)),
);
