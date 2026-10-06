class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String bio;
  final bool? gender;
  final int followingCount;
  final int playlistCount;
  final int likedTracksCount;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    this.gender,
    required this.followingCount,
    required this.playlistCount,
    required this.likedTracksCount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] ?? '').toString(),
      displayName: json['displayName'] as String? ?? 'Người dùng Music4',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      gender: json['gender'] as bool?,
      followingCount: json['followingCount'] as int? ?? 0,
      playlistCount: json['playlistCount'] as int? ?? 0,
      likedTracksCount: json['likedTracksCount'] as int? ?? 0,
    );
  }
}
