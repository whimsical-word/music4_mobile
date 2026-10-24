import 'package:dio/dio.dart';
import 'package:music4_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/google_sign_in_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:music4_mobile/features/auth/domain/entities/register_request.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;
  final GoogleSignInDataSource googleSignInDataSource;

  AuthRemoteRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage, required this.googleSignInDataSource,
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
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          await remoteDataSource.logout(refreshToken);
        } catch (_) {
          // Bỏ qua lỗi backend khi logout (ví dụ: token hết hạn hoặc mất mạng),
          // client vẫn bắt buộc phải xóa session local
        }
      }
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    } finally {
      await tokenStorage.clearSession();
      await googleSignInDataSource.signOut();
    }
  }

  @override
  Future<bool> isLoggedIn() => tokenStorage.hasValidSession();

  @override
  Future<Result<void>> register(RegisterRequest request) async {
    try {
      await remoteDataSource.register(request);
      return const Success(null);
    } catch (e) {
      return Error(
        ServerFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<void>> resetPasswordOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPasswordOtp(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<void>> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    try {
      await remoteDataSource.changePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
      return const Success(null);
    } on Exception catch (e) {
      return Error(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }

  }

  @override
  Future<Result<bool>> checkCanChangePassword() async {
    try {
      final canChange = await remoteDataSource.checkCanChangePassword();
      return Success(canChange);
    } on Exception catch (e) {
      return Error(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Result<UserEntity>> loginWithGoogle() async {
    try {
      final idToken = await googleSignInDataSource.getIdToken();
      if (idToken == null) return const Error(GoogleSignInCancelledFailure());
      final authData = await remoteDataSource.loginWithGoogle(idToken);
      return Success(await _persistSession(authData));
    } on DioException catch (e) {
    await googleSignInDataSource.signOut(); // để lần sau được chọn lại tài khoản
    return Error(_mapGoogleFailure(e));
    } catch (_) {
    await googleSignInDataSource.signOut();
    return const Error(ServerFailure('Đăng nhập Google không thành công'));
    }
  }

  Future<UserEntity> _persistSession(AuthResponseModel authData) async {
    await tokenStorage.saveTokens(
      accessToken: authData.accessToken,
      refreshToken: authData.refreshToken,
    );
    final entity = authData.toEntity();
    await tokenStorage.saveUser(entity);
    return entity;
  }
  Failure _mapGoogleFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    final data = e.response?.data;
    final message = data is Map ? data['message'] as String? : null;
    return ServerFailure(message ?? 'Đăng nhập Google không thành công');
  }

}
