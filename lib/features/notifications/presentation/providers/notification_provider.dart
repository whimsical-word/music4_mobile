import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/notification_sse_service.dart';

/// Repository dùng chung `DioClient` (đã gắn AuthInterceptor) của module Auth.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioClientProvider).dio);
});

final notificationSseServiceProvider = Provider<NotificationSseService>((ref) {
  return NotificationSseService(ref.watch(dioClientProvider).dio);
});

/// Số thông báo chưa đọc, tự động cập nhật real-time khi có SSE hoặc đọc/xóa.
final unreadNotificationCountProvider = Provider<int>((ref) {
  final asyncValue = ref.watch(notificationProvider);
  return asyncValue.maybeWhen(
    data: (list) => list.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

final notificationProvider =
    AsyncNotifierProvider<NotificationNotifier, List<NotificationModel>>(
      NotificationNotifier.new,
    );

class NotificationNotifier extends AsyncNotifier<List<NotificationModel>> {
  int? _userId;
  bool _loaded = false;
  final List<NotificationModel> _buffered = [];

  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  /// Tự rebuild khi Login/Logout vì `watch` userId lấy từ AuthState.
  @override
  Future<List<NotificationModel>> build() async {
    _loaded = false;
    _buffered.clear();

    final userId = ref.watch(
      authNotifierProvider.select(
        (s) => s is AuthAuthenticated ? s.user.id : null,
      ),
    );
    _userId = userId;
    if (userId == null) return const [];

    // Mở SSE trước khi fetch để không bỏ lỡ sự kiện; đóng khi dispose/logout.
    final subscription = ref
        .read(notificationSseServiceProvider)
        .subscribe(userId)
        .listen(_onSseEvent);
    ref.onDispose(subscription.cancel);

    final fetched = await _repository.getNotifications(userId);
    _loaded = true;
    final merged = _prepend(fetched, _buffered);
    _buffered.clear();
    return merged;
  }

  /// Danh sách đã nạp lại (pull-to-refresh), giữ dữ liệu cũ nếu lỗi mạng.
  Future<void> refresh() async {
    final userId = _userId;
    if (userId == null) return;
    final result = await AsyncValue.guard(
      () => _repository.getNotifications(userId),
    );
    state = result.hasError && state.hasValue ? state : result;
  }

  /// Nút "Thử lại" ở màn lỗi: dựng lại notifier (fetch + reconnect SSE).
  void retry() => ref.invalidateSelf();

  // ─── Optimistic actions: trả về false nếu API lỗi (đã rollback) ───────────

  Future<bool> markAsRead(int id) async {
    final current = state.valueOrNull;
    final target = current?.where((n) => n.id == id).firstOrNull;
    if (current == null || target == null || target.isRead) return true;

    _replace(id, target.copyWith(isRead: true));
    try {
      await _repository.markAsRead(id);
      return true;
    } catch (_) {
      _replace(id, target);
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    final unread = (state.valueOrNull ?? []).where((n) => !n.isRead).toList();
    final results = await Future.wait(unread.map((n) => markAsRead(n.id)));
    return results.every((ok) => ok);
  }

  Future<bool> delete(int id) async {
    final current = state.valueOrNull;
    final index = current?.indexWhere((n) => n.id == id) ?? -1;
    if (current == null || index < 0) return true;

    final removed = current[index];
    state = AsyncData([...current]..removeAt(index));
    try {
      await _repository.deleteNotification(id);
      return true;
    } catch (_) {
      final List<NotificationModel> list = [...?state.valueOrNull];
      list.insert(index.clamp(0, list.length), removed);
      state = AsyncData(list);
      return false;
    }
  }

  Future<bool> clearAll() async {
    final previous = state.valueOrNull;
    if (previous == null || previous.isEmpty) return true;

    state = const AsyncData([]);
    try {
      await _repository.clearAll();
      return true;
    } catch (_) {
      state = AsyncData(previous);
      return false;
    }
  }

  // ─── Real-time ────────────────────────────────────────────────────────────

  void _onSseEvent(NotificationSseEvent event) {
    switch (event) {
      case NotificationReceivedEvent(:final notification):
        _onIncoming(notification);
      case TrackDeletedEvent(:final trackId):
        _onTrackDeleted(trackId);
    }
  }

  void _onIncoming(NotificationModel incoming) {
    if (!_loaded) {
      _buffered.add(incoming);
      return;
    }
    final current = state.valueOrNull ?? [];
    state = AsyncData(_prepend(current, [incoming]));
  }

  void _onTrackDeleted(int trackId) {
    _buffered.removeWhere((n) => n.trackId == trackId);
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.where((n) => n.trackId != trackId).toList());
  }

  /// Chèn lên đầu (mới nhất trước), bỏ trùng id.
  List<NotificationModel> _prepend(
    List<NotificationModel> base,
    List<NotificationModel> fresh,
  ) {
    final ids = base.map((n) => n.id).toSet();
    final added = fresh.where((n) => ids.add(n.id)).toList().reversed;
    return [...added, ...base];
  }

  void _replace(int id, NotificationModel value) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData([for (final n in current) n.id == id ? value : n]);
  }
}
