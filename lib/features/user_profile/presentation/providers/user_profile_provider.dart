import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/user_profile_remote_data_source.dart';
import '../../data/repositories/user_profile_repository_impl.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../state/user_profile_state.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final userProfileRemoteDataSourceProvider =
    Provider<UserProfileRemoteDataSource>((ref) {
      return UserProfileRemoteDataSourceImpl(
        dioClient: ref.read(dioClientProvider),
      );
    });

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepositoryImpl(
    ref.read(userProfileRemoteDataSourceProvider),
  );
});

class UserProfileNotifier extends AsyncNotifier<UserProfileState> {
  late UserProfileRepository _repository;

  @override
  Future<UserProfileState> build() async {
    _repository = ref.read(userProfileRepositoryProvider);
    
    // BẮT BUỘC DÙNG WATCH: Để khi authState thay đổi (chuyển acc khác),
    // Provider này sẽ tự động chạy lại (rebuild) và tải data mới.
    final authState = ref.watch(authNotifierProvider);
    
    int userId = 1; // Fallback
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }

    return _fetchProfile(userId);
  }

  Future<UserProfileState> _fetchProfile(int userId) async {
    final profile = await _repository.getProfile(userId);
    return UserProfileState(profile: profile);
  }

  Future<void> retry() async {
    state = const AsyncLoading();
    
    // Dùng read trong hàm async (click event)
    final authState = ref.read(authNotifierProvider);
    int userId = 1;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }
    
    state = await AsyncValue.guard(() => _fetchProfile(userId));
  }

  void toggleEditing() {
    state.whenData(
      (s) => state = AsyncData(s.copyWith(isEditing: !s.isEditing)),
    );
  }

  Future<void> updateProfile({
    String? displayName,
    bool? gender,
    String? avatarFilePath,
  }) async {
    final authState = ref.read(authNotifierProvider);
    if (authState is! AuthAuthenticated) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedProfile = await _repository.updateProfile(
        userId: authState.user.id,
        displayName: displayName,
        gender: gender,
        avatarUrl: avatarFilePath,
      );
      return UserProfileState(profile: updatedProfile);
    });
  }

}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileState>(
      UserProfileNotifier.new,
    );
