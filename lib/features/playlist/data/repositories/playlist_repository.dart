import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/playlist_model.dart';
import '../models/playlist_track_model.dart';

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepository(DioClient().dio);
});

class PlaylistRepository {
  final Dio _dio;

  PlaylistRepository(this._dio);

  /// Lấy danh sách Playlist của người dùng hiện tại (GET /api/playlists/my-playlists)
  Future<List<PlaylistModel>> getMyPlaylists() async {
    try {
      final response = await _dio.get(ApiEndpoints.myPlaylists);
      final List<dynamic> data = response.data;
      return data
          .map((json) => PlaylistModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  /// Tạo Playlist mới (POST /api/playlists)
  Future<PlaylistModel> createPlaylist({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.playlists,
        data: {'name': name, 'description': description ?? ''},
      );
      return PlaylistModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tạo playlist: $e');
    }
  }

  /// Xóa Playlist theo ID (DELETE /api/playlists/{id})
  Future<void> deletePlaylist(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.playlists}/$id');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể xóa playlist: $e');
    }
  }

  /// Cập nhật thông tin Playlist (PUT /api/playlists/{id})
  Future<PlaylistModel> updatePlaylist(
    int id, {
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.playlists}/$id',
        data: {'name': name, 'description': description ?? ''},
      );
      return PlaylistModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể cập nhật playlist: $e');
    }
  }

  /// Cập nhật ảnh bìa Playlist (PUT /api/playlists/{id}/image)
  Future<PlaylistModel> uploadPlaylistImage(int id, String filePath) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      final response = await _dio.put(
        '${ApiEndpoints.playlists}/$id/image',
        data: formData,
      );
      return PlaylistModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải ảnh bìa lên: $e');
    }
  }

  /// "Dịch" lỗi Dio sang tiếng Việt thân thiện theo quy định của Leader
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Mạng quá yếu, vui lòng thử lại sau.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ, vui lòng kiểm tra mạng hoặc IP.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          final data = e.response?.data;
          if (data is Map && data.containsKey('message')) {
            return data['message'].toString();
          }
          return 'Dữ liệu gửi lên không hợp lệ.';
        } else if (statusCode == 401) {
          return 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.';
        } else if (statusCode == 403) {
          return 'Bạn không có quyền thực hiện thao tác này.';
        } else if (statusCode == 404) {
          return 'Không tìm thấy dữ liệu playlist.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Lỗi máy chủ nội bộ ($statusCode), vui lòng thử lại sau.';
        }
        return 'Đã xảy ra lỗi từ máy chủ ($statusCode).';
      case DioExceptionType.cancel:
        return 'Yêu cầu tải dữ liệu đã bị hủy.';
      default:
        return 'Đã xảy ra lỗi kết nối, vui lòng thử lại.';
    }
  }

    /// 1. Lấy thông tin chi tiết một Playlist (GET /api/playlists/{id})
  Future<PlaylistModel> getPlaylistById(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.playlists}/$id');
      return PlaylistModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải chi tiết playlist: $e');
    }
  }

  /// 2. Lấy danh sách bài hát trong Playlist (GET /api/playlists/{id}/tracks)
  Future<List<PlaylistTrackModel>> getTracksByPlaylistId(int playlistId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.playlists}/$playlistId/tracks');
      final List<dynamic> data = response.data;
      return data
          .map((json) => PlaylistTrackModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải danh sách bài hát: $e');
    }
  }

  /// 3. Thêm bài hát vào Playlist (POST /api/playlists/{id}/tracks)
  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    try {
      await _dio.post(
        '${ApiEndpoints.playlists}/$playlistId/tracks',
        data: {'trackId': trackId},
      );
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể thêm bài hát: $e');
    }
  }

  /// 4. Xóa bài hát khỏi Playlist (DELETE /api/playlists/{id}/tracks/{trackId})
  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    try {
      await _dio.delete('${ApiEndpoints.playlists}/$playlistId/tracks/$trackId');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể xóa bài hát khỏi playlist: $e');
    }
  }

  /// 5. Lấy danh sách bài hát hệ thống để gợi ý thêm vào playlist (GET /api/tracks)
  Future<List<PlaylistTrackModel>> getAllTracks() async {
    try {
      final response = await _dio.get('${ApiEndpoints.tracks}?page=0&size=20');
      final data = response.data;
      final List<dynamic> content = (data is Map && data.containsKey('content'))
          ? data['content']
          : (data is List ? data : []);
      return content
          .map((json) => PlaylistTrackModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Không thể tải bài hát gợi ý: $e');
    }
  }
}
