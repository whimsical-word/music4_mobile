import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AdminCategoryDialog extends StatefulWidget {
  final String? initialName;
  final ValueChanged<String> onSave;

  const AdminCategoryDialog({
    super.key,
    this.initialName,
    required this.onSave,
  });

  @override
  State<AdminCategoryDialog> createState() => _AdminCategoryDialogState();
}

class _AdminCategoryDialogState extends State<AdminCategoryDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Tên thể loại không được để trống');
      return;
    }
    widget.onSave(text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;

    return AlertDialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEditing ? 'Chỉnh sửa Thể loại' : 'Thêm Thể loại mới',
        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: 'Tên thể loại',
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          hintText: 'Ví dụ: V-Pop, Ballad, R&B...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          errorText: _errorText,
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (_) {
          if (_errorText != null) setState(() => _errorText = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: _submit,
          child: Text(isEditing ? 'Lưu' : 'Tạo mới', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
