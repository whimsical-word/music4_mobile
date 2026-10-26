import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/notifications/data/models/notification_model.dart';
import 'package:music4_mobile/features/notifications/data/repositories/notification_repository.dart';
import 'package:music4_mobile/features/notifications/data/services/notification_sse_service.dart';
import 'package:music4_mobile/features/notifications/presentation/providers/notification_provider.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockSseService extends Mock implements NotificationSseService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}

void main() {
  late MockNotificationRepository repository;
  late MockSseService sse;
  late MockTokenStorage tokenStorage;
  late MockAuthRepository authRepository;
  late StreamController<NotificationSseEvent> sseController;

  final unread = NotificationModel(
    id: 1,
    trackId: 10,
    trackName: 'Chạy Ngay Đi',
    artistName: 'Sơn Tùng',
    content: 'Nghệ sĩ Sơn Tùng vừa phát hành bài hát mới',
    createdAt: DateTime(2026, 1, 1),
  );
  final read = NotificationModel(
    id: 2,
    albumId: 5,
    content: 'Album mới',
    isRead: true,
    createdAt: DateTime(2026, 1, 2),
  );
  const user = UserEntity(
    id: 9,
    displayName: 'NTQ',
    username: 'wordy',
    email: 'q@fpt.edu.vn',
    isArtist: false,
  );

  setUpAll(() => registerFallbackValue(0));

  setUp(() {
    repository = MockNotificationRepository();
    sse = MockSseService();
    tokenStorage = MockTokenStorage();
    authRepository = MockAuthRepository();
    sseController = StreamController<NotificationSseEvent>.broadcast();
    addTearDown(sseController.close);

    when(() => sse.subscribe(any())).thenAnswer((_) => sseController.stream);
    when(
      () => repository.getNotifications(any()),
    ).thenAnswer((_) async => [unread, read]);
    when(() => authRepository.isLoggedIn()).thenAnswer((_) async => true);
    when(() => tokenStorage.getUser()).thenAnswer((_) async => user);
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(repository),
        notificationSseServiceProvider.overrideWithValue(sse),
        authNotifierProvider.overrideWith(
          (ref) => AuthNotifier(
            loginUseCase: MockLoginUseCase(),
            logoutUseCase: MockLogoutUseCase(),
            repository: authRepository,
            tokenStorage: tokenStorage,
            loginWithGoogleUseCase: MockLoginWithGoogleUseCase(),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(notificationProvider, (_, _) {});
    return container;
  }

  Future<ProviderContainer> loggedInContainer() async {
    final container = makeContainer();
    await container.read(authNotifierProvider.notifier).checkSession();
    await container.read(notificationProvider.future);
    return container;
  }

  test('Chưa đăng nhập -> danh sách rỗng, không gọi API/SSE', () async {
    final container = makeContainer();

    final list = await container.read(notificationProvider.future);

    expect(list, isEmpty);
    verifyNever(() => repository.getNotifications(any()));
    verifyNever(() => sse.subscribe(any()));
  });

  test('Đăng nhập -> lấy userId thật (9), fetch và mở SSE', () async {
    final container = await loggedInContainer();

    expect(container.read(notificationProvider).value, [unread, read]);
    verify(() => repository.getNotifications(9)).called(1);
    verify(() => sse.subscribe(9)).called(1);
  });

  test('SSE đẩy thông báo mới -> prepend lên đầu, bỏ trùng id', () async {
    final container = await loggedInContainer();
    final fresh = unread.copyWith(id: 3, trackId: 11);

    sseController.add(NotificationReceivedEvent(fresh));
    sseController.add(NotificationReceivedEvent(fresh)); // trùng id
    await Future<void>.delayed(Duration.zero);

    final list = container.read(notificationProvider).value!;
    expect(list.map((n) => n.id), [3, 1, 2]);
    expect(container.read(unreadNotificationCountProvider), 2);
  });

  test('markAsRead: cập nhật isRead ngay và gọi API đúng 1 lần', () async {
    final container = await loggedInContainer();
    final notifier = container.read(notificationProvider.notifier);
    when(() => repository.markAsRead(1)).thenAnswer((_) async {});

    expect(await notifier.markAsRead(1), isTrue);
    expect(container.read(notificationProvider).value!.first.isRead, isTrue);

    // Thông báo đã đọc sẵn -> không gọi API nữa.
    expect(await notifier.markAsRead(2), isTrue);
    verify(() => repository.markAsRead(1)).called(1);
    verifyNever(() => repository.markAsRead(2));
  });

  test('markAsRead lỗi API -> trả false và rollback isRead', () async {
    final container = await loggedInContainer();
    when(() => repository.markAsRead(1)).thenThrow(Exception('lỗi mạng'));

    final ok = await container.read(notificationProvider.notifier).markAsRead(1);

    expect(ok, isFalse);
    expect(container.read(notificationProvider).value!.first.isRead, isFalse);
  });

  test('delete: xóa ngay, lỗi API thì khôi phục đúng vị trí ban đầu', () async {
    final third = read.copyWith(id: 3, content: 'Thông báo 3');
    when(
      () => repository.getNotifications(any()),
    ).thenAnswer((_) async => [unread, read, third]);

    final container = await loggedInContainer();
    final notifier = container.read(notificationProvider.notifier);

    // Xóa item ở giữa (id: 2, index: 1 trong [1, 2, 3]) nhưng API thất bại:
    // Rollback phải chèn lại đúng vị trí index 1 -> thứ tự giữ nguyên [1, 2, 3] (không bị đẩy lên đầu [2, 1, 3])
    when(() => repository.deleteNotification(2)).thenThrow(Exception('x'));
    final failed = await notifier.delete(2);
    expect(failed, isFalse);
    expect(container.read(notificationProvider).value!.map((n) => n.id), [
      1,
      2,
      3,
    ]);

    // Xóa thành công item ở giữa -> danh sách còn [1, 3]
    when(() => repository.deleteNotification(2)).thenAnswer((_) async {});
    expect(await notifier.delete(2), isTrue);
    expect(container.read(notificationProvider).value!.map((n) => n.id), [1, 3]);
  });

  test('Model parse JSON dạng mảng ngày của Spring + suy ra type', () {
    final model = NotificationModel.fromJson({
      'id': 7,
      'trackId': null,
      'albumId': 3,
      'content': 'Album mới',
      'isRead': false,
      'createdAt': [2026, 10, 16, 14, 30, 5],
    });

    expect(model.createdAt, DateTime(2026, 10, 16, 14, 30, 5));
    expect(model.type, NotificationType.newAlbum);
  });

  test('unreadNotificationCountProvider: đếm chuẩn, tăng khi có SSE, giảm khi đọc/xóa', () async {
    final container = await loggedInContainer();
    // Ban đầu [unread, read] -> 1 chưa đọc
    expect(container.read(unreadNotificationCountProvider), 1);

    // SSE đẩy thông báo chưa đọc -> tăng lên 2
    final fresh = unread.copyWith(id: 3, trackId: 11);
    sseController.add(NotificationReceivedEvent(fresh));
    await Future<void>.delayed(Duration.zero);
    expect(container.read(unreadNotificationCountProvider), 2);

    // Đọc thông báo id 1 -> giảm về 1
    when(() => repository.markAsRead(1)).thenAnswer((_) async {});
    await container.read(notificationProvider.notifier).markAsRead(1);
    expect(container.read(unreadNotificationCountProvider), 1);

    // Xóa thông báo id 3 -> giảm về 0
    when(() => repository.deleteNotification(3)).thenAnswer((_) async {});
    await container.read(notificationProvider.notifier).delete(3);
    expect(container.read(unreadNotificationCountProvider), 0);
  });

  test('SSE TRACK_DELETED -> tự động xóa notification gắn với trackId trong real-time', () async {
    final container = await loggedInContainer();
    expect(container.read(notificationProvider).value!.map((n) => n.id), [1, 2]);

    // unread (id=1) có trackId: 10
    sseController.add(const TrackDeletedEvent(10));
    await Future<void>.delayed(Duration.zero);

    // Thông báo có trackId 10 tự động biến mất khỏi danh sách
    expect(container.read(notificationProvider).value!.map((n) => n.id), [2]);
    // Số thông báo chưa đọc tự động giảm về 0
    expect(container.read(unreadNotificationCountProvider), 0);
  });
}
