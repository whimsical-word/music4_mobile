import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';

class EditPlaylistResult {
  final String name;
  final String? description;
  final String? coverFilePath;

  const EditPlaylistResult({
    required this.name,
    this.description,
    this.coverFilePath,
  });
}

class EditPlaylistDialog extends StatefulWidget {
  final String initialName;
  final String? initialDescription;
  final String? initialCoverUrl;

  const EditPlaylistDialog({
    super.key,
    required this.initialName,
    this.initialDescription,
    this.initialCoverUrl,
  });

  static Future<EditPlaylistResult?> show(
    BuildContext context, {
    required String initialName,
    String? initialDescription,
    String? initialCoverUrl,
  }) {
    return showDialog<EditPlaylistResult>(
      context: context,
      builder: (context) => EditPlaylistDialog(
        initialName: initialName,
        initialDescription: initialDescription,
        initialCoverUrl: initialCoverUrl,
      ),
    );
  }

  @override
  State<EditPlaylistDialog> createState() => _EditPlaylistDialogState();
}

class _EditPlaylistDialogState extends State<EditPlaylistDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String? _pickedFilePath;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e')),
      );
    }
  }

  void _submit() {
    HapticFeedback.lightImpact();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên playlist');
      return;
    }

    final desc = _descController.text.trim();
    Navigator.of(context).pop(
      EditPlaylistResult(
        name: name,
        description: desc.isNotEmpty ? desc : null,
        coverFilePath: _pickedFilePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedCover = ImageUrlHelper.resolve(widget.initialCoverUrl);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surface,
      title: const Text(
        'Chỉnh sửa Playlist',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Khung chọn ảnh bìa
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          border: Border.all(
                            color: AppColors.divider.withValues(alpha: 0.4),
                          ),
                        ),
                        child: _pickedFilePath != null
                            ? Image.file(
                                File(_pickedFilePath!),
                                fit: BoxFit.cover,
                              )
                            : (resolvedCover != null && resolvedCover.isNotEmpty
                                ? Image.network(
                                    resolvedCover,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: Icon(
                                        Icons.queue_music_rounded,
                                        size: 40,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.queue_music_rounded,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                  )),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: _pickImage,
              child: Text(
                _pickedFilePath != null ? 'Đổi ảnh bìa khác' : 'Chọn ảnh bìa',
                style: const TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            // Ô nhập tên playlist
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Tên playlist *',
                errorText: _errorMessage,
                prefixIcon: const Icon(Icons.edit, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            // Ô nhập mô tả
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Mô tả (tùy chọn)',
                prefixIcon:
                    Icon(Icons.description, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Hủy',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child:
              const Text('Lưu', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
