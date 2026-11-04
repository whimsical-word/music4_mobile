import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../album/data/models/album_model.dart';
import '../models/track_detail_model.dart';
import '../models/track_suggest_model.dart';

/// Readable error raised by [HomeRepository]; its message is shown as-is in
/// the Home error state (no "Exception: " prefix).
class HomeException implements Exception {
  final String message;

  const HomeException(this.message);

  @override
  String toString() => message;
}

class HomeRepository {
  final DioClient _dioClient;

  HomeRepository(this._dioClient);

  Future<List<TrackSuggestModel>> getRecommendations() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.recommendations);

      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>? ?? [];

        return list
            .map((e) => TrackSuggestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data is List) {
        return data
            .map((e) => TrackSuggestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw HomeException(_handleError(e));
    }
  }

  Future<List<TrackDetailModel>> getTopTrending() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.top5Tracks);

      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'] as List<dynamic>? ?? [];

        return list
            .map((e) => TrackDetailModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data is List) {
        return data
            .map((e) => TrackDetailModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw HomeException(_handleError(e));
    }
  }

  /// One page of `GET /api/albums/all?page=&size=` (a Spring Data page whose
  /// `content` items are AlbumDetailResponseDTO: id, name, img, uploadDate,
  /// trackTotal, a nested `artist` and the album's `tracks`).
  Future<List<AlbumModel>> getAlbumsPage({int page = 0, int size = 10}) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.albums}/all',
        queryParameters: {'page': page, 'size': size},
      );

      final data = response.data;
      final content = data is Map<String, dynamic> ? data['content'] : null;
      if (content is! List) return [];

      return content.whereType<Map<String, dynamic>>().map((json) {
        final artist = json['artist'];
        return AlbumModel.fromJson({
          ...json,
          if (artist is Map<String, dynamic> && artist['id'] != null)
            'artistId': artist['id'],
        });
      }).toList();
    } on DioException catch (e) {
      throw HomeException(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Mạng quá yếu, thử lại sau';
    }

    final statusCode = e.response?.statusCode;

    if (statusCode == 404) {
      return 'Không tìm thấy dữ liệu';
    }

    if (statusCode == 401) {
      return 'Phiên đăng nhập đã hết hạn';
    }

    if (statusCode == 403) {
      return 'Bạn không có quyền thực hiện thao tác này';
    }

    return 'Lỗi kết nối máy chủ';
  }
}
