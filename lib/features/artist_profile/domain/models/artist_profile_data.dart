import 'artist.dart';
import 'track.dart';

class ArtistProfileData {
  final Artist artist;
  final List<Track> popularTracks;
  final bool isFollowing;

  ArtistProfileData({
    required this.artist,
    required this.popularTracks,
    required this.isFollowing,
  });

  ArtistProfileData copyWith({
    Artist? artist,
    List<Track>? popularTracks,
    bool? isFollowing,
  }) {
    return ArtistProfileData(
      artist: artist ?? this.artist,
      popularTracks: popularTracks ?? this.popularTracks,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
