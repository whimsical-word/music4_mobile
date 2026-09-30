import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'auth_state.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PROVIDERS — khai báo "cách tạo" từng dependency (DI container của Riverpod)
// Widget hoặc Notifier dùng ref.read / ref.watch để lấy instance.
// ─────────────────────────────────────────────────────────────────────────────

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dioClient: ref.read(dioClientProvider));
});

/// AuthRepository — cung cấp interface; widget/notifier không biết impl nào đứng sau.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRemoteRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

// ─────────────────────────────────────────────────────────────────────────────
// NOTIFIER — quản lý AuthState, gọi UseCase, không biết gì về UI hay Dio
// ─────────────────────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _repository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _repository = repository,
        super(const AuthInitial());

  Future<void> checkSession() async {
    final isLoggedIn = await _repository.isLoggedIn();
    if (!isLoggedIn) {
      state = const AuthUnauthenticated();
    }
    // Nếu có session thì giữ AuthInitial — router sẽ redirect khi cần
  }

  Future<void> login(String username, String password) async {
    state = const AuthLoading();

    final result = await _loginUseCase(
      username: username,
      password: password,
    );

    // Pattern matching trên sealed class Result<T>
    state = switch (result) {
      Success<UserEntity>(:final data) => AuthAuthenticated(data),
      Error<UserEntity>(:final failure) => AuthError(failure.message),
    };
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = const AuthUnauthenticated();
  }
}

/// Provider cho AuthNotifier — đây là provider DUY NHẤT mà LoginScreen cần watch.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    repository: ref.read(authRepositoryProvider),
  );
});
