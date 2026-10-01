import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/sources/home_repository.dart';
import '../../data/models/home_track_item.dart';
import 'home_feed_state.dart';

final dioClientProvider = Provider((ref) => DioClient());
final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(ref.read(dioClientProvider)),
);

class HomeFeedController extends AutoDisposeAsyncNotifier<HomeFeedState> {
  @override
  Future<HomeFeedState> build() async {
    return _fetchHomeFeed();
  }

  Future<HomeFeedState> _fetchHomeFeed() async {
    final repo = ref.read(homeRepositoryProvider);

    // Fetch concurrently
    final results = await Future.wait([
      repo.getRecommendations(),
      repo.getTopTrending(),
    ]);

    final recommendations = results[0] as List<dynamic>;
    final trending = results[1] as List<dynamic>;

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
            playsCount: e.viewCount.toString(),
          ),
        )
        .toList();

    return HomeFeedState(
      featuredAiTrack: aiTracks.isNotEmpty ? aiTracks.first : null,
      aiRecommendations: aiTracks.isNotEmpty ? aiTracks.skip(1).toList() : [],
      trendingTracks: trendingTracks,
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => _fetchHomeFeed());
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

  void trackPlay(String trackId) {
    ref.read(homeRepositoryProvider).trackHistory(trackId);
  }
}

final homeFeedControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeFeedController, HomeFeedState>(
      HomeFeedController.new,
    );
