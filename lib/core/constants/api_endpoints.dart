import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String s3BaseUrl =
      'https://music4-v3-storage-kenz.s3.ap-southeast-1.amazonaws.com/';

  static String buildImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return s3BaseUrl + path;
  }

  // ==========================================
  // 1. CẤU HÌNH IP MÁY TÍNH KHI TEST QUA WI-FI (KHÔNG DÙNG CÁP)
  // ==========================================
  static const String _lanIp = '192.168.1.160';

  // ==========================================
  // 🔴 2. CHẾ ĐỘ KẾT NỐI CHO THIẾT BỊ:
  // - _useUsbCable = true: Cắm cáp USB (dùng adb reverse tcp:8080 tcp:8080)
  //   -> Đề xuất số 1 khi Demo: không phụ thuộc Wi-Fi, không sợ mạng trường chặn LAN.
  // - _isEmulator = true: Dùng máy ảo Android Emulator (10.0.2.2)
  // - Cả 2 đều false: Dùng điện thoại thật kết nối qua Wi-Fi nội bộ (_lanIp)
  // ==========================================
  static const bool _useUsbCable = false;
  static const bool _isEmulator = false;

  static String get baseUrl {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return 'http://localhost:8080'; // Web và Desktop luôn là localhost
    }

    // Khi cắm cáp USB trên điện thoại thật có adb reverse
    if (_useUsbCable) {
      return 'http://localhost:8080';
    }

    if (_isEmulator) {
      if (Platform.isAndroid) return 'http://10.0.2.2:8080'; // Máy ảo Android
      if (Platform.isIOS) {
        return 'http://localhost:8080'; // Máy ảo iOS (Simulator)
      }
      if (Platform.isMacOS) {
        return 'http://localhost:8080'; // Ứng dụng macOS
      }
    }

    return 'http://$_lanIp:8080';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refresh = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // Tracks & Media
  static const String tracks = '/api/tracks/all';
  static const String trackDetail = '/api/tracks'; // + /{id}
  static const String uploadTrack = '/api/tracks';
  static const String uploadTemp = '/api/tracks/upload-temp';
  static const String bulkJson = '/api/tracks/bulk-json';
  static const String streamTrack = '/api/tracks/stream'; // + /{id}?token=
  static const String streamPreview = '/api/tracks/stream/preview'; // + /{id}
  static const String top5Tracks = '/api/tracks/top5-views';
  static const String randomTracks = '/api/tracks/random';

  // Playlists
  static const String playlists = '/api/playlists';
  static const String myPlaylists = '/api/playlists/my-playlists';

  // Favorites
  static const String favorites = '/api/favorites/me';
  static const String toggleFavorite = '/api/favorites/toggle'; // + /{trackId}

  // Artists & Albums
  static const String artists = '/api/artists';
  static const String top3Artists = '/api/artists/top3';
  static const String albums = '/api/albums';
  static const String follows = '/api/follows';
  static const String analytics = '/api/analytics';

  // Comments
  static const String comments = '/api/comments';
  static const String trackComments = '/api/comments/track'; // + /{trackId}

  // Recommendations & History
  static const String recommendations = '/api/recommendations';
  static const String history = '/api/tracking/history';
  static const String syncPlaybackTime = '/api/tracking/sync-time';

  // Search
  static const String search = '/api/search';

  // Notifications
  static const String notifications = '/api/notifications/user'; // + /{userId}
  static const String subscribeNotification =
      '/api/notifications/subscribe'; // + /{userId} (SSE)
  static const String notificationBase =
      '/api/notifications'; // + /{id}/read | /{id} | /clear-all

  // User Profile
  static const String userProfile = '/api/users'; // + /{userId}
}
