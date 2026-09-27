import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class CreatePlaylistDialog extends StatefulWidget {
  final ValueChanged<String>? onCreated;

  const CreatePlaylistDialog({super.key, this.onCreated});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const CreatePlaylistDialog(),
    );
  }

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    HapticFeedback.lightImpact();
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên playlist');
      return;
    }
    widget.onCreated?.call(name);
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.surface,
      title: const Text(
        'Tạo Playlist mới',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Nhập tên playlist (VD: Chill Vibes)',
          errorText: _errorMessage,
          prefixIcon: const Icon(Icons.playlist_add, color: AppColors.primary),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Tạo', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
