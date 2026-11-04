import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Result<void>> call({
    required String email,
    required String otp,
    String? role,
  }) {
    return repository.verifyOtp(email: email, otp: otp, role: role);
  }
}
