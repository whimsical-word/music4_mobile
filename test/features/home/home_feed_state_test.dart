import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/home/data/models/home_track_item.dart';
import 'package:music4_mobile/features/home/data/models/track_suggest_model.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

const _track = HomeTrackItem(id: '1', title: 'Track', artist: 'Artist');

void main() {
  group('[CE190284] HomeFeedState.isEmpty', () {
    test('is empty when there is nothing at all', () {
      expect(const HomeFeedState().isEmpty, isTrue);
    });

    test('is NOT empty when only the featured track exists', () {
      // One recommendation becomes the featured track and leaves
      // aiRecommendations empty.
      expect(const HomeFeedState(featuredAiTrack: _track).isEmpty, isFalse);
    });

    test('is NOT empty with only recommendations', () {
      expect(const HomeFeedState(aiRecommendations: [_track]).isEmpty, isFalse);
    });

    test('is NOT empty with only trending tracks', () {
      expect(const HomeFeedState(trendingTracks: [_track]).isEmpty, isFalse);
    });
  });

  group('[CE190284] HomeFeedController with a single recommendation', () {
    test('the only recommendation becomes the featured track and the feed is not empty', () async {
      final repository = MockHomeRepository();
      when(() => repository.getRecommendations()).thenAnswer(
        (_) async => [
          const TrackSuggestModel(id: 1, name: 'Only one', duration: 200),
        ],
      );
      when(() => repository.getTopTrending()).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [homeRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      container.listen(homeFeedControllerProvider, (_, _) {});

      final feed = await container.read(homeFeedControllerProvider.future);

      expect(feed.featuredAiTrack?.id, '1');
      expect(feed.aiRecommendations, isEmpty);
      expect(feed.trendingTracks, isEmpty);
      expect(feed.isEmpty, isFalse); // used to be true (the bug)
    });
  });
}
