import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/user_profile_provider.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  final String? currentName;
  final bool? currentGender;
  final String? imageUrl;

  const EditProfileDialog({
    super.key,
    this.currentName,
    this.currentGender,
    this.imageUrl,
  });

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _imageUrlCtrl;
  bool _isMale = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentName);
    _imageUrlCtrl = TextEditingController(text: widget.imageUrl);
    _isMale = widget.currentGender ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: const Text(
        'Chỉnh sửa hồ sơ',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên hiển thị'),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text('Giới tính:', style: TextStyle(color: AppColors.textPrimary)),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isMale,
                  onChanged: (val) {
                    setState(() => _isMale = val!);
                  },
                ),
                const Text('Nam', style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(width: 16),
                Radio<bool>(
                  value: false,
                  groupValue: _isMale,
                  onChanged: (val) {
                    setState(() => _isMale = val!);
                  },
                ),
                const Text('Nữ', style: TextStyle(color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageUrlCtrl,
              decoration: const InputDecoration(labelText: 'URL ảnh (tạm thời)'),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(userProfileProvider.notifier).updateProfile(
              displayName: _nameCtrl.text.trim(),
              gender: _isMale,
              avatarFilePath: _imageUrlCtrl.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

Future<void> showEditProfileDialog(
  BuildContext context,
  WidgetRef ref, {
  String? currentName,
  bool? currentGender,
  String? imageUrl,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => EditProfileDialog(
      currentName: currentName,
      currentGender: currentGender,
      imageUrl: imageUrl,
    ),
  );
}
