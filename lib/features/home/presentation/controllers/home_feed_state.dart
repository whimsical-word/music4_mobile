import '../../data/models/home_track_item.dart';

class HomeFeedState {
  final HomeTrackItem? featuredAiTrack;
  final List<HomeTrackItem> aiRecommendations;
  final List<HomeTrackItem> trendingTracks;

  const HomeFeedState({
    this.featuredAiTrack,
    this.aiRecommendations = const [],
    this.trendingTracks = const [],
  });

  bool get isEmpty => aiRecommendations.isEmpty && trendingTracks.isEmpty;

  HomeFeedState copyWith({
    HomeTrackItem? featuredAiTrack,
    List<HomeTrackItem>? aiRecommendations,
    List<HomeTrackItem>? trendingTracks,
  }) {
    return HomeFeedState(
      featuredAiTrack: featuredAiTrack ?? this.featuredAiTrack,
      aiRecommendations: aiRecommendations ?? this.aiRecommendations,
      trendingTracks: trendingTracks ?? this.trendingTracks,
    );
  }
}
