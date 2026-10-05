import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';
import 'package:music4_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:music4_mobile/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:music4_mobile/features/user_profile/presentation/state/user_profile_state.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

// A generic Listener class used to listen to Riverpod provider state changes
class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const AsyncLoading<UserProfileState>());
  });

  late MockUserProfileRepository mockRepository;
  late ProviderContainer container;

  final mockProfile = const UserProfile(
    id: '1',
    displayName: 'Test User',
    email: 'test@example.com',
    avatarUrl: '',
    bio: 'Test Bio',
    followingCount: 10,
    playlistCount: 5,
    likedTracksCount: 20,
  );

  setUp(() {
    mockRepository = MockUserProfileRepository();
    container = ProviderContainer(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build() emits AsyncData with UserProfile on success', () async {
    // Arrange
    when(() => mockRepository.getProfile(any()))
        .thenAnswer((_) async => mockProfile);

    // Act
    final future = container.read(userProfileProvider.future);
    
    // Assert - initially loading
    expect(container.read(userProfileProvider), const AsyncLoading<UserProfileState>());
    
    // Wait for resolution
    final state = await future;
    
    // Assert - finally data
    expect(state.profile, mockProfile);
    expect(container.read(userProfileProvider).value?.profile, mockProfile);
  });

  test('toggleEditing() toggles isEditing state', () async {
    // Arrange
    when(() => mockRepository.getProfile(any()))
        .thenAnswer((_) async => mockProfile);
        
    // Chờ state load xong
    await container.read(userProfileProvider.future);

    // Act
    container.read(userProfileProvider.notifier).toggleEditing();

    // Assert
    final state = container.read(userProfileProvider).value!;
    expect(state.isEditing, true);

    // Act 2
    container.read(userProfileProvider.notifier).toggleEditing();

    // Assert 2
    final state2 = container.read(userProfileProvider).value!;
    expect(state2.isEditing, false);
  });
}
