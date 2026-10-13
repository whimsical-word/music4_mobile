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
    required String categoryId,
    String? albumId,
    String? collabArtists,
    required String audioFilePath,
    required String coverFilePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'categoryId': categoryId,
        if (albumId != null && albumId.isNotEmpty) 'albumId': albumId,
        if (collabArtists != null && collabArtists.isNotEmpty) 'collabArtists': collabArtists,
        'audioFile': await MultipartFile.fromFile(audioFilePath, filename: audioFilePath.split('/').last),
        'coverFile': await MultipartFile.fromFile(coverFilePath, filename: coverFilePath.split('/').last),
      });

      await _dio.post(
        '/api/tracks/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Máº¡ng quÃ¡ yáº¿u, thá»­ láº¡i sau.");
      }
      if (e.response?.statusCode == 400) {
        throw Exception("Dá»¯ liá»‡u khÃ´ng há»£p lá»‡. Vui lÃ²ng kiá»ƒm tra láº¡i.");
      }
      if (e.response?.statusCode == 413) {
        throw Exception("File quÃ¡ lá»›n.");
      }
      throw Exception("Lá»—i há»‡ thá»‘ng: ${e.message}");
    } catch (e) {
      throw Exception("Lá»—i khÃ´ng xÃ¡c Ä‘á»‹nh: $e");
    }
  }
}

