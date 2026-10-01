import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // ==========================================
  // 🔴 1. CẤU HÌNH CHO ĐIỆN THOẠI THẬT
  // Mở cmd gõ 'ipconfig' lấy IPv4 dán vào đây (VD: 192.168.1.45)
  // ==========================================
  static const String _lanIp = '192.168.1.45';

  // ==========================================
  // 🔴 2. BẠN ĐANG TEST TRÊN ĐIỆN THOẠI THẬT HAY MÁY ẢO?
  // Để 'true' nếu dùng Máy Ảo (Emulator), 'false' nếu cắm cáp Điện thoại thật
  // ==========================================
  static const bool _isEmulator = true;

  // Tự động phân giải IP theo môi trường
  static String get baseUrl {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return 'http://localhost:8080'; // Web và Desktop luôn là localhost
    }

    if (_isEmulator) {
      if (Platform.isAndroid) return 'http://10.0.2.2:8080'; // Máy ảo Android
      if (Platform.isIOS) {
        return 'http://localhost:8080'; // Máy ảo iOS (Simulator)
      }
    }

    // Điện thoại thật (Phải bắt chung mạng WiFi với máy tính)
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

  // Recommendations & History
  static const String recommendations = '/api/recommendations';
  static const String history = '/api/tracking/history';
  static const String syncPlaybackTime = '/api/tracking/sync-time';

  // Search
  static const String search = '/api/search';

  // Notifications
  static const String notifications = '/api/notifications/user'; // + /{userId}
  static const String subscribeNotification =
      '/api/notifications/subscribe'; // + /{userId}
}
