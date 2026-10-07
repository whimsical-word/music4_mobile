import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/favorite_response.dart';

/// Readable error raised by [FavoritesRepository]; its message is shown as-is
/// in the Favorites error state.
class FavoritesException implements Exception {
  final String message;

  const FavoritesException(this.message);

  @override
  String toString() => message;
}

/// Favorites API. The backend identifies the user from the JWT (added by the
/// DioClient interceptor), so no user id is sent.
/// - `GET  /api/favorites/me`              the user's favorite tracks
/// - `POST /api/favorites/toggle/{trackId}` like / unlike, returns `{liked}`
///
/// A signed-out request makes the backend fail with a 500, so callers must
/// not use this repository for a guest.
class FavoritesRepository {
  final DioClient _dioClient;

  FavoritesRepository(this._dioClient);

  Future<List<FavoriteResponse>> getMyFavorites() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.favorites);
      return (response.data as List<dynamic>)
          .map((e) => FavoriteResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw FavoritesException(_handleDioError(e));
    } catch (_) {
      throw const FavoritesException(
        'Dữ liệu yêu thích không hợp lệ. Vui lòng thử lại.',
      );
    }
  }

  /// Toggles the favorite state of [trackId] and returns the NEW state
  /// (true = now a favorite). The backend only offers a toggle, so the result
  /// must always be read from the response.
  Future<bool> toggleFavorite(int trackId) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.toggleFavorite}/$trackId',
      );
      return (response.data as Map<String, dynamic>)['liked'] as bool;
    } on DioException catch (e) {
      throw FavoritesException(_handleDioError(e));
    } catch (_) {
      throw const FavoritesException(
        'Không thể cập nhật yêu thích. Vui lòng thử lại.',
      );
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối máy chủ quá thời gian. Vui lòng kiểm tra mạng.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
        }
        if (statusCode == 403) {
          return 'Bạn không có quyền thực hiện thao tác này.';
        }
        if (statusCode == 404) {
          return 'Không tìm thấy dữ liệu yêu thích.';
        }
        return 'Lỗi máy chủ ($statusCode). Vui lòng thử lại sau.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      default:
        return 'Đã xảy ra lỗi mạng không xác định.';
    }
  }
}
