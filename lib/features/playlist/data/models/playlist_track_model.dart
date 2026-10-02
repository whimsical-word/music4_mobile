import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_track_model.freezed.dart';
part 'playlist_track_model.g.dart';

@freezed
abstract class TrackArtistInfoModel with _$TrackArtistInfoModel {
  const factory TrackArtistInfoModel({int? id, String? name, String? role}) =
      _TrackArtistInfoModel;

  factory TrackArtistInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TrackArtistInfoModelFromJson(json);
}

@freezed
abstract class PlaylistTrackModel with _$PlaylistTrackModel {
  const PlaylistTrackModel._();

  const factory PlaylistTrackModel({
    required int id,
    required String name,
    String? albumName,
    String? img,
    @Default(0) int duration,
    String? filePath,
    String? previewPath,
    @Default(0) int viewCount,
    @Default([]) List<TrackArtistInfoModel> artists,
  }) = _PlaylistTrackModel;

  factory PlaylistTrackModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistTrackModelFromJson(json);

  /// Helper lấy chuỗi nghệ sĩ: "Sơn Tùng M-TP, Charlie Puth"
  String get artistNames {
    if (artists.isEmpty) return 'Nhiều nghệ sĩ';
    return artists
        .map((a) => a.name ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');
  }

  /// Helper đổi giây thành định dạng mm:ss (VD: 204s -> "03:24")
  String get formattedDuration {
    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
