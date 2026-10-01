import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Result<UserEntity>> call({
    required String username,
    required String password,
  }) {
    final normalizedUsername = username.trim().toLowerCase();
    return repository.login(username: normalizedUsername, password: password);
  }
}
