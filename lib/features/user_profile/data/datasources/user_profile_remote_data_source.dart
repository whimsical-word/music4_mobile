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
      // Local file -> Use FormData
      requestData = FormData.fromMap({
        if (displayName != null) 'name': displayName,
        if (gender != null) 'gender': gender,
        'img': await MultipartFile.fromFile(
          avatarUrl,
          filename: avatarUrl.split('/').last,
        ),
      });
    } else {
      // No file -> JSON, maybe FormData if API strictly requires it?
      // Usually FormData can also be sent without files. Let's stick to FormData to be safe since API says multipart/form-data
      requestData = FormData.fromMap({
        if (displayName != null) 'name': displayName,
        if (gender != null) 'gender': gender,
      });
    }

    final response = await dioClient.dio.patch(
      '${ApiEndpoints.userProfile}/$userId',
      data: requestData,
    );
    final responseModel = UserProfileResponse.fromJson(response.data);
    return responseModel.toDomain();
  }
}
