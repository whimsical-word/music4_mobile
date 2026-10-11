import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';
import 'package:music4_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:music4_mobile/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:music4_mobile/features/user_profile/presentation/screens/user_profile_screen.dart';
import 'package:music4_mobile/features/user_profile/presentation/widgets/user_profile_shimmer.dart';
import 'package:music4_mobile/features/user_profile/presentation/widgets/profile_error_view.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockUserProfileRepository mockRepository;
  late AuthNotifier authNotifier;

  setUp(() {
    mockRepository = MockUserProfileRepository();
    final authRepository = MockAuthRepository();
    authNotifier =
        AuthNotifier(
            loginUseCase: LoginUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
            repository: authRepository,
            tokenStorage: TokenStorage(),
          )
          ..state = const AuthAuthenticated(
            UserEntity(
              id: 1,
              displayName: 'Test User',
              username: 'testuser',
              email: 'test@example.com',
              isArtist: false,
            ),
          );
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockRepository),
        authNotifierProvider.overrideWith((ref) => authNotifier),
      ],
      child: const MaterialApp(home: UserProfileScreen()),
    );
  }

  testWidgets('Hiển thị Shimmer khi đang loading', (tester) async {
    // Arrange: Cố tình không trả về kết quả ngay để state kẹt ở Loading
    when(() => mockRepository.getProfile(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return const UserProfile(
        id: '1',
        displayName: 'Test',
        email: '',
        avatarUrl: '',
        bio: '',
        followingCount: 0,
        playlistCount: 0,
        likedTracksCount: 0,
      );
    });

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert: Shimmer phải hiện ra ngay lập tức
    expect(find.byType(UserProfileShimmer), findsOneWidget);

    // Dọn dẹp timer
    await tester.pumpAndSettle();
  });

  testWidgets('Hiển thị ErrorView khi lỗi xảy ra', (tester) async {
    // Arrange
    when(() => mockRepository.getProfile(any()))
        .thenThrow(Exception('Lỗi mạng'));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Đợi AsyncValue.guard bắt lỗi

    // Assert
    expect(find.byType(ProfileErrorView), findsOneWidget);
    expect(find.textContaining('Lỗi mạng'), findsOneWidget);
  });

  testWidgets('Hiển thị dữ liệu người dùng khi fetch thành công', (
    tester,
  ) async {
    // Arrange
    const mockProfile = UserProfile(
      id: '1',
      displayName: 'Lê Minh Nhựt',
      email: 'nhut.ce190737@example.com',
      avatarUrl: '',
      bio: 'Yêu âm nhạc',
      followingCount: 10,
      playlistCount: 5,
      likedTracksCount: 100,
    );
    when(() => mockRepository.getProfile(any()))
        .thenAnswer((_) async => mockProfile);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Lê Minh Nhựt', skipOffstage: false), findsOneWidget);
    expect(
      find.text('nhut.ce190737@example.com', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Yêu âm nhạc', skipOffstage: false), findsOneWidget);

    // Check một phần tử menu đầu tiên
    expect(find.text('Bài hát yêu thích', skipOffstage: false), findsOneWidget);
  });
}
