import 'package:music4_mobile/features/user_profile/domain/models/user_profile_stats.dart';

class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String bio;
  final bool? gender;
  final UserProfileStats stats;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    this.gender,
    required this.stats,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] ?? '').toString(),
      displayName: json['displayName'] as String? ?? 'Người dùng Music4',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      gender: json['gender'] as bool?,
      stats: UserProfileStats(
        followingCount: json['followingCount'] as int? ?? 0,
        playlistCount: json['playlistCount'] as int? ?? 0,
        likedTracksCount: json['likedTracksCount'] as int? ?? 0,
      ),
    );
  }

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    String? bio,
    bool? gender,
    UserProfileStats? stats,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      stats: stats ?? this.stats,
    );
  }
}
