import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/admin_artist_page_model.dart';
import '../models/admin_category_model.dart';
import '../models/admin_user_page_model.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(DioClient().dio);
});

class AdminException implements Exception {
  final String message;
  const AdminException(this.message);

  @override
  String toString() => message;
}

class AdminRepository {
  final Dio _dio;

  AdminRepository(this._dio);

  // ── User Management ────────────────────────────────────────────────────────

  Future<AdminUserPageModel> getUsers({
    int page = 0,
    int size = 50,
    bool includeDeleted = true,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.users,
        queryParameters: {
          'page': page,
          'size': size,
          'includeDeleted': includeDeleted,
        },
      );

      final data = response.data as Map<String, dynamic>;
      return AdminUserPageModel.fromJson(data);
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể tải danh sách người dùng: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _dio.delete('${ApiEndpoints.users}/$userId');
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể vô hiệu hóa tài khoản: $e');
    }
  }

  Future<void> reactivateUser(int userId) async {
    try {
      await _dio.put('${ApiEndpoints.users}/$userId/reactivate');
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể kích hoạt lại tài khoản: $e');
    }
  }

  Future<int> getTotalUsers() async {
    try {
      final response = await _dio.get(ApiEndpoints.userCount);
      return response.data as int;
    } catch (_) {
      return 0;
    }
  }

  // ── Artist Management ──────────────────────────────────────────────────────

  Future<AdminArtistPageModel> getArtists({
    int page = 0,
    int size = 50,
    bool includeDeleted = true,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.artists,
        queryParameters: {
          'page': page,
          'size': size,
          'includeDeleted': includeDeleted,
        },
      );

      final data = response.data as Map<String, dynamic>;
      return AdminArtistPageModel.fromJson(data);
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể tải danh sách nghệ sĩ: $e');
    }
  }

  Future<void> deleteArtist(int artistId) async {
    try {
      await _dio.delete('${ApiEndpoints.artists}/$artistId');
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể vô hiệu hóa nghệ sĩ: $e');
    }
  }

  Future<void> reactivateArtist(int artistId) async {
    try {
      await _dio.put('${ApiEndpoints.artists}/$artistId/reactivate');
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể kích hoạt lại nghệ sĩ: $e');
    }
  }

  Future<int> getTotalArtists() async {
    try {
      final response = await _dio.get('${ApiEndpoints.artists}/count');
      return (response.data as num).toInt();
    } catch (_) {
      return 0;
    }
  }

  // ── Category Management ────────────────────────────────────────────────────

  Future<List<AdminCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final list = response.data as List<dynamic>;
      return list
          .map((item) =>
              AdminCategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể tải danh sách thể loại: $e');
    }
  }

  Future<AdminCategoryModel> createCategory(String name) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.categories,
        data: {'name': name.trim()},
      );
      return AdminCategoryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể tạo thể loại mới: $e');
    }
  }

  Future<AdminCategoryModel> updateCategory(int id, String name) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.categories}/$id',
        data: {'name': name.trim()},
      );
      return AdminCategoryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể cập nhật thể loại: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete('${ApiEndpoints.categories}/$id');
    } on DioException catch (e) {
      throw AdminException(_handleDioError(e));
    } catch (e) {
      throw AdminException('Không thể xóa thể loại: $e');
    }
  }

  // ── Helper ─────────────────────────────────────────────────────────────────

  String _handleDioError(DioException error) {
    if (error.response != null && error.response!.data != null) {
      final data = error.response!.data;
      if (data is String && data.isNotEmpty) return data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối máy chủ quá thời gian. Vui lòng thử lại.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 403) return 'Bảo mật: Bạn không có quyền quản trị viên!';
        if (code == 409) {
          return error.response?.data?.toString() ??
              'Dữ liệu bị trùng lặp hoặc xung đột ràng buộc.';
        }
        return 'Lỗi máy chủ ($code). Vui lòng thử lại.';
      default:
        return 'Đã xảy ra sự cố mạng. Vui lòng thử lại.';
    }
  }
}
