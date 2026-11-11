import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_overview_response.freezed.dart';
part 'artist_overview_response.g.dart';

/// `GET /api/analytics/artist/{id}/overview` -> ArtistOverviewResponse.
/// `topTracks` is ignored: the profile already lists the artist's tracks.
@freezed
abstract class ArtistOverviewResponse with _$ArtistOverviewResponse {
  const factory ArtistOverviewResponse({
    @Default(0) int totalViews,
    @Default(0) int totalFavorites,
    @Default(0) int totalFollowers,
    @Default(0) int totalComments,
    @Default([]) List<DailyAnalyticsResponse> chartData,
  }) = _ArtistOverviewResponse;

  factory ArtistOverviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ArtistOverviewResponseFromJson(json);
}

/// One chart point. `day` is an ISO date (yyyy-MM-dd).
@freezed
abstract class DailyAnalyticsResponse with _$DailyAnalyticsResponse {
  const factory DailyAnalyticsResponse({
    String? day,
    @Default(0) int views,
    @Default(0) int likes,
  }) = _DailyAnalyticsResponse;

  factory DailyAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyAnalyticsResponseFromJson(json);
}
