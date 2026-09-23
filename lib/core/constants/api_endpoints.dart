class ApiEndpoints {
  ApiEndpoints._();

  // Thay đổi IP này theo môi trường chạy của bạn (VD: 10.0.2.2 cho Android Emulator, localhost cho iOS/Web, hoặc IP máy LAN)
  static const String baseUrl = 'http://10.0.2.2:8080';
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
  static const String tracks = '/api/tracks';
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
  static const String subscribeNotification = '/api/notifications/subscribe'; // + /{userId}
}
