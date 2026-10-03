import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
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
    final authState = ref.read(authNotifierProvider);
    if (authState is! AuthAuthenticated) {
      throw Exception('Chưa đăng nhập');
    }
    final userId = authState.user.id;
    final repo = ref.read(userProfileRepositoryProvider);
    final profile = await repo.getProfile(userId);
    return UserProfileState(profile: profile);
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
    await ref.read(authNotifierProvider.notifier).logout();
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfileState>(
      UserProfileNotifier.new,
    );
