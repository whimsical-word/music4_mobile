import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final response = await _dio.get('/api/albums');
      final List data = response.data;
      return data.map((json) => AlbumModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
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

      final response = await _dio.post('/api/albums', data: formData);
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
      await _dio.delete('/api/albums/$albumId');
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw Exception("Mạng quá yếu, thử lại sau.");
    }
    if (e.response?.statusCode == 404) {
      throw Exception("Không tìm thấy dữ liệu.");
    }
    if (e.response?.statusCode == 403) {
      throw Exception("Bạn không có quyền thực hiện thao tác này.");
    }
    throw Exception("Lỗi hệ thống: ${e.message}");
  }
}
