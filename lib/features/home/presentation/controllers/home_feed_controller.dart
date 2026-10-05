import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../data/models/home_track_item.dart';
import '../../data/models/track_detail_model.dart';
import '../../data/models/track_suggest_model.dart';
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

    // Run both requests concurrently. Future.wait observes every future, so a
    // failure in one request never leaves the other as an unhandled error.
    final results = await Future.wait<Object>([
      repo.getRecommendations(),
      repo.getTopTrending(),
    ]);
    final recommendations = results[0] as List<TrackSuggestModel>;
    final trending = results[1] as List<TrackDetailModel>;

    final aiTracks = recommendations
        .map(
          (e) => HomeTrackItem(
            id: e.id.toString(),
            title: e.name,
            artistId: e.artists.isNotEmpty ? e.artists.first.id.toString() : null,
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
            artistId: e.artists.isNotEmpty ? e.artists.first.id.toString() : null,
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

  /// Reloads the feed in the background and swaps the data in place.
  ///
  /// No loading/shimmer state is emitted, and existing data is kept if the
  /// refresh fails. Called after a track was genuinely listened to the end.
  Future<void> silentRefresh() async {
    // Create a new generation: an older refresh must not overwrite a newer one.
    final refreshId = ++_silentRefreshId;

    try {
      final newState = await _fetchHomeFeed();

      if (refreshId != _silentRefreshId) return;

      if (state.hasValue && !state.isLoading) {
        state = AsyncValue.data(newState);
      }
    } catch (_) {
      // A failed background refresh keeps the current Home content.
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
