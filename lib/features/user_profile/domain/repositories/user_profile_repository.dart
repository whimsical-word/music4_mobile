import '../models/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<UserProfile> getProfile(int userId);

  Future<UserProfile> updateProfile({
    required int userId,
    String? displayName,
    bool? gender,
    String? avatarUrl,
  });
}
