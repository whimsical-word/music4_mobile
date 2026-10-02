import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_track_response.freezed.dart';
part 'history_track_response.g.dart';

@freezed
sealed class HistoryTrackResponse with _$HistoryTrackResponse {
  const factory HistoryTrackResponse({
    required int id,
    required String name,
    required String albumName,
    String? img,
    required int duration,
    String? filePath,
    String? previewPath,
    int? viewCount,
    String? uploadDate,
    required int playbackPosition,
    @Default([]) List<TrackArtistInfo> artists,
  }) = _HistoryTrackResponse;

  factory HistoryTrackResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryTrackResponseFromJson(json);
}

@freezed
sealed class TrackArtistInfo with _$TrackArtistInfo {
  const factory TrackArtistInfo({
    required int id,
    required String name,
    required String role,
  }) = _TrackArtistInfo;

  factory TrackArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$TrackArtistInfoFromJson(json);
}
