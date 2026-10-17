import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/artist_track_model.dart';

final trackManagementDioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final trackManagementRepositoryProvider = Provider<TrackManagementRepository>((ref) {
  final dioClient = ref.watch(trackManagementDioClientProvider);
  return TrackManagementRepository(dioClient.dio);
});

class TrackManagementRepository {
  final Dio _dio;

  TrackManagementRepository(this._dio);

  /// UC47: Lấy toàn bộ danh sách bài hát do nghệ sĩ sở hữu (GET /api/tracks/artist/{artistId})
  Future<List<ArtistTrackItemModel>> getArtistTracks(int artistId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.trackDetail}/artist/$artistId');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => ArtistTrackItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// UC49: Lấy danh sách bài hát thuộc một Album cụ thể (GET /api/tracks/album/{albumId})
  Future<List<ArtistTrackItemModel>> getTracksByAlbum(int albumId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.trackDetail}/album/$albumId');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => ArtistTrackItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// UC50: Cập nhật thông tin (metadata) bài hát (POST /api/tracks/update/{id})
  Future<void> updateTrackMetadata({
    required int trackId,
    String? title,
    int? albumId,
    List<int>? categoryIds,
    List<int>? collabArtistIds,
    File? coverImageFile,
  }) async {
    try {
      final formMap = <String, dynamic>{};

      if (title != null && title.isNotEmpty) {
        formMap['title'] = title;
      }

      if (albumId != null) {
        formMap['albumId'] = albumId;
      }

      if (categoryIds != null) {
        formMap['categoryIds'] = categoryIds;
      }

      if (collabArtistIds != null) {
        formMap['collabArtistIds'] = collabArtistIds;
      }

      if (coverImageFile != null && await coverImageFile.exists()) {
        final fileName = coverImageFile.path.split(Platform.pathSeparator).last;
        formMap['coverImage'] = await MultipartFile.fromFile(
          coverImageFile.path,
          filename: fileName,
        );
      }

      await _dio.post(
        '${ApiEndpoints.trackDetail}/update/$trackId',
        data: FormData.fromMap(formMap),
      );
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// UC51: Xóa bài hát khỏi hệ thống (DELETE /api/tracks/{id})
  Future<void> deleteTrack(int trackId) async {
    try {
      await _dio.delete('${ApiEndpoints.trackDetail}/$trackId');
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// UC52: Lấy Top 5 bài hát có lượt nghe cao nhất (GET /api/tracks/top5-views)
  Future<List<ArtistTrackItemModel>> getTop5Trending() async {
    try {
      final response = await _dio.get(ApiEndpoints.top5Tracks);
      if (response.data is List) {
        return (response.data as List)
            .map((item) => ArtistTrackItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw Exception('Mạng quá yếu, vui lòng thử lại sau.');
    }
    if (e.type == DioExceptionType.connectionError) {
      throw Exception('Không thể kết nối đến máy chủ, vui lòng kiểm tra mạng.');
    }
    if (e.response?.statusCode == 404) {
      throw Exception('Không tìm thấy bài hát yêu cầu.');
    }
    if (e.response?.statusCode == 403) {
      throw Exception('Bạn không có quyền thực hiện thao tác này trên bài hát.');
    }
    final message = (e.response?.data is Map) ? e.response?.data['message'] : null;
    throw Exception(message?.toString() ?? 'Lỗi hệ thống: ${e.message}');
  }
}
