import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_artist_info.freezed.dart';
part 'track_artist_info.g.dart';

@freezed
abstract class TrackArtistInfo with _$TrackArtistInfo {
  const factory TrackArtistInfo({
    required int id,
    required String name,
    String? role,
  }) = _TrackArtistInfo;

  factory TrackArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$TrackArtistInfoFromJson(json);
}
