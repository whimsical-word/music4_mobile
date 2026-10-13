import 'package:dio/dio.dart';
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
    bool? gender,
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
    bool? gender,
    String? avatarUrl,
  }) async {
    dynamic requestData;

    if (avatarUrl != null &&
        !avatarUrl.startsWith('http') &&
        avatarUrl.isNotEmpty) {
      requestData = FormData.fromMap({
        'name': ?displayName,
        'gender': ?gender,
        'img': await MultipartFile.fromFile(
          avatarUrl,
          filename: avatarUrl.split('/').last,
        ),
      });
    } else {
      requestData = FormData.fromMap({'name': ?displayName, 'gender': ?gender});
    }

    final response = await dioClient.dio.patch(
      '${ApiEndpoints.userProfile}/$userId',
      data: requestData,
    );
    final responseModel = UserProfileResponse.fromJson(response.data);
    return responseModel.toDomain();
  }
}
