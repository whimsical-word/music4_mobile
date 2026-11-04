import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/change_password_state.dart';

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.read(authRepositoryProvider));
});

final changePasswordNotifierProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
      return ChangePasswordNotifier(
        useCase: ref.read(changePasswordUseCaseProvider),
      );
    });

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final ChangePasswordUseCase useCase;

  ChangePasswordNotifier({required this.useCase})
    : super(const ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const ChangePasswordLoading();
    final result = await useCase.call(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    switch (result) {
      case Success():
        state = const ChangePasswordSuccess();
      case Error(:final failure):
        state = ChangePasswordError(failure.message);
    }
  }

  void reset() => state = const ChangePasswordInitial();
}
