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

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(tokenStorage: ref.read(tokenStorageProvider));
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dioClient: ref.read(dioClientProvider));
});

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

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository repository;
  final TokenStorage tokenStorage;

  AuthNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.repository,
    required this.tokenStorage,
  }) : super(const AuthInitial());

  Future<void> checkSession() async {
    final isLoggedIn = await repository.isLoggedIn();
    if (isLoggedIn) {
      final cachedUser = await tokenStorage.getUser();
      if (cachedUser != null) {
        state = AuthAuthenticated(cachedUser);
        return;
      }
    }
    state = const AuthUnauthenticated();
  }

  Future<void> login(String username, String password) async {
    state = const AuthLoading();

    final result = await loginUseCase(username: username, password: password);

    state = switch (result) {
      Success<UserEntity>(:final data) => AuthAuthenticated(data),
      Error<UserEntity>(:final failure) => AuthError(failure.message),
    };
  }

  Future<void> logout() async {
    await logoutUseCase();
    state = const AuthUnauthenticated();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    repository: ref.read(authRepositoryProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
});
