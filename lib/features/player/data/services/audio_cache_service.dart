import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Dịch vụ quản lý bộ nhớ đệm (Cache) âm thanh cục bộ phục vụ nghe nhạc Offline (UC42)
class AudioCacheService {
  AudioCacheService._();
  static final AudioCacheService instance = AudioCacheService._();

  /// Thư mục lưu cache âm thanh
  Future<Directory> _getCacheDirectory() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Khắc phục lỗi Windows: Nếu Documents bị OneDrive đồng bộ đổi tên thành "Tài liệu"
      // chứa ký tự tiếng Việt có dấu, WinRT MediaPlayer sẽ báo lỗi:
      // "(1) The system cannot find the path specified". Khi đó chuyển sang LOCALAPPDATA.
      if (Platform.isWindows && dir.path.contains(RegExp(r'[^\x00-\x7F]'))) {
        final localAppData = Platform.environment['LOCALAPPDATA'];
        if (localAppData != null && localAppData.isNotEmpty) {
          final fallbackDir = Directory('$localAppData/music4_mobile/cache');
          if (!fallbackDir.existsSync()) {
            fallbackDir.createSync(recursive: true);
          }
          return fallbackDir;
        }
      }
      return dir;
    } catch (_) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData != null && localAppData.isNotEmpty) {
        final fallbackDir = Directory('$localAppData/music4_mobile/cache');
        if (!fallbackDir.existsSync()) {
          fallbackDir.createSync(recursive: true);
        }
        return fallbackDir;
      }
      return Directory.systemTemp;
    }
  }

  /// Lấy đối tượng File cache tương ứng với trackId
  Future<File> getCacheFile(String trackId) async {
    final cacheDir = await _getCacheDirectory();
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
      final cacheDir = await _getCacheDirectory();
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
      final cacheDir = await _getCacheDirectory();
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
