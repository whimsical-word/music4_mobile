import 'package:music4_mobile/features/auth/domain/entities/register_request.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  });
  Future<Result<void>> logout();
  Future<bool> isLoggedIn();
  Future<Result<void>> register(RegisterRequest request);
  Future<Result<void>> forgotPassword({required String email});
  Future<Result<void>> resetPasswordOtp({
    required String email,
    required String otp,
    required String newPassword,
  });
  Future<Result<UserEntity>> loginWithGoogle();
}
