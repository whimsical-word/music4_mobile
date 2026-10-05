import 'package:dio/dio.dart';
import 'package:music4_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRemoteRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final authData = await remoteDataSource.login(username, password);

      await tokenStorage.saveTokens(
        accessToken: authData.accessToken,
        refreshToken: authData.refreshToken,
      );
      final entity = authData.toEntity();
      await tokenStorage.saveUser(entity);

      return Success(entity);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return const Error(InvalidCredentialsFailure());
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Error(NetworkFailure());
      }
      return Error(ServerFailure(e.message ?? 'Lỗi không xác định'));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    await tokenStorage.clearSession();
    return const Success(null);
  }

  @override
  Future<bool> isLoggedIn() => tokenStorage.hasValidSession();
}
