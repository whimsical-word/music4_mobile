import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  });
  Future<Result<void>> logout();
  Future<bool> isLoggedIn();
}
