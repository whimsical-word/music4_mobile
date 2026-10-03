import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

Future<void> showEditProfileDialog(
  BuildContext context,
  WidgetRef ref, {
  String? currentName,
  String? imageUrl,
}) {
  final nameCtrl = TextEditingController(text: currentName);
  final imageUrlCtrl = TextEditingController(text: imageUrl);

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Chỉnh sửa hồ sơ',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Tên hiển thị'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: imageUrlCtrl,
            decoration: const InputDecoration(labelText: 'URL ảnh'),
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.pop(ctx);
            // TODO: gọi repo.updateProfile(...)
            // ref.read(userProfileProvider.notifier).updateProfile(...)
          },
          child: const Text('Lưu'),
        ),
      ],
    ),
  );
}
