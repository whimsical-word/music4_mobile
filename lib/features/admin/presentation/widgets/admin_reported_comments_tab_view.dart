import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/admin_repository.dart';
import '../providers/admin_reported_comments_provider.dart';
import 'admin_empty_state.dart';
import 'admin_shimmer_skeleton.dart';

class AdminReportedCommentsTabView extends ConsumerWidget {
  const AdminReportedCommentsTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportedCommentsProvider);

    return reportsAsync.when(
      loading: () => const AdminShimmerSkeleton(),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () =>
                    ref.read(adminReportedCommentsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (reports) {
        final hiddenCount = reports.where((e) => e.isTemporarilyHidden).length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chờ duyệt: ${reports.length} bình luận ($hiddenCount đang ẩn tạm thời)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    tooltip: 'Làm mới',
                    onPressed: () => ref
                        .read(adminReportedCommentsProvider.notifier)
                        .refresh(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            Expanded(
              child: reports.isEmpty
                  ? const AdminEmptyState(
                      title: 'Không có báo cáo vi phạm nào',
                      message: 'Tất cả các bình luận bị báo cáo đã được xử lý sạch sẽ.',
                      icon: Icons.verified_user_outlined,
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.card,
                      onRefresh: () => ref
                          .read(adminReportedCommentsProvider.notifier)
                          .refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final item = reports[index];
                          return _buildReportCard(context, ref, item);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    WidgetRef ref,
    AdminReportedCommentModel item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isTemporarilyHidden
              ? AppColors.error.withValues(alpha: 0.6)
              : AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.commenterName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isTemporarilyHidden
                      ? AppColors.error.withValues(alpha: 0.18)
                      : AppColors.warning.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.isTemporarilyHidden
                      ? 'Đang ẩn tạm thời (${item.reportCount} báo cáo)'
                      : 'Chờ duyệt (${item.reportCount} báo cáo)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: item.isTemporarilyHidden
                        ? AppColors.error
                        : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"${item.content}"',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lý do báo cáo: ${item.reasons.join(" • ")}',
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          if (item.trackId != null) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () => context.push('/track/${item.trackId}'),
              child: Text(
                'Xem bài hát #${item.trackId} ➔',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await ref
                        .read(adminReportedCommentsProvider.notifier)
                        .dismissReport(item.commentId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Đã khôi phục bình luận và bỏ qua các báo cáo!',
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: $e'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(
                  Icons.restore_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: const Text(
                  'Khôi phục (Giữ lại)',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _confirmDelete(context, ref, item),
                icon: const Icon(Icons.delete_forever_rounded, size: 16),
                label: const Text(
                  'Xóa vĩnh viễn',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AdminReportedCommentModel item,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận xóa bình luận vi phạm',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa vĩnh viễn bình luận của "${item.commenterName}" khỏi hệ thống không?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(adminReportedCommentsProvider.notifier)
                    .approveDelete(item.commentId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Đã duyệt xóa vĩnh viễn bình luận vi phạm!',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Không thể xóa: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Xóa vĩnh viễn'),
          ),
        ],
      ),
    );
  }
}
