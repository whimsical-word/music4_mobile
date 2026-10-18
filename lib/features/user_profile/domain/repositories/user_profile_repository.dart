import 'package:music4_mobile/features/user_profile/domain/models/user_profile_stats.dart';

import '../models/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<UserProfile> getProfile(int userId);

  Future<UserProfile> updateProfile({
    required int userId,
    String? displayName,
    bool? gender,
    String? avatarUrl,
  });

  Future<UserProfileStats> getProfileStats(int userId);
}
