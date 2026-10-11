import 'package:dio/dio.dart';
import 'package:music4_mobile/core/network/dio_client.dart';

import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<void> logout(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await dioClient.dio.post(
        '/api/auth/login',
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
        '/api/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Đăng xuất không thành công';
      throw Exception(message);
    }
  }
}
