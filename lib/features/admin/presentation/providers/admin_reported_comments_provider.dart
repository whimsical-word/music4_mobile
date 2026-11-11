import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_repository.dart';

final adminReportedCommentsProvider =
    AsyncNotifierProvider<
      AdminReportedCommentsNotifier,
      List<AdminReportedCommentModel>
    >(() => AdminReportedCommentsNotifier());

class AdminReportedCommentsNotifier
    extends AsyncNotifier<List<AdminReportedCommentModel>> {
  late final AdminRepository _repository;

  @override
  FutureOr<List<AdminReportedCommentModel>> build() {
    _repository = ref.watch(adminRepositoryProvider);
    return _fetchPendingReports();
  }

  Future<List<AdminReportedCommentModel>> _fetchPendingReports() async {
    return _repository.getPendingReportedComments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPendingReports());
  }

  /// Khôi phục bình luận (bỏ qua báo cáo -> bình luận hiển thị trở lại)
  Future<void> dismissReport(int commentId) async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.where((c) => c.commentId != commentId).toList(),
      );
    }

    try {
      await _repository.dismissCommentReports(commentId);
    } catch (e) {
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      }
      rethrow;
    }
  }

  /// Duyệt xóa vĩnh viễn bình luận vi phạm khỏi hệ thống
  Future<void> approveDelete(int commentId) async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(
        previousState.where((c) => c.commentId != commentId).toList(),
      );
    }

    try {
      await _repository.approveDeleteReportedComment(commentId);
    } catch (e) {
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      }
      rethrow;
    }
  }
}
