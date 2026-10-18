// Trigger build_runner
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
sealed class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required String id,
    required String title,
    String? coverUrl,
    required String artistId,
    required String artistName,
    @Default(0) int trackCount,
    required DateTime releaseDate,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json, {String? artistNameOverride}) {
    DateTime parsedDate;
    final rawDate = json['releaseDate'] ?? json['uploadDate'];
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate.toString());
      } catch (_) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    String resolvedArtistName = artistNameOverride ?? 'Chưa rõ nghệ sĩ';
    if (artistNameOverride == null) {
      if (json['artist'] is Map<String, dynamic> &&
          json['artist']['name'] != null) {
        resolvedArtistName = json['artist']['name'].toString();
      } else if (json['artistName'] != null) {
        resolvedArtistName = json['artistName'].toString();
      }
    }

    String resolvedArtistId = '0';
    if (json['artistId'] != null) {
      resolvedArtistId = json['artistId'].toString();
    } else if (json['artist'] is Map && json['artist']['id'] != null) {
      resolvedArtistId = json['artist']['id'].toString();
    }

    return AlbumModel(
      id: json['id']?.toString() ?? '0',
      title: json['name'] as String? ?? json['title'] as String? ?? 'Album',
      coverUrl: json['img'] as String? ?? json['coverUrl'] as String?,
      artistId: resolvedArtistId,
      artistName: resolvedArtistName,
      trackCount: (json['trackTotal'] as num?)?.toInt() ??
          (json['trackCount'] as num?)?.toInt() ??
          0,
      releaseDate: parsedDate,
    );
  }
}
