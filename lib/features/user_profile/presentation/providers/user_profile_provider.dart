import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/user_profile/data/datasources/user_profile_remote_data_source.dart';
import 'package:music4_mobile/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:music4_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

import '../../domain/models/user_profile.dart';
import '../state/user_profile_state.dart';

final userProfileRemoteDataSourceProvider =
    Provider<UserProfileRemoteDataSource>((ref) {
      return UserProfileRemoteDataSourceImpl(dioClient: DioClient());
    });
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    ref.read(userProfileRemoteDataSourceProvider),
  );
});

class UserProfileNotifier extends AsyncNotifier<UserProfileState> {
  @override
  Future<UserProfileState> build() async {
    // TODO: Replace with real API call — userRepository.getProfile()
    await Future.delayed(const Duration(milliseconds: 1200));
    return UserProfileState(profile: _mockProfile);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  void toggleEditing() {
    state.whenData(
      (s) => state = AsyncData(s.copyWith(isEditing: !s.isEditing)),
    );
  }

  Future<void> logout() async {
    // TODO: Clear tokens via authRepository.logout()
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 600));
    // Navigation handled by the caller (UserProfileScreen)
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileState>(
      UserProfileNotifier.new,
    );

// ---------------------------------------------------------------------------
// Mock (remove when API is ready)
// ---------------------------------------------------------------------------

const _mockProfile = UserProfile(
  id: 'user-001',
  displayName: 'Lê Minh Nhựt',
  email: 'nhut.ce190737@example.com',
  avatarUrl: 'https://i.pravatar.cc/200?u=CE190737',
  bio: 'Yêu âm nhạc, ghét sự im lặng. 🎧',
  followingCount: 48,
  playlistCount: 12,
  likedTracksCount: 237,
);
