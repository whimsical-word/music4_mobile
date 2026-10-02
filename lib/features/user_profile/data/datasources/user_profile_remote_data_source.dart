import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/user_profile/data/models/user_profile_response.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfile> getProfile(int userId);
  Future<UserProfile> updateProfile({
    required int userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final DioClient dioClient;

  UserProfileRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserProfile> getProfile(int userId) async {
    final response = await dioClient.dio.get(
      '${ApiEndpoints.userProfile}/$userId',
    );
    final responseModel = UserProfileResponse.fromJson(response.data);
    return responseModel.toDomain();
  }

  @override
  Future<UserProfile> updateProfile({
    required int userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (displayName != null) body['name'] = displayName;
    if (bio != null) body['bio'] = bio;
    final response = await dioClient.dio.patch(
      '${ApiEndpoints.userProfile}/$userId',
      data: body,
    );
    final responseModel = UserProfileResponse.fromJson(response.data);
    return responseModel.toDomain();
  }
}
