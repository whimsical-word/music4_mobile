import 'package:dio/dio.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/auth/domain/entities/register_request.dart';

import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<void> logout(String refreshToken);
  Future<void> register(RegisterRequest request);

  Future<void> forgotPassword({required String email});
  Future<void> resetPasswordOtp({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<AuthResponseModel> loginWithGoogle(String idToken);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<bool> checkCanChangePassword();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await dioClient.dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Đăng nhập không thành công';
      throw Exception(message);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await dioClient.dio.post(
        ApiEndpoints.logout,
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Đăng xuất không thành công';
      throw Exception(message);
    }
  }

  @override
  Future<void> register(RegisterRequest request) async {
    try {
      final formData = FormData.fromMap({
        'name': request.name,
        'email': request.email,
        'username': request.username,
        'password': request.password,
        if (request.img != null)
          'img': await MultipartFile.fromFile(
            request.img!.path,
            filename: request.img!.path.split('/').last,
          ),
      });

      await dioClient.dio.post(
        ApiEndpoints.register,
        queryParameters: {'role': request.role},
        data: formData,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ??
          e.response?.data?['error'] ??
          'Đăng ký không thành công';
      throw Exception(message);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await dioClient.dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email, 'verificationMethod': 'OTP'},
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Gửi OTP thất bại';
      throw Exception(message);
    }
  }

  @override
  Future<void> resetPasswordOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await dioClient.dio.post(
        ApiEndpoints.resetPasswordOtp,
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Đặt lại mật khẩu thất bại';
      throw Exception(message);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await dioClient.dio.post(ApiEndpoints.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });
  } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Đổi mật khẩu thất bại';
      throw Exception(message);
    }

  }

  @override
  Future<bool> checkCanChangePassword() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.passwordStatus);
      return response.data['canChangePassword'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String idToken) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.googleLogin,
      data: {'idToken': idToken},
    );
    return AuthResponseModel.fromJson(response.data);
  }
}
