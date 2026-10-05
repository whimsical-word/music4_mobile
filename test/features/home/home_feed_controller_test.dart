import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/home/data/models/track_artist_info.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/home/data/models/track_suggest_model.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

TrackSuggestModel _suggest(
  int id, {
  String? img,
  int? duration = 200,
  double? matchScore,
  List<TrackArtistInfo> artists = const [],
}) {
  return TrackSuggestModel(
    id: id,
    name: 'Rec $id',
    img: img,
    duration: duration,
    matchScore: matchScore,
    artists: artists,
  );
}

TrackDetailModel _trending(
  int id, {
  String? img,
  int? duration = 185,
  int viewCount = 0,
  List<TrackArtistInfo> artists = const [],
}) {
  return TrackDetailModel(
    id: id,
    name: 'Trend $id',
    img: img,
    duration: duration,
    viewCount: viewCount,
    artists: artists,
  );
}

void main() {
  late MockHomeRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockHomeRepository();
    container = ProviderContainer(
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  /// Starts (and keeps alive) the autoDispose controller, then waits for the
  /// first load. Call it only after the repository has been stubbed, because
  /// listening triggers `build()` immediately.
  Future<HomeFeedState> loadFeed() {
    container.listen(homeFeedControllerProvider, (_, _) {});
    return container.read(homeFeedControllerProvider.future);
  }

  group('[CE190284] HomeFeedController mapping (repository mocked)', () {
    test('maps recommendations: first is featured, rest are the list', () async {
      when(() => repository.getRecommendations()).thenAnswer(
        (_) async => [
          _suggest(
            1,
            matchScore: 0.75,
            artists: const [
              TrackArtistInfo(id: 10, name: 'Artist A'),
              TrackArtistInfo(id: 11, name: 'Artist B'),
            ],
          ),
          _suggest(2, matchScore: 0.5),
        ],
      );
      when(() => repository.getTopTrending()).thenAnswer((_) async => []);

      final feed = await loadFeed();

      expect(feed.featuredAiTrack?.id, '1');
      expect(feed.featuredAiTrack?.title, 'Rec 1');
      expect(feed.featuredAiTrack?.artist, 'Artist A, Artist B');
      expect(feed.featuredAiTrack?.artistId, '10');
      expect(feed.featuredAiTrack?.matchPercentage, 75);
      expect(feed.featuredAiTrack?.duration, '3:20');
      expect(feed.featuredAiTrack?.durationSeconds, 200);

      expect(feed.aiRecommendations, hasLength(1));
      expect(feed.aiRecommendations.first.id, '2');
      expect(feed.aiRecommendations.first.matchPercentage, 50);
      expect(feed.aiRecommendations.first.artist, 'Unknown Artist');
      expect(feed.aiRecommendations.first.artistId, isNull);
      expect(feed.isEmpty, isFalse);
    });

    test('maps trending tracks with view count and formatted duration',
        () async {
      when(() => repository.getRecommendations()).thenAnswer((_) async => []);
      when(() => repository.getTopTrending()).thenAnswer(
        (_) async => [
          _trending(
            7,
            viewCount: 1500,
            artists: const [TrackArtistInfo(id: 1, name: 'Solo')],
          ),
          _trending(8, duration: null),
        ],
      );

      final feed = await loadFeed();

      expect(feed.featuredAiTrack, isNull);
      expect(feed.trendingTracks, hasLength(2));
      expect(feed.trendingTracks[0].id, '7');
      expect(feed.trendingTracks[0].title, 'Trend 7');
      expect(feed.trendingTracks[0].artist, 'Solo');
      expect(feed.trendingTracks[0].artistId, '1');
      expect(feed.trendingTracks[0].playsCount, '1500');
      expect(feed.trendingTracks[0].duration, '3:05');
      expect(feed.trendingTracks[1].duration, '0:00');
      expect(feed.trendingTracks[1].durationSeconds, 0);
    });

    test('resolves S3 object keys and keeps full URLs for cover images',
        () async {
      when(() => repository.getRecommendations()).thenAnswer(
        (_) async => [
          _suggest(1, img: 'covers/abc.jpg'),
          _suggest(2, img: 'https://cdn.example.com/full.jpg'),
          _suggest(3, img: null),
          _suggest(4, img: ''),
        ],
      );
      when(() => repository.getTopTrending()).thenAnswer(
        (_) async => [_trending(9, img: 'covers/trend.png')],
      );

      final feed = await loadFeed();

      expect(
        feed.featuredAiTrack?.coverUrl,
        '${ImageUrlHelper.s3BaseUrl}covers/abc.jpg',
      );
      expect(
        feed.aiRecommendations[0].coverUrl,
        'https://cdn.example.com/full.jpg',
      );
      expect(feed.aiRecommendations[1].coverUrl, isNull);
      expect(feed.aiRecommendations[2].coverUrl, isNull);
      expect(
        feed.trendingTracks.first.coverUrl,
        '${ImageUrlHelper.s3BaseUrl}covers/trend.png',
      );
    });

    test('empty API responses produce an empty feed state', () async {
      when(() => repository.getRecommendations()).thenAnswer((_) async => []);
      when(() => repository.getTopTrending()).thenAnswer((_) async => []);

      final feed = await loadFeed();

      expect(feed.isEmpty, isTrue);
      expect(feed.featuredAiTrack, isNull);
    });

    test('silentRefresh swaps in new data without emitting loading', () async {
      when(() => repository.getRecommendations())
          .thenAnswer((_) async => [_suggest(1)]);
      when(() => repository.getTopTrending()).thenAnswer((_) async => []);

      await loadFeed();

      final emitted = <AsyncValue<HomeFeedState>>[];
      container.listen(homeFeedControllerProvider, (_, next) {
        emitted.add(next);
      });

      // The listener now reports a different feed after the refresh.
      when(() => repository.getRecommendations())
          .thenAnswer((_) async => [_suggest(2)]);

      await container.read(homeFeedControllerProvider.notifier).silentRefresh();

      expect(emitted.any((s) => s.isLoading), isFalse);
      expect(
        container.read(homeFeedControllerProvider).value?.featuredAiTrack?.id,
        '2',
      );
    });

    test('silentRefresh keeps the current data when the request fails', () async {
      when(() => repository.getRecommendations())
          .thenAnswer((_) async => [_suggest(1)]);
      when(() => repository.getTopTrending()).thenAnswer((_) async => []);

      await loadFeed();

      when(() => repository.getRecommendations())
          .thenAnswer((_) async => throw Exception('Lỗi kết nối máy chủ'));

      await container.read(homeFeedControllerProvider.notifier).silentRefresh();

      final state = container.read(homeFeedControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.value?.featuredAiTrack?.id, '1');
    });

    test('API failure becomes AsyncError and refresh() recovers', () async {
      var fail = true;
      when(() => repository.getRecommendations()).thenAnswer((_) async {
        if (fail) throw Exception('Lỗi kết nối máy chủ');
        return [_suggest(1)];
      });
      when(() => repository.getTopTrending()).thenAnswer((_) async {
        if (fail) throw Exception('Lỗi kết nối máy chủ');
        return [_trending(2)];
      });

      try {
        await loadFeed();
      } catch (_) {
        // Expected: the first build fails.
      }
      expect(container.read(homeFeedControllerProvider).hasError, isTrue);

      fail = false;
      await container.read(homeFeedControllerProvider.notifier).refresh();

      final state = container.read(homeFeedControllerProvider);
      expect(state.hasError, isFalse);
      expect(state.value?.featuredAiTrack?.id, '1');
      expect(state.value?.trendingTracks.first.id, '2');
    });
  });
}
