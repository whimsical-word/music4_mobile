import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/auth_state.dart';
import 'package:music4_mobile/features/history/data/models/history_page_response.dart';
import 'package:music4_mobile/features/history/data/models/history_track_response.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}

/// AuthNotifier with a fixed state and no real login/network.
class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(AuthState initial)
    : super(
        loginUseCase: _MockLoginUseCase(),
        logoutUseCase: _MockLogoutUseCase(),
        repository: _MockAuthRepository(),
        tokenStorage: _MockTokenStorage(),
        loginWithGoogleUseCase: _MockLoginWithGoogleUseCase(),
      ) {
    state = initial;
  }

  void setAuthState(AuthState next) => state = next;
}

UserEntity testUser(int id) => UserEntity(
  id: id,
  displayName: 'Listener $id',
  username: 'listener$id',
  isArtist: false,
);

AuthAuthenticated authenticated(int id) => AuthAuthenticated(testUser(id));

HistoryTrackResponse historyTrack(
  int id, {
  String? name,
  String? img,
  int playbackPosition = 0,
  int duration = 200,
  List<TrackArtistInfo>? artists,
}) {
  return HistoryTrackResponse(
    id: id,
    name: name ?? 'Track $id',
    albumName: 'Single',
    img: img,
    duration: duration,
    playbackPosition: playbackPosition,
    artists: artists ?? const [TrackArtistInfo(id: 1, name: 'Artist', role: 'MAIN')],
  );
}

HistoryPageResponse historyPage(int count, {int startId = 1}) {
  return HistoryPageResponse(
    content: [for (var i = 0; i < count; i++) historyTrack(startId + i)],
  );
}

/// Real response shape of `GET /api/tracking/history/{userId}`
/// (Spring Data page serialised via DTO: items in `content`, paging in `page`).
const Map<String, dynamic> realHistoryJson = {
  'content': [
    {
      'id': 5,
      'name': 'Lạc Trôi',
      'albumName': 'Single',
      'img': 'covers/abc.jpg',
      'duration': 200,
      'filePath': 'audio/lac-troi.mp3',
      'previewPath': 'preview/lac-troi.mp3',
      'viewCount': 12,
      'uploadDate': '2026-01-15',
      'playbackPosition': 120,
      'artists': [
        {'id': 10, 'name': 'Sơn Tùng M-TP', 'role': 'MAIN'},
      ],
    },
    {
      'id': 6,
      'name': 'No cover track',
      'albumName': 'Album X',
      'img': null,
      'duration': 180,
      'filePath': null,
      'previewPath': null,
      'viewCount': 0,
      'uploadDate': null,
      'playbackPosition': 0,
      'artists': [],
    },
  ],
  'page': {'size': 20, 'number': 0, 'totalElements': 2, 'totalPages': 1},
};

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

/// Player that only records what History asked it to play.
class RecordingPlayerNotifier extends PlayerNotifier {
  List<TrackQueueItem>? lastQueue;
  int? lastIndex;

  /// Null when History used playPlaylist (start from 0); set when it used
  /// resumePlaylist.
  Duration? lastStartPosition;

  /// Shows a loaded track in the mini player.
  void showTrack(PlayerStateData data) {
    state = AsyncValue.data(data);
  }

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
    lastStartPosition = null;
  }

  @override
  Future<void> resumePlaylist(
    List<TrackQueueItem> playlist,
    int initialIndex, {
    required Duration startPosition,
  }) async {
    lastQueue = playlist;
    lastIndex = initialIndex;
    lastStartPosition = startPosition;
  }
}
