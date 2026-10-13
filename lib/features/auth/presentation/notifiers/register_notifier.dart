import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/register_request.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/register_use_case.dart';
import 'auth_notifier.dart';
import 'register_state.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterNotifier({required this.registerUseCase})
      : super(const RegisterInitial());

  Future<void> register(RegisterRequest request) async {
    state = const RegisterLoading();

    final result = await registerUseCase(request);

    state = switch (result) {
      Success<void>() => const RegisterSuccess(),
      Error<void>(:final failure) => RegisterError(failure.message),
    };
  }

  void reset() {
    state = const RegisterInitial();
  }
}

final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(
    registerUseCase: ref.read(registerUseCaseProvider),
  );
});
