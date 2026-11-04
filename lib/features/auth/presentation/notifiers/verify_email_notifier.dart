import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/resend_otp_use_case.dart';
import '../../domain/usecases/verify_otp_use_case.dart';
import 'auth_notifier.dart';
import 'verify_email_state.dart';

class VerifyEmailNotifier extends StateNotifier<VerifyEmailState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  Timer? _timer;
  int _countdown = 0;
  int get countdown => _countdown;

  VerifyEmailNotifier({
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(const VerifyEmailInitial());

  void startCooldown([int seconds = 60]) {
    _countdown = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        _countdown--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verify({
    required String email,
    required String otp,
    String? role,
  }) async {
    state = const VerifyEmailLoading();

    final result = await verifyOtpUseCase(
      email: email,
      otp: otp,
      role: role,
    );

    state = switch (result) {
      Success<void>() => const VerifyEmailSuccess(),
      Error<void>(:final failure) => VerifyEmailError(failure.message),
    };
  }

  Future<bool> resend({
    required String email,
    String? role,
  }) async {
    final result = await resendOtpUseCase(
      email: email,
      role: role,
    );

    return switch (result) {
      Success<void>() => true,
      Error<void>() => false,
    };
  }

  void reset() {
    _timer?.cancel();
    _countdown = 0;
    state = const VerifyEmailInitial();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final verifyEmailNotifierProvider =
    StateNotifierProvider<VerifyEmailNotifier, VerifyEmailState>((ref) {
  return VerifyEmailNotifier(
    verifyOtpUseCase: ref.read(verifyOtpUseCaseProvider),
    resendOtpUseCase: ref.read(resendOtpUseCaseProvider),
  );
});
