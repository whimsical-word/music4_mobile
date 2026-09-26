import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/sources/home_mock_data.dart';
import 'home_feed_state.dart';

class HomeFeedController extends AutoDisposeAsyncNotifier<HomeFeedState> {
  @override
  FutureOr<HomeFeedState> build() {
    return _fetchHomeFeed();
  }

  HomeFeedState _fetchHomeFeed() {
    return const HomeFeedState(
      featuredAiTrack: HomeMockData.featuredAiTrack,
      aiRecommendations: HomeMockData.aiRecommendations,
      trendingTracks: HomeMockData.topTrendingTracks,
    );
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
}

final homeFeedControllerProvider =
    AsyncNotifierProvider.autoDispose<HomeFeedController, HomeFeedState>(
  HomeFeedController.new,
);
