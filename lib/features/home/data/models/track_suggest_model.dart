import 'package:freezed_annotation/freezed_annotation.dart';

import 'track_artist_info.dart';

part 'track_suggest_model.freezed.dart';
part 'track_suggest_model.g.dart';

@freezed
abstract class TrackSuggestModel with _$TrackSuggestModel {
  const factory TrackSuggestModel({
    required int id,
    required String name,
    String? img,
    int? duration,
    String? previewPath,
    @Default(0) int viewCount,
    double? matchScore,
    @Default([]) List<TrackArtistInfo> artists,
  }) = _TrackSuggestModel;

  factory TrackSuggestModel.fromJson(Map<String, dynamic> json) =>
      _$TrackSuggestModelFromJson(json);
}
