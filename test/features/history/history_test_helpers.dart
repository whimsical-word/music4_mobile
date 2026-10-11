import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/history/data/models/history_page_response.dart';
import 'package:music4_mobile/features/history/data/models/history_track_response.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

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
  List<TrackArtistInfo>? artists,
}) {
  return HistoryTrackResponse(
    id: id,
    name: name ?? 'Track $id',
    albumName: 'Single',
    img: img,
    duration: 200,
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
