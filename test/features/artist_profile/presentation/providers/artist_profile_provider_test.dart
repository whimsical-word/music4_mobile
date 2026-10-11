import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_overview_response.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_response.dart';
import 'package:music4_mobile/features/artist_profile/data/repositories/artist_profile_repository.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/artist_profile_data.dart';
import 'package:music4_mobile/features/artist_profile/presentation/providers/artist_profile_provider.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';

import '../../artist_profile_test_helpers.dart';

void main() {
  late MockArtistProfileRepository repository;
  late ProviderContainer container;

  const guestParams = ArtistProfileParams(artistId: '3');
  const ownerParams = ArtistProfileParams(artistId: '3', isOwner: true);

  void stubSuccess() {
    when(
      () => repository.getArtist(3),
    ).thenAnswer((_) async => ArtistResponse.fromJson(realArtistJson));
    when(() => repository.getArtistTracks(3)).thenAnswer(
      (_) async => realTracksJson.map(TrackDetailModel.fromJson).toList(),
    );
    when(() => repository.getArtistAlbums(3)).thenAnswer(
      (_) async => realAlbumsJson.map(AlbumInfo.fromJson).toList(),
    );
    when(() => repository.getOverview(3)).thenAnswer(
      (_) async => ArtistOverviewResponse.fromJson(realOverviewJson),
    );
    when(
      () => repository.isFollowing(
        userId: any(named: 'userId'),
        artistId: any(named: 'artistId'),
      ),
    ).thenAnswer((_) async => false);
  }

  /// Creates the container and keeps the autoDispose provider alive.
  void start({
    AuthState auth = const AuthUnauthenticated(),
    ArtistProfileParams params = guestParams,
  }) {
    container = ProviderContainer(
      overrides: [
        artistProfileRepositoryProvider.overrideWithValue(repository),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(artistProfileProvider(params), (_, _) {});
  }

  Future<ArtistProfileData> load([ArtistProfileParams params = guestParams]) {
    return container.read(artistProfileProvider(params).future);
  }

  ArtistProfileNotifier notifier([ArtistProfileParams params = guestParams]) {
    return container.read(artistProfileProvider(params).notifier);
  }

  setUp(() {
    repository = MockArtistProfileRepository();
  });

  group('[CE190284] ArtistProfileNotifier - loading', () {
    test('loads artist, tracks and albums of the given artistId only', () async {
      stubSuccess();
      start();

      final data = await load();

      verify(() => repository.getArtist(3)).called(1);
      verify(() => repository.getArtistTracks(3)).called(1);
      verify(() => repository.getArtistAlbums(3)).called(1);
      verifyNever(() => repository.getArtist(1));

      expect(data.artist.id, '3');
      expect(data.artist.name, 'Ngọt');
      expect(data.popularTracks.map((t) => t.id), ['12', '11', '13']);
      expect(data.albums.map((a) => a.id), ['22', '21']);
    });

    test('follower count comes from the analytics overview', () async {
      stubSuccess();
      start();

      final data = await load();

      expect(data.artist.followersCount, 42);
    });

    test('dashboard stats are loaded only in owner mode', () async {
      stubSuccess();
      start();
      expect((await load()).dashboardStats, isNull);

      start(params: ownerParams);
      final owner = await load(ownerParams);
      expect(owner.dashboardStats?.totalViews, 1500);
      expect(owner.dashboardStats?.chartViews, hasLength(7));
    });

    test('empty tracks and albums are a valid data state', () async {
      stubSuccess();
      when(() => repository.getArtistTracks(3)).thenAnswer((_) async => []);
      when(() => repository.getArtistAlbums(3)).thenAnswer((_) async => []);
      start();

      final data = await load();

      expect(data.popularTracks, isEmpty);
      expect(data.albums, isEmpty);
      expect(data.artist.name, 'Ngọt');
    });
  });

  group('[CE190284] ArtistProfileNotifier - auth / follow state', () {
    test('a guest does not request the followings list', () async {
      stubSuccess();
      start();

      final data = await load();

      verifyNever(
        () => repository.isFollowing(
          userId: any(named: 'userId'),
          artistId: any(named: 'artistId'),
        ),
      );
      expect(data.isFollowing, isFalse);
    });

    test('a signed-in user gets the follow state of this artist', () async {
      stubSuccess();
      when(
        () => repository.isFollowing(userId: 7, artistId: 3),
      ).thenAnswer((_) async => true);
      start(auth: authenticated(7));

      final data = await load();

      verify(() => repository.isFollowing(userId: 7, artistId: 3)).called(1);
      expect(data.isFollowing, isTrue);
    });
  });

  group('[CE190284] ArtistProfileNotifier - errors', () {
    test('optional requests failing do not fail the profile', () async {
      stubSuccess();
      when(
        () => repository.getOverview(3),
      ).thenAnswer((_) async => throw const ArtistProfileException('Lỗi'));
      when(
        () => repository.isFollowing(userId: 7, artistId: 3),
      ).thenAnswer((_) async => throw const ArtistProfileException('Lỗi'));
      start(auth: authenticated(7));

      final data = await load();

      expect(data.artist.followersCount, isNull); // not invented
      expect(data.isFollowing, isFalse);
      expect(data.popularTracks, isNotEmpty);
    });

    test('a failing required request becomes an error, retry() recovers', () async {
      stubSuccess();
      var fail = true;
      when(() => repository.getArtist(3)).thenAnswer((_) async {
        if (fail) throw const ArtistProfileException('Không tìm thấy nghệ sĩ.');
        return ArtistResponse.fromJson(realArtistJson);
      });
      start();

      await expectLater(load(), throwsA(isA<ArtistProfileException>()));
      final state = container.read(artistProfileProvider(guestParams));
      expect(state.hasError, isTrue);
      expect(state.error.toString(), 'Không tìm thấy nghệ sĩ.');

      fail = false;
      await notifier().retry();

      expect(
        container.read(artistProfileProvider(guestParams)).value?.artist.name,
        'Ngọt',
      );
    });

    test('a missing or invalid artist id is an error without any request', () async {
      for (final id in <String?>[null, 'abc', '']) {
        final params = ArtistProfileParams(artistId: id);
        start(params: params);

        await expectLater(load(params), throwsA(isA<ArtistProfileException>()));
      }

      verifyNever(() => repository.getArtist(any()));
    });
  });

  group('[CE190284] ArtistProfileNotifier - toggleFollow', () {
    test('a guest is asked to sign in and no request is made', () async {
      stubSuccess();
      start();
      await load();

      final result = await notifier().toggleFollow();

      expect(result, FollowResult.needsLogin);
      verifyNever(
        () => repository.toggleFollow(
          userId: any(named: 'userId'),
          artistId: any(named: 'artistId'),
        ),
      );
    });

    test('following updates the state and the follower count', () async {
      stubSuccess();
      when(
        () => repository.toggleFollow(userId: 7, artistId: 3),
      ).thenAnswer((_) async => true);
      start(auth: authenticated(7));
      await load();

      final result = await notifier().toggleFollow();

      expect(result, FollowResult.success);
      final data = container.read(artistProfileProvider(guestParams)).value!;
      expect(data.isFollowing, isTrue);
      expect(data.artist.followersCount, 43);
    });

    test('unfollowing lowers the follower count', () async {
      stubSuccess();
      when(
        () => repository.isFollowing(userId: 7, artistId: 3),
      ).thenAnswer((_) async => true);
      when(
        () => repository.toggleFollow(userId: 7, artistId: 3),
      ).thenAnswer((_) async => false);
      start(auth: authenticated(7));
      await load();

      await notifier().toggleFollow();

      final data = container.read(artistProfileProvider(guestParams)).value!;
      expect(data.isFollowing, isFalse);
      expect(data.artist.followersCount, 41);
    });

    test('a failed toggle keeps the state and reports failure', () async {
      stubSuccess();
      when(
        () => repository.toggleFollow(userId: 7, artistId: 3),
      ).thenAnswer((_) async => throw const ArtistProfileException('Lỗi'));
      start(auth: authenticated(7));
      await load();

      final result = await notifier().toggleFollow();

      expect(result, FollowResult.failed);
      final data = container.read(artistProfileProvider(guestParams)).value!;
      expect(data.isFollowing, isFalse);
      expect(data.artist.followersCount, 42);
    });
  });
}
