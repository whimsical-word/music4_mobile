class AlbumTrackModel {
  final int id;
  final String name;
  final String? albumName;
  final String? img;
  final int duration;
  final String? filePath;
  final String? previewPath;
  final int viewCount;
  final List<String> artistNames;

  const AlbumTrackModel({
    required this.id,
    required this.name,
    this.albumName,
    this.img,
    this.duration = 0,
    this.filePath,
    this.previewPath,
    this.viewCount = 0,
    this.artistNames = const [],
  });

  factory AlbumTrackModel.fromJson(Map<String, dynamic> json) {
    final List<String> artists = [];
    if (json['artists'] is List) {
      for (final a in json['artists']) {
        if (a is Map<String, dynamic> && a['name'] != null) {
          artists.add(a['name'].toString());
        }
      }
    }

    return AlbumTrackModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? 'Chưa có tên bài hát',
      albumName: json['albumName'] as String?,
      img: json['img'] as String?,
      duration: json['duration'] is int
          ? json['duration'] as int
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      filePath: json['filePath'] as String?,
      previewPath: json['previewPath'] as String?,
      viewCount: json['viewCount'] is int
          ? json['viewCount'] as int
          : int.tryParse(json['viewCount']?.toString() ?? '0') ?? 0,
      artistNames: artists,
    );
  }

  String get artistsDisplayText {
    if (artistNames.isEmpty) return 'Chưa rõ nghệ sĩ';
    return artistNames.join(', ');
  }

  String get formattedDuration {
    if (duration <= 0) return '0:00';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class AlbumDetailModel {
  final int id;
  final String title;
  final String? coverUrl;
  final int? artistId;
  final String? artistName;
  final String? uploadDate;
  final int trackTotal;
  final List<AlbumTrackModel> tracks;

  const AlbumDetailModel({
    required this.id,
    required this.title,
    this.coverUrl,
    this.artistId,
    this.artistName,
    this.uploadDate,
    this.trackTotal = 0,
    this.tracks = const [],
  });

  factory AlbumDetailModel.fromJson(
    Map<String, dynamic> json, {
    List<AlbumTrackModel> tracks = const [],
  }) {
    String? resolvedArtistName;
    int? resolvedArtistId;
    if (json['artist'] is Map<String, dynamic>) {
      resolvedArtistName = json['artist']['name'] as String?;
      resolvedArtistId = json['artist']['id'] as int?;
    } else {
      resolvedArtistName = json['artistName'] as String?;
      resolvedArtistId = json['artistId'] as int?;
    }

    List<AlbumTrackModel> resolvedTracks = tracks;
    if (json['tracks'] is List && (json['tracks'] as List).isNotEmpty) {
      resolvedTracks = (json['tracks'] as List)
          .whereType<Map<String, dynamic>>()
          .map((t) => AlbumTrackModel.fromJson(t))
          .toList();
    }

    return AlbumDetailModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['name'] as String? ?? json['title'] as String? ?? 'Album',
      coverUrl: json['img'] as String? ?? json['coverUrl'] as String?,
      artistId: resolvedArtistId,
      artistName: resolvedArtistName,
      uploadDate: json['uploadDate'] as String?,
      trackTotal: json['trackTotal'] as int? ?? resolvedTracks.length,
      tracks: resolvedTracks,
    );
  }

  int get totalDurationSeconds =>
      tracks.fold<int>(0, (sum, t) => sum + t.duration);

  String get formattedTotalDuration {
    final totalSec = totalDurationSeconds;
    if (totalSec <= 0) return '';
    final minutes = (totalSec / 60).round();
    return '$minutes phút';
  }

  String get releaseYear {
    if (uploadDate == null || uploadDate!.isEmpty) return '';
    try {
      final date = DateTime.parse(uploadDate!);
      return date.year.toString();
    } catch (_) {
      return uploadDate!.split('-').first;
    }
  }

  AlbumDetailModel copyWith({
    int? id,
    String? title,
    String? coverUrl,
    int? artistId,
    String? artistName,
    String? uploadDate,
    int? trackTotal,
    List<AlbumTrackModel>? tracks,
  }) {
    return AlbumDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      artistId: artistId ?? this.artistId,
      artistName: artistName ?? this.artistName,
      uploadDate: uploadDate ?? this.uploadDate,
      trackTotal: trackTotal ?? this.trackTotal,
      tracks: tracks ?? this.tracks,
    );
  }
}
