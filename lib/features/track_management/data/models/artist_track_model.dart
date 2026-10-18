import '../../../../core/utils/image_url_helper.dart';

class ArtistTrackItemModel {
  final int id;
  final String name;
  final String? albumName;
  final String? rawImg;
  final int duration;
  final String? filePath;
  final String? previewPath;
  final int viewCount;
  final String? uploadDate;
  final List<String> artistNames;
  final List<int> categoryIds;

  const ArtistTrackItemModel({
    required this.id,
    required this.name,
    this.albumName,
    this.rawImg,
    this.duration = 0,
    this.filePath,
    this.previewPath,
    this.viewCount = 0,
    this.uploadDate,
    this.artistNames = const [],
    this.categoryIds = const [],
  });

  String? get coverUrl => ImageUrlHelper.resolve(rawImg);

  bool get isSingle => albumName == null || albumName == 'Single' || albumName!.isEmpty;

  String get formattedDuration {
    final m = duration ~/ 60;
    final s = duration % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get formattedViews {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  factory ArtistTrackItemModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    final name = json['name']?.toString() ?? 'Chưa đặt tên';
    final albumName = json['albumName']?.toString();
    final img = json['img']?.toString();
    final duration = json['duration'] is int
        ? json['duration'] as int
        : int.tryParse(json['duration']?.toString() ?? '0') ?? 0;
    final filePath = json['filePath']?.toString();
    final previewPath = json['previewPath']?.toString();
    final viewCount = json['viewCount'] is int
        ? json['viewCount'] as int
        : int.tryParse(json['viewCount']?.toString() ?? '0') ?? 0;
    final uploadDate = json['uploadDate']?.toString();

    final artistList = <String>[];
    if (json['artists'] is List) {
      for (final a in json['artists'] as List) {
        if (a is Map && a['name'] != null) {
          artistList.add(a['name'].toString());
        }
      }
    }

    final catList = <int>[];
    if (json['categories'] is List) {
      for (final c in json['categories'] as List) {
        if (c is Map && c['id'] != null) {
          final cid = c['id'] is int ? c['id'] as int : int.tryParse(c['id'].toString());
          if (cid != null) catList.add(cid);
        }
      }
    }

    return ArtistTrackItemModel(
      id: id,
      name: name,
      albumName: albumName,
      rawImg: img,
      duration: duration,
      filePath: filePath,
      previewPath: previewPath,
      viewCount: viewCount,
      uploadDate: uploadDate,
      artistNames: artistList,
      categoryIds: catList,
    );
  }
}
