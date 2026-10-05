import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../data/models/home_track_item.dart';
import '../../data/sources/home_repository.dart';
import 'home_feed_state.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(ref.read(dioClientProvider)),
);

class HomeFeedController extends AutoDisposeAsyncNotifier<HomeFeedState> {
  int _silentRefreshId = 0;

  @override
  Future<HomeFeedState> build() {
    return _fetchHomeFeed();
  }

  Future<HomeFeedState> _fetchHomeFeed() async {
    final repo = ref.read(homeRepositoryProvider);

    // Start both requests concurrently.
    final recommendationsFuture = repo.getRecommendations();
    final trendingFuture = repo.getTopTrending();

    final recommendations = await recommendationsFuture;
    final trending = await trendingFuture;

    final aiTracks = recommendations
        .map(
          (e) => HomeTrackItem(
            id: e.id.toString(),
            title: e.name,
            artist: e.artists.isNotEmpty
                ? e.artists.map((a) => a.name).join(', ')
                : 'Unknown Artist',
            coverUrl: ImageUrlHelper.resolve(e.img),
            duration: _formatDuration(e.duration ?? 0),
            durationSeconds: e.duration ?? 0,
            matchPercentage: e.matchScore != null
                ? (e.matchScore! * 100).toInt()
                : null,
          ),
        )
        .toList();

    final trendingTracks = trending
        .map(
          (e) => HomeTrackItem(
            id: e.id.toString(),
            title: e.name,
            artist: e.artists.isNotEmpty
                ? e.artists.map((a) => a.name).join(', ')
                : 'Unknown Artist',
            coverUrl: ImageUrlHelper.resolve(e.img),
            duration: _formatDuration(e.duration ?? 0),
            durationSeconds: e.duration ?? 0,
            playsCount: e.viewCount.toString(),
          ),
        )
        .toList();

    return HomeFeedState(
      featuredAiTrack: aiTracks.isNotEmpty ? aiTracks.first : null,
      aiRecommendations: aiTracks.length > 1 ? aiTracks.sublist(1) : const [],
      trendingTracks: trendingTracks,
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchHomeFeed);
  }

  Future<void> trackPlay(String trackId) async {
    try {
      // Wait until backend tracking is completed.
      await ref.read(homeRepositoryProvider).trackHistory(trackId);

      // Create a new generation for the silent refresh.
      final refreshId = ++_silentRefreshId;

      final newState = await _fetchHomeFeed();

      // Ignore an older refresh if a newer one has started.
      if (refreshId != _silentRefreshId) {
        return;
      }

      // Silent refresh:
      // replace data directly without triggering loading/shimmer.
      if (state.hasValue && !state.isLoading) {
        state = AsyncValue.data(newState);
      }
    } catch (_) {
      // Tracking/refresh failure must not interrupt playback.
    }
  }

  void setLoadingForTesting() {
    state = const AsyncValue.loading();
  }

  void setEmptyForTesting() {
    state = const AsyncValue.data(
      HomeFeedState(
        featuredAiTrack: null,
        aiRecommendations: [],
        trendingTracks: [],
      ),
    );
  }

  void setErrorForTesting(String message) {
    state = AsyncValue.error(message, StackTrace.current);
  }
}

final homeFeedControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeFeedController, HomeFeedState>(
      HomeFeedController.new,
    );
