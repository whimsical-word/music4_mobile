import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/track_detail_model.dart';
import '../models/artist_overview_response.dart';
import '../models/artist_response.dart';

/// Readable error raised by [ArtistProfileRepository]; its message is shown
/// as-is in the Artist Profile error state.
class ArtistProfileException implements Exception {
  final String message;

  const ArtistProfileException(this.message);

  @override
  String toString() => message;
}

/// Artist Profile APIs (all public, `/api/**` is permitAll):
/// - `GET  /api/artists/{id}`                      artist info
/// - `GET  /api/tracks/artist/{id}`                every track of the artist
/// - `GET  /api/albums/artist/{id}`                every album of the artist
/// - `GET  /api/analytics/artist/{id}/overview`    totals (followers, ...)
/// - `GET  /api/follows/user/{userId}`             artists the user follows
/// - `POST /api/follows/toggle?userId=&artistId=`  follow / unfollow
///
/// Tracks reuse [TrackDetailModel] and albums reuse [AlbumInfo]: they match
/// the backend's `TrackResponseDTO` / `AlbumResponseDTO` exactly.
class ArtistProfileRepository {
  final DioClient _dioClient;

  ArtistProfileRepository(this._dioClient);

  Future<ArtistResponse> getArtist(int artistId) {
    return _get(
      '${ApiEndpoints.artists}/$artistId',
      (data) => ArtistResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<List<TrackDetailModel>> getArtistTracks(int artistId) {
    return _get(
      '${ApiEndpoints.trackDetail}/artist/$artistId',
      (data) => (data as List<dynamic>)
          .map((e) => TrackDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<List<AlbumInfo>> getArtistAlbums(int artistId) {
    return _get(
      '${ApiEndpoints.albums}/artist/$artistId',
      (data) => (data as List<dynamic>)
          .map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ArtistOverviewResponse> getOverview(int artistId) {
    return _get(
      '${ApiEndpoints.analytics}/artist/$artistId/overview',
      (data) =>
          ArtistOverviewResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Whether [userId] already follows [artistId].
  Future<bool> isFollowing({required int userId, required int artistId}) {
    return _get(
      '${ApiEndpoints.follows}/user/$userId',
      (data) => (data as List<dynamic>).any(
        (e) => (e as Map<String, dynamic>)['artistId'] == artistId,
      ),
    );
  }

  /// Toggles the follow state and returns the NEW state (true = following).
  Future<bool> toggleFollow({
    required int userId,
    required int artistId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiEndpoints.follows}/toggle',
        queryParameters: {'userId': userId, 'artistId': artistId},
      );
      return (response.data as Map<String, dynamic>)['following'] as bool;
    } on DioException catch (e) {
      throw ArtistProfileException(_handleDioError(e));
    } catch (_) {
      throw const ArtistProfileException(
        'Không thể cập nhật theo dõi. Vui lòng thử lại.',
      );
    }
  }

  Future<T> _get<T>(String path, T Function(dynamic data) parse) async {
    try {
      final response = await _dioClient.dio.get(path);
      return parse(response.data);
    } on DioException catch (e) {
      throw ArtistProfileException(_handleDioError(e));
    } catch (_) {
      throw const ArtistProfileException(
        'Dữ liệu nghệ sĩ không hợp lệ. Vui lòng thử lại.',
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
          return 'Không tìm thấy nghệ sĩ.';
        }
        return 'Lỗi máy chủ ($statusCode). Vui lòng thử lại sau.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      default:
        return 'Đã xảy ra lỗi mạng không xác định.';
    }
  }
}
