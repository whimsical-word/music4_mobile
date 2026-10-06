import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';

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
  String? _pickedFilePath;
  bool _isMale = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentName);
    _isMale = widget.currentGender ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _pickedFilePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Không thể chọn ảnh: $e')));
    }
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
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      backgroundImage: _pickedFilePath != null
                          ? FileImage(File(_pickedFilePath!)) as ImageProvider
                          : (widget.imageUrl != null &&
                                    widget.imageUrl!.isNotEmpty
                                ? NetworkImage(
                                    ApiEndpoints.buildImageUrl(
                                      widget.imageUrl!,
                                    ),
                                  )
                                : null),
                      child:
                          (_pickedFilePath == null &&
                              (widget.imageUrl == null ||
                                  widget.imageUrl!.isEmpty))
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Tên hiển thị'),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Giới tính:',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            RadioGroup<bool>(
              groupValue: _isMale,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _isMale = val);
                }
              },
              child: Row(
                children: [
                  const Radio<bool>(value: true),
                  const Text(
                    'Nam',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 16),
                  const Radio<bool>(value: false),
                  const Text(
                    'Nữ',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ),
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
            ref
                .read(userProfileProvider.notifier)
                .updateProfile(
                  displayName: _nameCtrl.text.trim(),
                  gender: _isMale,
                  avatarFilePath: _pickedFilePath,
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
