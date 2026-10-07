import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/artist_profile/data/repositories/artist_profile_repository.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';

class MockArtistProfileRepository extends Mock
    implements ArtistProfileRepository {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

/// AuthNotifier with a fixed state and no real login/network.
class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(AuthState initial)
    : super(
        loginUseCase: _MockLoginUseCase(),
        logoutUseCase: _MockLogoutUseCase(),
        repository: _MockAuthRepository(),
        tokenStorage: _MockTokenStorage(),
      ) {
    state = initial;
  }
}

AuthAuthenticated authenticated(int id) => AuthAuthenticated(
  UserEntity(
    id: id,
    displayName: 'Listener $id',
    username: 'listener$id',
    isArtist: false,
  ),
);

// ─── Real backend response shapes ─────────────────────────────────────────

/// `GET /api/artists/3` (ArtistResponseDTO). The backend also sends `email`
/// and `userName`; the app ignores them.
const Map<String, dynamic> realArtistJson = {
  'id': 3,
  'name': 'Ngọt',
  'img': 'avatars/ngot.jpg',
  'cover': 'covers/ngot-cover.jpg',
  'email': 'ngot@example.com',
  'userName': 'ngot',
  'trackTotal': 3,
  'albumTotal': 2,
};

/// `GET /api/tracks/artist/3` (a list of `TrackResponseDTO`): `playbackPosition` is
/// null on this endpoint, `albumName` is "Single" for tracks without album.
const List<Map<String, dynamic>> realTracksJson = [
  {
    'id': 11,
    'name': 'Lần Cuối',
    'albumName': 'Album Cũ',
    'img': 'covers/t11.jpg',
    'duration': 215,
    'filePath': 'audio/t11.mp3',
    'previewPath': 'preview/t11.mp3',
    'viewCount': 100,
    'uploadDate': '2026-01-15',
    'playbackPosition': null,
    'artists': [
      {'id': 3, 'name': 'Ngọt', 'role': 'MAIN'},
    ],
  },
  {
    'id': 12,
    'name': 'Cho Tôi Đi Theo',
    'albumName': 'Single',
    'img': null,
    'duration': 198,
    'filePath': null,
    'previewPath': null,
    'viewCount': 900,
    'uploadDate': null,
    'playbackPosition': null,
    'artists': [],
  },
  {
    'id': 13,
    'name': 'Em Dạo Này',
    'albumName': 'Album Mới',
    'img': 'https://cdn.example.com/t13.jpg',
    'duration': 185,
    'viewCount': 100,
    'playbackPosition': null,
    'artists': [
      {'id': 3, 'name': 'Ngọt', 'role': 'MAIN'},
      {'id': 4, 'name': 'Guest', 'role': 'FEATURED'},
    ],
  },
];

/// `GET /api/albums/artist/3` (a list of `AlbumResponseDTO`).
const List<Map<String, dynamic>> realAlbumsJson = [
  {
    'id': 21,
    'name': 'Album Cũ',
    'img': 'covers/a21.jpg',
    'uploadDate': '2025-05-01',
    'trackTotal': 5,
    'artistId': 3,
  },
  {
    'id': 22,
    'name': 'Album Mới',
    'img': null,
    'uploadDate': '2026-02-01',
    'trackTotal': 8,
    'artistId': 3,
  },
];

/// `GET /api/analytics/artist/3/overview` (ArtistOverviewResponse): nine
/// days of chart data, only the last seven are shown.
final Map<String, dynamic> realOverviewJson = {
  'totalViews': 1500,
  'totalFavorites': 120,
  'totalFollowers': 42,
  'totalComments': 9,
  'chartData': [
    for (var d = 1; d <= 9; d++)
      {'day': '2026-10-0$d', 'views': d * 10, 'likes': d},
  ],
  'topTracks': [
    {'id': 11, 'name': 'Lần Cuối', 'viewCount': 100, 'favoriteCount': 5},
  ],
};
