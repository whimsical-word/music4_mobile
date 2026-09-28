class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String bio;
  final int followingCount;
  final int playlistCount;
  final int likedTracksCount;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    required this.followingCount,
    required this.playlistCount,
    required this.likedTracksCount,
  });
}
