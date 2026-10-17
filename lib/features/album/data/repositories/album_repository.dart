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

      // Lấy danh sách artists để ánh xạ artistId sang artistName
      final Map<int, String> artistNamesMap = {};
      try {
        final artistsResponse = await _dio.get('${ApiEndpoints.artists}/all');
        if (artistsResponse.data is List) {
          for (final a in artistsResponse.data as List) {
            if (a is Map<String, dynamic> && a['id'] != null && a['name'] != null) {
              final id = a['id'] is int ? a['id'] as int : int.tryParse(a['id'].toString());
              if (id != null) {
                artistNamesMap[id] = a['name'].toString();
              }
            }
          }
        }
      } catch (_) {}

      return data.map((json) {
        if (json is Map<String, dynamic>) {
          final aId = json['artistId'] is int
              ? json['artistId'] as int
              : int.tryParse(json['artistId']?.toString() ?? '');
          final nameFromMap = aId != null ? artistNamesMap[aId] : null;
          return AlbumModel.fromJson(json, artistNameOverride: nameFromMap);
        }
        return AlbumModel.fromJson(json as Map<String, dynamic>);
      }).toList();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// UC4: Lấy danh sách Album của một ca sĩ cụ thể
  Future<List<AlbumModel>> getAlbumsByArtist(int artistId, {String? artistName}) async {
    try {
      final response = await _dio.get('${ApiEndpoints.albums}/artist/$artistId');
      final List data = response.data is List ? response.data as List : [];
      return data.map((json) {
        if (json is Map<String, dynamic>) {
          return AlbumModel.fromJson(json, artistNameOverride: artistName);
        }
        return AlbumModel.fromJson(json as Map<String, dynamic>, artistNameOverride: artistName);
      }).toList();
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
        // Bỏ qua nếu endpoint tracks chưa có dữ liệu hoặc lỗi
      }

      // 2. Thử lấy từ GET /api/albums/{albumId} nếu có
      Map<String, dynamic>? albumJson;
      try {
        final albumResponse = await _dio.get('${ApiEndpoints.albums}/$albumId');
        if (albumResponse.data is Map<String, dynamic>) {
          albumJson = albumResponse.data as Map<String, dynamic>;
        }
      } on DioException catch (e) {
        if (_isNetworkError(e)) {
          _handleError(e);
        }
        // Nếu backend trả 500/404/405 do chưa có route /{id}, tiếp tục fallback sang danh sách albums
      } catch (_) {}

      // 3. Fallback: tìm trong danh sách tất cả albums GET /api/albums (endpoint chuẩn Spring Boot)
      if (albumJson == null) {
        try {
          final allAlbumsResponse = await _dio.get(ApiEndpoints.albums);
          if (allAlbumsResponse.data is List) {
            for (final item in allAlbumsResponse.data as List) {
              if (item is Map<String, dynamic> &&
                  (item['id'] == albumId ||
                      item['id']?.toString() == albumId.toString())) {
                albumJson = item;
                break;
              }
            }
          }
        } on DioException catch (e) {
          if (_isNetworkError(e)) {
            _handleError(e);
          }
        } catch (_) {}
      }

      // 4. Nếu tìm thấy albumJson, xác định artistName đầy đủ
      if (albumJson != null) {
        String? resolvedArtistName;

        // Ưu tiên 1: Tên nghệ sĩ từ tracks của album
        if (tracks.isNotEmpty &&
            tracks.first.artistsDisplayText.isNotEmpty &&
            tracks.first.artistsDisplayText != 'Chưa rõ nghệ sĩ') {
          resolvedArtistName = tracks.first.artistsDisplayText;
        }

        // Ưu tiên 2: Gọi GET /api/artists/{artistId} nếu albumJson có artistId
        if (resolvedArtistName == null) {
          final aId = albumJson['artistId'] is int
              ? albumJson['artistId'] as int
              : int.tryParse(albumJson['artistId']?.toString() ?? '');
          if (aId != null) {
            try {
              final artistRes = await _dio.get('${ApiEndpoints.artists}/$aId');
              if (artistRes.data is Map<String, dynamic> &&
                  artistRes.data['name'] != null) {
                resolvedArtistName = artistRes.data['name'].toString();
              }
            } catch (_) {}
          }
        }

        final model = AlbumDetailModel.fromJson(
          albumJson,
          tracks: tracks,
        );

        if (resolvedArtistName != null && resolvedArtistName.isNotEmpty) {
          return model.copyWith(artistName: resolvedArtistName);
        }
        return model;
      }

      // 5. Nếu có tracks, suy luận thông tin album từ bài hát
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

      // 6. Fallback an toàn cho album mẫu test
      return AlbumDetailModel(
        id: albumId,
        title: 'Album #$albumId',
        artistName: 'Chưa rõ nghệ sĩ',
        trackTotal: 0,
        tracks: const [],
      );
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

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError;
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
