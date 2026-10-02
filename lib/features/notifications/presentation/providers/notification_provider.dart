import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

// 1. Cung cấp Dio instance
final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

// 2. Cung cấp Repository
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepository(dio);
});

// 3. StateNotifier quản lý danh sách thông báo
class NotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchNotifications() async {
    state = const AsyncValue.loading();

    try {
      // TODO: Thay thế bằng userId lấy từ AuthProvider/UserProfileProvider khi T2 hoàn thiện
      const userId = '1';

      final notifications = await _repository.getNotifications(userId);
      state = AsyncValue.data(notifications);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await fetchNotifications();
  }

  Future<void> subscribeToPush(String fcmToken) async {
    try {
      const userId = '1';
      await _repository.subscribe(userId, fcmToken);
    } catch (e) {
      // Trong Tuần 3, việc đăng ký push lỗi chỉ ghi log, không làm sập giao diện danh sách
      // ignore: avoid_print
      print('Subscribe to push failed: $e');
    }
  }
}

// 4. Cung cấp Notifier cho UI lắng nghe
final notificationProvider =
    StateNotifierProvider<
      NotificationNotifier,
      AsyncValue<List<NotificationModel>>
    >((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationNotifier(repository)..fetchNotifications();
    });
