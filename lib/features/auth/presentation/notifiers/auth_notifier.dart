import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/google_sign_in_data_source.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:music4_mobile/core/network/dio_client.dart';

import '../state/auth_state.dart';

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

final googleSignInDataSourceProvider = Provider<GoogleSignInDataSource>((ref) {
  return GoogleSignInDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRemoteRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
    googleSignInDataSource: ref.read(googleSignInDataSourceProvider)
  );
});

final loginWithGoogleUseCaseProvider = Provider<LoginWithGoogleUseCase>((ref) {
  return LoginWithGoogleUseCase(ref.read(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.read(authRepositoryProvider));
});

final resendOtpUseCaseProvider = Provider<ResendOtpUseCase>((ref) {
  return ResendOtpUseCase(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository repository;
  final TokenStorage tokenStorage;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.repository,
    required this.tokenStorage,
    required this.loginWithGoogleUseCase
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
      Error<UserEntity>(:final failure) => switch (failure) {
          RequiresEmailVerificationFailure(
            :final email,
            :final role,
            :final message,
          ) =>
            AuthRequiresVerification(
              email: email,
              role: role,
              message: message,
            ),
          _ => AuthError(failure.message),
        },
    };
  }

  void resetState() {
    state = const AuthUnauthenticated();
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
    } finally {
      await tokenStorage.clearSession();
      state = const AuthUnauthenticated();
    }
  }

  Future<void> continueAsGuest() async {
    await tokenStorage.clearSession();
    state = const AuthUnauthenticated();
  }

  Future<void> updateUser({String? displayName, String? imageUrl}) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;

    final updatedUser = currentState.user.copyWith(
      displayName: displayName ?? currentState.user.displayName,
      imageUrl: imageUrl ?? currentState.user.imageUrl,
    );

    await tokenStorage.saveUser(updatedUser);

    state = AuthAuthenticated(updatedUser);
  }

  Future<void> loginWithGoogle() async {
    if (state is AuthLoading) return; // chống bấm nhiều lần

    state = const AuthLoading();
    final result = await loginWithGoogleUseCase();

    state = switch (result) {
      Success<UserEntity>(:final data) => AuthAuthenticated(data),
      Error<UserEntity>(failure: GoogleSignInCancelledFailure()) => const AuthUnauthenticated(),
      Error<UserEntity>(:final failure) => AuthError(failure.message),
    };
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
    loginWithGoogleUseCase: ref.read(loginWithGoogleUseCaseProvider)
  );
});


