import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/album_detail_model.dart';
import '../models/album_model.dart';

final _dioProvider = Provider<Dio>((ref) => DioClient().dio);

final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  return AlbumRepository(ref.watch(_dioProvider));
});

class AlbumRepository {
  final Dio _dio;

  AlbumRepository(this._dio);

  Future<List<AlbumModel>> getAlbums() async {
    try {
      final response = await _dio.get(ApiEndpoints.albums);
      final List data = response.data;
      return data.map((json) => AlbumModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Lấy chi tiết Album (bao gồm thông tin album và danh sách bài hát)
  Future<AlbumDetailModel> getAlbumDetail(int albumId) async {
    try {
      // 1. Lấy danh sách bài hát trong Album từ GET /api/tracks/album/{albumId}
      List<AlbumTrackModel> tracks = [];
      try {
        final tracksResponse =
            await _dio.get('${ApiEndpoints.trackDetail}/album/$albumId');
        if (tracksResponse.data is List) {
          tracks = (tracksResponse.data as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => AlbumTrackModel.fromJson(e))
              .toList();
        }
      } catch (_) {
        // Bỏ qua nếu endpoint tracks chưa có dữ liệu
      }

      // 2. Lấy thông tin Album: thử GET /api/albums/{albumId}
      try {
        final albumResponse = await _dio.get('${ApiEndpoints.albums}/$albumId');
        if (albumResponse.data is Map<String, dynamic>) {
          return AlbumDetailModel.fromJson(
            albumResponse.data as Map<String, dynamic>,
            tracks: tracks,
          );
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
          // Fallback: tìm trong danh sách tất cả albums GET /api/albums
          final allAlbumsResponse = await _dio.get(ApiEndpoints.albums);
          if (allAlbumsResponse.data is List) {
            Map<String, dynamic>? matched;
            for (final item in allAlbumsResponse.data as List) {
              if (item is Map<String, dynamic> &&
                  (item['id'] == albumId ||
                      item['id']?.toString() == albumId.toString())) {
                matched = item;
                break;
              }
            }
            if (matched != null) {
              return AlbumDetailModel.fromJson(
                matched,
                tracks: tracks,
              );
            }
          }
        } else {
          _handleError(e);
        }
      }

      // 3. Nếu có tracks, suy luận thông tin album từ bài hát
      if (tracks.isNotEmpty) {
        return AlbumDetailModel(
          id: albumId,
          title: tracks.first.albumName ?? 'Album #$albumId',
          coverUrl: tracks.first.img,
          artistName: tracks.first.artistsDisplayText,
          trackTotal: tracks.length,
          tracks: tracks,
        );
      }

      throw Exception('Không tìm thấy dữ liệu Album.');
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Không thể tải chi tiết album: $e');
    }
  }

  Future<AlbumModel> createAlbum({
    required String title,
    required String coverFilePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'coverFile': await MultipartFile.fromFile(coverFilePath, filename: coverFilePath.split('/').last),
      });

      final response = await _dio.post(ApiEndpoints.albums, data: formData);
      return AlbumModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw Exception("Khong the mo file anh cover. Vui long kiem tra lai.");
    }
  }

  Future<void> deleteAlbum(String albumId) async {
    try {
      await _dio.delete('${ApiEndpoints.albums}/$albumId');
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw Exception("Mạng quá yếu, vui lòng thử lại sau.");
    }
    if (e.type == DioExceptionType.connectionError) {
      throw Exception("Không thể kết nối đến máy chủ, vui lòng kiểm tra mạng.");
    }
    if (e.response?.statusCode == 404) {
      throw Exception("Không tìm thấy dữ liệu Album.");
    }
    if (e.response?.statusCode == 403) {
      throw Exception("Bạn không có quyền thực hiện thao tác này.");
    }
    throw Exception("Lỗi hệ thống: ${e.message}");
  }
}
