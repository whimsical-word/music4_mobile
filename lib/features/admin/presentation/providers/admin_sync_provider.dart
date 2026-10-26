import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/vector_sync_status.dart';
import '../../data/repositories/admin_sync_repository.dart';

class AdminVectorSyncState {
  final AsyncValue<VectorSyncStatus> status;

  /// The "start" request is in flight.
  final bool isStarting;

  /// Started: the status is being watched until the run is over.
  final bool isWaiting;

  /// What happened on the last action (shown under the button).
  final String? notice;
  final bool noticeIsError;

  const AdminVectorSyncState({
    this.status = const AsyncValue.loading(),
    this.isStarting = false,
    this.isWaiting = false,
    this.notice,
    this.noticeIsError = false,
  });

  /// A run is going (started from here, or already running on the backend).
  bool get isBusy =>
      isStarting || isWaiting || (status.valueOrNull?.syncRunning ?? false);

  AdminVectorSyncState copyWith({
    AsyncValue<VectorSyncStatus>? status,
    bool? isStarting,
    bool? isWaiting,
    String? notice,
    bool? noticeIsError,
    bool clearNotice = false,
  }) {
    return AdminVectorSyncState(
      status: status ?? this.status,
      isStarting: isStarting ?? this.isStarting,
      isWaiting: isWaiting ?? this.isWaiting,
      notice: clearNotice ? null : (notice ?? this.notice),
      noticeIsError: clearNotice ? false : (noticeIsError ?? this.noticeIsError),
    );
  }
}

class AdminVectorSyncNotifier extends StateNotifier<AdminVectorSyncState> {
  final AdminSyncRepository _repository;
  final Duration pollInterval;
  final int maxPolls;

  AdminVectorSyncNotifier(
    this._repository, {
    this.pollInterval = const Duration(seconds: 3),
    this.maxPolls = 200,
  }) : super(const AdminVectorSyncState());

  /// First load / retry: shows the loading state.
  Future<void> load() async {
    state = state.copyWith(status: const AsyncValue.loading());
    await _readStatus();
  }

  /// Reads the status again and keeps the numbers on screen if that fails.
  Future<void> refresh() => _readStatus();

  /// Starts a full synchronisation, then watches the status until it ends.
  Future<void> startSync() async {
    if (state.isBusy) return;

    state = state.copyWith(isStarting: true, clearNotice: true);

    final before = state.status.valueOrNull?.lastFullSync?.finishedAt;

    try {
      final result = await _repository.startSync();
      if (!mounted) return;

      state = state.copyWith(
        isStarting: false,
        isWaiting: true,
        notice: result == SyncStartResult.started
            ? 'Đã bắt đầu đồng bộ ở chế độ nền...'
            : 'Một tiến trình đồng bộ khác đang chạy. Đang theo dõi...',
        noticeIsError: false,
      );
    } on AdminSyncException catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isStarting: false,
        notice: e.message,
        noticeIsError: true,
      );
      return;
    }

    await _watchUntilFinished(before);
  }

  Future<VectorSyncStatus?> _readStatus() async {
    try {
      final status = await _repository.getStatus();
      if (!mounted) return null;
      state = state.copyWith(status: AsyncValue.data(status));
      return status;
    } catch (e, stackTrace) {
      if (!mounted) return null;
      if (state.status.hasValue) {
        state = state.copyWith(notice: e.toString(), noticeIsError: true);
      } else {
        state = state.copyWith(status: AsyncValue.error(e, stackTrace));
      }
      return null;
    }
  }

  Future<void> _watchUntilFinished(DateTime? finishedBefore) async {
    var idlePolls = 0;

    for (var i = 0; i < maxPolls; i++) {
      await Future<void>.delayed(pollInterval);
      if (!mounted) return;

      final status = await _readStatus();
      if (!mounted) return;

      if (status == null) {
        state = state.copyWith(
          isWaiting: false,
          notice: 'Không theo dõi được tiến trình. Xem log backend để biết kết quả.',
          noticeIsError: true,
        );
        return;
      }
      if (status.syncRunning) continue;

      final finishedAt = status.lastFullSync?.finishedAt;
      final hasNewResult = finishedAt != null && finishedAt != finishedBefore;

      // Not running and nothing new: the run may not have begun yet. Give it a
      // few polls before saying there is nothing to report.
      if (!hasNewResult && ++idlePolls < 3) continue;

      state = state.copyWith(
        isWaiting: false,
        notice: hasNewResult
            ? _summaryOf(status.lastFullSync!)
            : 'Không thấy tiến trình nào chạy. Xem log backend để biết lý do.',
        noticeIsError: !hasNewResult,
      );
      return;
    }

    if (mounted) {
      state = state.copyWith(
        isWaiting: false,
        notice: 'Vẫn đang đồng bộ. Bấm làm mới để xem lại sau.',
        noticeIsError: false,
      );
    }
  }

  String _summaryOf(VectorSyncRun run) {
    return 'Hoàn tất: ${run.synced} bài thành công, ${run.failed} lỗi, '
        '${run.removedOrphans} vector mồ côi đã xóa.';
  }
}

/// autoDispose: leaving the dashboard stops the watching.
final adminVectorSyncProvider = StateNotifierProvider.autoDispose<
  AdminVectorSyncNotifier,
  AdminVectorSyncState
>((ref) => AdminVectorSyncNotifier(ref.watch(adminSyncRepositoryProvider))..load());
