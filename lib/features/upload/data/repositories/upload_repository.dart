import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.watch(dioProvider));
});

class UploadRepository {
  final Dio _dio;

  UploadRepository(this._dio);

  Future<void> uploadTrack({
    required String title,
    required List<int> categoryIds,
    String? albumId,
    List<int>? artistIds,
    required String audioFilePath,
    required String coverFilePath,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final audioFileName = audioFilePath.split(RegExp(r'[\\/]')).last;
      final coverFileName = coverFilePath.split(RegExp(r'[\\/]')).last;

      final Map<String, dynamic> formMap = {
        'title': title,
        'categoryIds': categoryIds,
        if (albumId != null && albumId.trim().isNotEmpty)
          'albumId': int.tryParse(albumId.trim()),
        if (artistIds != null && artistIds.isNotEmpty)
          'artistIds': artistIds,
        'audioFile': await MultipartFile.fromFile(audioFilePath, filename: audioFileName),
        'coverImage': await MultipartFile.fromFile(coverFilePath, filename: coverFileName),
      };

      final formData = FormData.fromMap(formMap, ListFormat.multi);

      await _dio.post(
        '/api/tracks',
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Kết nối mạng quá yếu hoặc máy chủ phản hồi chậm. Vui lòng thử lại sau.");
      }
      if (e.response?.statusCode == 400) {
        String? msg;
        if (e.response?.data is Map) {
          final map = e.response!.data as Map;
          if (map.containsKey('message')) {
            msg = map['message']?.toString();
          } else if (map.isNotEmpty) {
            msg = map.values.first?.toString();
          }
        }
        throw Exception(msg ?? "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin bài hát.");
      }
      if (e.response?.statusCode == 413) {
        throw Exception("File tải lên vượt quá dung lượng cho phép của máy chủ.");
      }
      final serverMsg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw Exception(serverMsg ?? "Lỗi hệ thống (${e.response?.statusCode ?? e.type}): ${e.message}");
    } catch (e) {
      throw Exception("Lỗi không xác định: $e");
    }
  }
}
