import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Dịch vụ quản lý bộ nhớ đệm (Cache) âm thanh cục bộ phục vụ nghe nhạc Offline (UC42)
class AudioCacheService {
  AudioCacheService._();
  static final AudioCacheService instance = AudioCacheService._();

  /// Lấy đối tượng File cache tương ứng với trackId
  Future<File> getCacheFile(String trackId) async {
    final cacheDir = await getApplicationDocumentsDirectory();
    return File('${cacheDir.path}/music4_cache_$trackId.mp3');
  }

  /// Kiểm tra bài hát đã được cache hoàn chỉnh trong máy hay chưa (> 100KB)
  Future<bool> isTrackCached(String trackId) async {
    try {
      final file = await getCacheFile(trackId);
      return await file.exists() && await file.length() > 102400;
    } catch (_) {
      return false;
    }
  }

  /// Tính tổng dung lượng (bytes) của các bài hát đang được cache
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      int total = 0;
      final entities = cacheDir.listSync();
      for (final entity in entities) {
        if (entity is File && entity.path.contains('music4_cache_') && !entity.path.endsWith('.tmp')) {
          total += entity.lengthSync();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Xóa file cache của một bài hát cụ thể
  Future<void> clearTrackCache(String trackId) async {
    try {
      final file = await getCacheFile(trackId);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('[AUDIO_CACHE] Lỗi xóa cache bài hát $trackId: $e');
    }
  }

  /// Xóa toàn bộ file cache bài hát trong máy
  Future<void> clearAllCache() async {
    try {
      final cacheDir = await getApplicationDocumentsDirectory();
      final entities = cacheDir.listSync();
      for (final entity in entities) {
        if (entity is File && entity.path.contains('music4_cache_')) {
          await entity.delete();
        }
      }
    } catch (e) {
      debugPrint('[AUDIO_CACHE] Lỗi xóa toàn bộ cache: $e');
    }
  }
}
