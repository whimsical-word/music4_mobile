import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_category_model.dart';
import '../providers/admin_categories_provider.dart';
import 'admin_category_dialog.dart';
import 'admin_category_tile.dart';
import 'admin_empty_state.dart';
import 'admin_shimmer_skeleton.dart';

class AdminCategoriesTabView extends ConsumerWidget {
  const AdminCategoriesTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);

    return categoriesAsync.when(
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
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () =>
                    ref.read(adminCategoriesProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text('Thử lại', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      data: (categories) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Tổng số: ${categories.length} thể loại',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () => _showAddDialog(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Thêm thể loại',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            Expanded(
              child: categories.isEmpty
                  ? const AdminEmptyState(
                      title: 'Chưa có thể loại nào',
                      message: 'Nhấn "Thêm thể loại" để tạo thể loại đầu tiên.',
                      icon: Icons.category_outlined,
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.card,
                      onRefresh: () =>
                          ref.read(adminCategoriesProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return AdminCategoryTile(
                            category: category,
                            onTap: () => context.push('/category/${category.id}'),
                            onEdit: () =>
                                _showEditDialog(context, ref, category),
                            onDelete: () =>
                                _confirmDelete(context, ref, category),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AdminCategoryDialog(
        onSave: (name) async {
          try {
            await ref
                .read(adminCategoriesProvider.notifier)
                .createCategory(name);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã tạo thể loại "$name" thành công.')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AdminCategoryModel category,
  ) {
    showDialog(
      context: context,
      builder: (_) => AdminCategoryDialog(
        initialName: category.name,
        onSave: (newName) async {
          try {
            await ref
                .read(adminCategoriesProvider.notifier)
                .updateCategory(category.id, newName);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã cập nhật thể loại "$newName" thành công.'),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AdminCategoryModel category,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận xóa thể loại',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa thể loại "${category.name}" không?\n\n'
          'Lưu ý: Nếu thể loại đang chứa bài hát, hệ thống sẽ từ chối xóa để bảo vệ dữ liệu.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
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
                    .read(adminCategoriesProvider.notifier)
                    .deleteCategory(category.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa thể loại "${category.name}".'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Không thể xóa: $e'),
                      backgroundColor: Colors.red[800],
                    ),
                  );
                }
              }
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
