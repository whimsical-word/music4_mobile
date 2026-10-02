import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/jwt_helper.dart';
import '../../../auth/data/datasources/token_storage.dart';
import '../../../home/data/models/track_detail_model.dart';
import '../../../playlist/data/models/playlist_model.dart';
import '../models/track_comment_model.dart';

final trackDetailDioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final trackDetailRepositoryProvider = Provider<TrackDetailRepository>((ref) {
  final dioClient = ref.watch(trackDetailDioClientProvider);
  return TrackDetailRepository(dioClient.dio);
});

class TrackDetailRepository {
  final Dio _dio;

  TrackDetailRepository(this._dio);

  /// Lấy thông tin chi tiết bài hát theo ID (GET /api/tracks/{id})
  Future<TrackDetailModel> getTrackDetail(int trackId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.trackDetail}/$trackId');
      return TrackDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải thông tin bài hát: $e');
    }
  }

  /// Kiểm tra xem bài hát có nằm trong danh sách yêu thích của người dùng không (GET /api/favorites/me)
  Future<bool> checkIsFavorite(int trackId) async {
    try {
      final response = await _dio.get(ApiEndpoints.favorites);
      final List<dynamic> data = response.data;
      return data.any((item) {
        if (item is Map<String, dynamic>) {
          return item['trackId'] == trackId;
        }
        return false;
      });
    } catch (_) {
      // Nếu chưa đăng nhập hoặc lỗi tải danh sách yêu thích, mặc định là false
      return false;
    }
  }

  /// Thêm hoặc xóa bài hát khỏi danh sách yêu thích (POST /api/favorites/toggle/{trackId})
  Future<bool> toggleFavorite(int trackId) async {
    try {
      final response = await _dio.post('${ApiEndpoints.toggleFavorite}/$trackId');
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('liked')) {
        return data['liked'] as bool;
      }
      return true;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể cập nhật yêu thích: $e');
    }
  }

  /// Lấy danh sách Playlist của người dùng để thêm bài hát (GET /api/playlists/my-playlists)
  Future<List<PlaylistModel>> getUserPlaylists() async {
    try {
      final response = await _dio.get(ApiEndpoints.myPlaylists);
      final List<dynamic> data = response.data;
      return data
          .map((json) => PlaylistModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải danh sách playlist: $e');
    }
  }

  /// Thêm bài hát vào playlist (POST /api/playlists/{playlistId}/tracks/{trackId})
  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    try {
      await _dio.post('${ApiEndpoints.playlists}/$playlistId/tracks/$trackId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể thêm bài hát vào playlist: $e');
    }
  }

  /// Lấy danh sách bình luận của bài hát (GET /api/comments/track/{trackId})
  Future<List<TrackCommentModel>> getComments(int trackId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.trackComments}/$trackId');
      final List<dynamic> data = response.data;
      return data
          .map((json) => TrackCommentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Gửi bình luận mới cho bài hát (POST /api/comments)
  Future<void> addComment({
    required int trackId,
    required String content,
    int? userId,
  }) async {
    try {
      int? effectiveUserId = userId;
      if (effectiveUserId == null) {
        try {
          final token = await TokenStorage.instance.getAccessToken();
          effectiveUserId = JwtHelper.getUserId(token);
        } catch (_) {}
      }

      await _dio.post(
        ApiEndpoints.comments,
        data: {
          'trackId': trackId,
          'userId': ?effectiveUserId,
          'content': content,
        },
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể gửi bình luận: $e');
    }
  }

  /// Chỉnh sửa nội dung bình luận (PUT /api/comments/{commentId})
  Future<void> updateComment({required int commentId, required String content}) async {
    try {
      await _dio.put(
        '${ApiEndpoints.comments}/$commentId',
        data: {'content': content},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể cập nhật bình luận: $e');
    }
  }

  /// Xóa bình luận (DELETE /api/comments/{commentId})
  Future<void> deleteComment(int commentId) async {
    try {
      await _dio.delete('${ApiEndpoints.comments}/$commentId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể xóa bình luận: $e');
    }
  }

  /// Dịch mã lỗi DioException sang tiếng Việt thân thiện
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Mạng quá yếu, vui lòng thử lại sau.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ, vui lòng kiểm tra mạng.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          final data = e.response?.data;
          if (data is Map && data.containsKey('message')) {
            return data['message'].toString();
          }
          return 'Yêu cầu không hợp lệ.';
        } else if (statusCode == 401) {
          return 'Vui lòng đăng nhập để thực hiện thao tác này.';
        } else if (statusCode == 404) {
          return 'Không tìm thấy bài hát yêu cầu.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Máy chủ đang bận ($statusCode), vui lòng thử lại sau.';
        }
        return 'Đã xảy ra lỗi từ máy chủ ($statusCode).';
      default:
        return 'Đã xảy ra lỗi kết nối, vui lòng thử lại.';
    }
  }
}
