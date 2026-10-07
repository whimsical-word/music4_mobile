import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/favorites/data/models/favorite_response.dart';
import 'package:music4_mobile/features/favorites/data/repositories/favorites_repository.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

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

  void setAuthState(AuthState next) => state = next;
}

AuthAuthenticated authenticated(int id) => AuthAuthenticated(
  UserEntity(
    id: id,
    displayName: 'Listener $id',
    username: 'listener$id',
    isArtist: false,
  ),
);

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

class _MockAppAudioHandler extends Mock implements AppAudioHandler {}

AudioPlayer _createMockAudioPlayer() {
  final mock = _MockAudioPlayer();
  when(() => mock.playerStateStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.positionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.bufferedPositionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.durationStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.playbackEventStream).thenAnswer((_) => const Stream.empty());
  return mock;
}

/// Player that only records what Favorites asked it to play.
class RecordingPlayerNotifier extends PlayerNotifier {
  List<TrackQueueItem>? lastQueue;
  int? lastIndex;

  RecordingPlayerNotifier()
    : super(
        _createMockAudioPlayer(),
        _MockTrackDetailRepo(),
        _MockAppAudioHandler(),
      );

  @override
  Future<void> playPlaylist(List<TrackQueueItem> playlist, int initialIndex) async {
    lastQueue = playlist;
    lastIndex = initialIndex;
  }
}

/// Real `GET /api/favorites/me` response (a list of `FavoriteResponseDTO`).
/// Track 12 has no artist and no image, track 13 has a full image URL.
const List<Map<String, dynamic>> realFavoritesJson = [
  {
    'favoriteId': 1,
    'trackId': 11,
    'trackName': 'Lạc Trôi',
    'artistName': 'Sơn Tùng M-TP',
    'img': 'covers/t11.jpg',
    'likedAt': '2026-10-01T10:00:00.123456',
  },
  {
    'favoriteId': 2,
    'trackId': 12,
    'trackName': 'Không có ảnh',
    'artistName': '',
    'img': null,
    'likedAt': '2026-10-05T08:30:00',
  },
  {
    'favoriteId': 3,
    'trackId': 13,
    'trackName': 'Hai nghệ sĩ',
    'artistName': 'A, B',
    'img': 'https://cdn.example.com/t13.jpg',
    'likedAt': '2026-10-03T09:00:00',
  },
];

List<FavoriteResponse> favoriteResponses() =>
    realFavoritesJson.map(FavoriteResponse.fromJson).toList();
