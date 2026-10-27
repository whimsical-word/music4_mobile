import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Result<void>> call({
    required String email,
    String? role,
  }) {
    return repository.resendVerificationOtp(email: email, role: role);
  }
}
