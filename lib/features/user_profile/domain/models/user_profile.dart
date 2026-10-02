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
    this.avatarUrl = '',
    this.bio = '',
    this.followingCount = 0,
    this.playlistCount = 0,
    this.likedTracksCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      followingCount: json['followingCount'] as int? ?? 0,
      playlistCount: json['playlistCount'] as int? ?? 0,
      likedTracksCount: json['likedTracksCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'followingCount': followingCount,
      'playlistCount': playlistCount,
      'likedTracksCount': likedTracksCount,
    };
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    String? bio,
    int? followingCount,
    int? playlistCount,
    int? likedTracksCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followingCount: followingCount ?? this.followingCount,
      playlistCount: playlistCount ?? this.playlistCount,
      likedTracksCount: likedTracksCount ?? this.likedTracksCount,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserProfile &&
            other.id == id &&
            other.displayName == displayName &&
            other.email == email &&
            other.avatarUrl == avatarUrl &&
            other.bio == bio &&
            other.followingCount == followingCount &&
            other.playlistCount == playlistCount &&
            other.likedTracksCount == likedTracksCount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      displayName,
      email,
      avatarUrl,
      bio,
      followingCount,
      playlistCount,
      likedTracksCount,
    );
  }

  @override
  String toString() {
    return 'UserProfile('
        'id: $id, '
        'displayName: $displayName, '
        'email: $email, '
        'avatarUrl: $avatarUrl, '
        'bio: $bio, '
        'followingCount: $followingCount, '
        'playlistCount: $playlistCount, '
        'likedTracksCount: $likedTracksCount'
        ')';
  }
}
