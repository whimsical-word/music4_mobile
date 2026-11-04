import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/admin/data/models/vector_sync_status.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_sync_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_sync_provider.dart';
import 'package:music4_mobile/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:music4_mobile/features/admin/presentation/widgets/vector_sync_card.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/auth_state.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(AuthState initial)
      : super(
          loginUseCase: _MockLoginUseCase(),
          logoutUseCase: _MockLogoutUseCase(),
          repository: _MockAuthRepository(),
          tokenStorage: _MockTokenStorage(),
          loginWithGoogleUseCase: _MockLoginWithGoogleUseCase(),
        ) {
    state = initial;
  }
}

class _FakeRepository extends AdminSyncRepository {
  _FakeRepository() : super(DioClient());

  @override
  Future<VectorSyncStatus> getStatus() async => const VectorSyncStatus(
    sqlTracks: 5,
    indexedVectors: 5,
    inSync: true,
    syncRunning: false,
    lastFullSync: null,
  );
}

void main() {
  const admin = UserEntity(
    id: 1,
    displayName: 'Admin',
    username: 'admin',
    isArtist: false,
    isAdmin: true,
  );
  const listener = UserEntity(
    id: 2,
    displayName: 'Listener',
    username: 'listener',
    isArtist: false,
  );
  const artist = UserEntity(
    id: 3,
    displayName: 'Artist',
    username: 'artist',
    isArtist: true,
  );

  Widget buildApp(AuthState auth) {
    return ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
        adminVectorSyncProvider.overrideWith(
          (ref) => AdminVectorSyncNotifier(_FakeRepository())..load(),
        ),
      ],
      child: const MaterialApp(home: AdminDashboardScreen()),
    );
  }

  group('[CE190284] AdminDashboardScreen', () {
    testWidgets('an admin sees the vector sync card once the dashboard has loaded', (tester) async {
      await tester.pumpWidget(buildApp(const AuthAuthenticated(admin)));
      // The dashboard shows a short placeholder loading before its content.
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();

      expect(find.text('Hệ thống gợi ý'), findsOneWidget);
      expect(find.byType(VectorSyncCard), findsOneWidget);
      expect(find.text('Chỉ dành cho Quản trị viên'), findsNothing);
    });

    testWidgets('a listener is blocked', (tester) async {
      await tester.pumpWidget(buildApp(const AuthAuthenticated(listener)));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Chỉ dành cho Quản trị viên'), findsOneWidget);
      expect(find.text('Quay lại'), findsOneWidget);
      expect(find.byType(VectorSyncCard), findsNothing);
    });

    testWidgets('an artist is blocked', (tester) async {
      await tester.pumpWidget(buildApp(const AuthAuthenticated(artist)));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Chỉ dành cho Quản trị viên'), findsOneWidget);
      expect(find.byType(VectorSyncCard), findsNothing);
    });

    testWidgets('a guest is blocked', (tester) async {
      await tester.pumpWidget(buildApp(const AuthInitial()));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('Chỉ dành cho Quản trị viên'), findsOneWidget);
      expect(find.byType(VectorSyncCard), findsNothing);
    });
  });
}
