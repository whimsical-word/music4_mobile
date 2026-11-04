import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/vector_sync_status.dart';
import '../providers/admin_sync_provider.dart';

/// Admin card: do the Elasticsearch vectors match the tracks in SQL, and a
/// button to run a full synchronisation of the recommendation index.
class VectorSyncCard extends ConsumerWidget {
  const VectorSyncCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(adminVectorSyncProvider);
    final notifier = ref.read(adminVectorSyncProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hub_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đồng bộ gợi ý (Elasticsearch)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  key: const Key('vector_sync_refresh_btn'),
                  tooltip: 'Làm mới',
                  icon: const Icon(Icons.refresh),
                  onPressed: sync.status.isLoading ? null : notifier.refresh,
                ),
              ],
            ),
            const SizedBox(height: 8),
            sync.status.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LinearProgressIndicator(),
              ),
              error: (error, _) => _buildError(context, error, notifier),
              data: (status) => _buildStatus(context, status),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const Key('vector_sync_button'),
                onPressed: sync.isBusy || sync.status.isLoading
                    ? null
                    : () => _confirmAndStart(context, ref),
                icon: sync.isBusy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(sync.isBusy ? 'Đang đồng bộ...' : 'Đồng bộ ngay'),
              ),
            ),
            if (sync.notice != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  sync.notice!,
                  key: const Key('vector_sync_notice'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: sync.noticeIsError
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    AdminVectorSyncNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          error.toString(),
          key: const Key('vector_sync_error'),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          key: const Key('vector_sync_retry_btn'),
          onPressed: notifier.load,
          child: const Text('Thử lại'),
        ),
      ],
    );
  }

  Widget _buildStatus(BuildContext context, VectorSyncStatus status) {
    final indexed = status.indexedVectors;
    final textTheme = Theme.of(context).textTheme;
    final run = status.lastFullSync;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(context, 'Bài hát trong SQL', '${status.sqlTracks}'),
        const SizedBox(height: 4),
        _row(
          context,
          'Vector trong Elasticsearch',
          indexed == null ? 'Không kết nối được' : '$indexed',
        ),
        const SizedBox(height: 8),
        _buildBadge(status),
        const SizedBox(height: 8),
        Text(
          run == null
              ? 'Chưa có lần đồng bộ toàn bộ nào kể từ khi backend khởi động.'
              : 'Lần gần nhất: ${_time(run.finishedAt)} · ${run.synced} thành công, '
                  '${run.failed} lỗi, ${run.removedOrphans} vector mồ côi đã xóa',
          key: const Key('vector_sync_last_run'),
          style: textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBadge(VectorSyncStatus status) {
    final indexed = status.indexedVectors;

    if (indexed == null) {
      return const Chip(
        key: Key('vector_sync_badge'),
        avatar: Icon(Icons.help_outline, size: 18),
        label: Text('Không xác định'),
      );
    }
    if (status.inSync) {
      return const Chip(
        key: Key('vector_sync_badge'),
        avatar: Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
        label: Text('Đã khớp'),
      );
    }

    final missing = status.missingVectors;
    return Chip(
      key: const Key('vector_sync_badge'),
      avatar: const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
      label: Text(missing > 0 ? 'Thiếu $missing vector' : 'Thừa vector'),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  /// 26/10 14:05
  String _time(DateTime? time) {
    if (time == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(time.day)}/${two(time.month)} ${two(time.hour)}:${two(time.minute)}';
  }

  Future<void> _confirmAndStart(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đồng bộ lại toàn bộ?'),
        content: const Text(
          'Backend sẽ tính lại vector của mọi bài hát và đẩy lên Elasticsearch. '
          'Việc này chạy nền và có thể mất vài phút nếu có nhiều bài hát.',
        ),
        actions: [
          TextButton(
            key: const Key('vector_sync_cancel_btn'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            key: const Key('vector_sync_confirm_btn'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Đồng bộ'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(adminVectorSyncProvider.notifier).startSync();
  }
}
