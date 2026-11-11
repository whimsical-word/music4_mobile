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

  /// True only when there is nothing to show at all. The featured track counts:
  /// the controller makes the first recommendation the featured one, so a feed
  /// with a single recommendation has an empty [aiRecommendations] list.
  bool get isEmpty =>
      featuredAiTrack == null &&
      aiRecommendations.isEmpty &&
      trendingTracks.isEmpty;

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
