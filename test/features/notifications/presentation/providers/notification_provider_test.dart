import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/notifications/data/models/notification_model.dart';
import 'package:music4_mobile/features/notifications/data/repositories/notification_repository.dart';
import 'package:music4_mobile/features/notifications/presentation/providers/notification_provider.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
  });

  // Hàm Helper để bọc và override ProviderContainer dễ dàng
  ProviderContainer makeProviderContainer(MockNotificationRepository repository) {
    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  final mockNotifications = [
    NotificationModel(
      id: '1',
      title: 'Thông báo 1',
      message: 'Test Message 1',
      isRead: false,
      createdAt: DateTime(2026, 1, 1),
    ),
    NotificationModel(
      id: '2',
      title: 'Thông báo 2',
      message: 'Test Message 2',
      isRead: true,
      createdAt: DateTime(2026, 1, 2),
    ),
  ];

  group('NotificationNotifier Unit Tests', () {
    test('State ban đầu phải là AsyncLoading', () {
      // Arrange
      // Dù hàm getNotifications có được gọi hay không, state khi vừa khởi tạo phải là Loading
      when(() => mockRepository.getNotifications(any()))
          .thenAnswer((_) async => mockNotifications);
          
      final container = makeProviderContainer(mockRepository);

      // Act
      final initialState = container.read(notificationProvider);

      // Assert
      expect(initialState, isA<AsyncLoading<List<NotificationModel>>>());
    });

    test('Fetch API thành công -> Emit trạng thái AsyncData', () async {
      // Arrange
      when(() => mockRepository.getNotifications(any()))
          .thenAnswer((_) async => mockNotifications);
      final container = makeProviderContainer(mockRepository);

      // Act: Chờ Provider gọi xong API (do fetchNotifications được trigger từ lúc init)
      final notifier = container.read(notificationProvider.notifier);
      await notifier.fetchNotifications();

      // Assert
      final state = container.read(notificationProvider);
      expect(state, isA<AsyncData<List<NotificationModel>>>());
      expect(state.value, equals(mockNotifications));
      verify(() => mockRepository.getNotifications('1')).called(2); // 1 lần lúc init, 1 lần gọi thủ công
    });

    test('Fetch API thất bại -> Emit trạng thái AsyncError', () async {
      // Arrange
      final exception = Exception('Lỗi mạng giả lập');
      when(() => mockRepository.getNotifications(any())).thenThrow(exception);
      final container = makeProviderContainer(mockRepository);

      // Act
      final notifier = container.read(notificationProvider.notifier);
      await notifier.fetchNotifications();

      // Assert
      final state = container.read(notificationProvider);
      expect(state, isA<AsyncError<List<NotificationModel>>>());
      expect(state.hasError, true);
    });
  });
}
