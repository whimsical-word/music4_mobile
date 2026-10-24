import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/forgot_password_state.dart';

final forgotPasswordNotifierProvider =
StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier(
    repository: ref.read(authRepositoryProvider),
  );
});


class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthRepository repository;

  ForgotPasswordNotifier({required this.repository})
      : super(const ForgotPasswordInitial());

  Future<void> sendOtp(String email) async {
    state = const ForgotPasswordLoading();

    final result = await repository.forgotPassword(email: email);

    state = switch (result) {
      Success<void>() => ForgotPasswordOtpSent(email),
      Error<void>(:final failure) => ForgotPasswordError(failure.message),
    };
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const ForgotPasswordLoading();

    final result = await repository.resetPasswordOtp(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    state = switch (result) {
      Success<void>() => const ForgotPasswordResetSuccess(),
      Error<void>(:final failure) => ForgotPasswordError(failure.message),
    };
  }

  void clearState() {
    state = const ForgotPasswordInitial();
  }
}