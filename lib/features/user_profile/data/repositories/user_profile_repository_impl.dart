import 'package:dio/dio.dart';
import 'package:music4_mobile/features/favorites/data/repositories/favorites_repository.dart';
import 'package:music4_mobile/features/playlist/data/repositories/playlist_repository.dart';
import 'package:music4_mobile/features/user_profile/data/datasources/user_profile_remote_data_source.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile_stats.dart';
import 'package:music4_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  final FavoritesRepository favoritesRepository;
  final PlaylistRepository playlistRepository;

  UserProfileRepositoryImpl(
    this.remoteDataSource, {
    required this.favoritesRepository,
    required this.playlistRepository,
  });

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

  @override
  Future<UserProfileStats> getProfileStats(int userId) async {
    try {
      final results = await Future.wait([
        favoritesRepository.getMyFavorites(),
        playlistRepository.getMyPlaylists(),
        remoteDataSource.getUserFollows(userId),
      ]);
      final followingCount = results[2].length;
      final playlistCount = results[1].length;
      final likedTracksCount = results[0].length;
      return UserProfileStats(
        followingCount: followingCount,
        playlistCount: playlistCount,
        likedTracksCount: likedTracksCount,
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Không thể tải thống kê hồ sơ',
      );
    }
  }
}
