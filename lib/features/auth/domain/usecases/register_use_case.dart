import '../entities/register_request.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Result<void>> call(RegisterRequest request) {
    return repository.register(request);
  }
}
