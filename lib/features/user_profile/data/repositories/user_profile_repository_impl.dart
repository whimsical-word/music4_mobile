import 'package:dio/dio.dart';
import 'package:music4_mobile/features/user_profile/data/datasources/user_profile_remote_data_source.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';
import 'package:music4_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfile> getProfile(int userId) async {
    try {
      return await remoteDataSource.getProfile(userId);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Không thể tải hồ sơ');
    }
  }

  @override
  Future<UserProfile> updateProfile({
    required int userId,
    String? displayName,
    String? avatarUrl,
    bool? gender,
  }) async {
    try {
      return await remoteDataSource.updateProfile(
        userId: userId,
        displayName: displayName,
        avatarUrl: avatarUrl,
        gender: gender,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Không thể cập nhật hồ sơ',
      );
    }
  }
}
