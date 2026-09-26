class HistoryItem {
  final String id;
  final String trackId;
  final String trackTitle;
  final String artistName;
  final String artworkUrl;
  final DateTime playedAt;

  const HistoryItem({
    required this.id,
    required this.trackId,
    required this.trackTitle,
    required this.artistName,
    required this.artworkUrl,
    required this.playedAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      trackId: json['trackId'] as String,
      trackTitle: json['trackTitle'] as String,
      artistName: json['artistName'] as String,
      artworkUrl: json['artworkUrl'] as String,
      playedAt: DateTime.parse(json['playedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trackId': trackId,
      'trackTitle': trackTitle,
      'artistName': artistName,
      'artworkUrl': artworkUrl,
      'playedAt': playedAt.toIso8601String(),
    };
  }
}
