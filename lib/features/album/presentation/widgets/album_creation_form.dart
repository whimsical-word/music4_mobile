import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumCreationForm extends StatefulWidget {
  const AlbumCreationForm({super.key});

  @override
  State<AlbumCreationForm> createState() => _AlbumCreationFormState();
}

class _AlbumCreationFormState extends State<AlbumCreationForm> {
  final TextEditingController _titleController = TextEditingController();
  bool _isCoverSelected = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleCreateAlbum() {
    if (!_isCoverSelected || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên Album và chọn ảnh bìa!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo Album thành công!')),
        );
        Navigator.pop(context); // Đóng popup sau khi tạo xong
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding bottom để tránh bàn phím che khuất form
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tạo Album Mới',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isSubmitting ? null : () => setState(() => _isCoverSelected = !_isCoverSelected),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: _isCoverSelected ? AppColors.primary : Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.card,
                    image: _isCoverSelected
                        ? const DecorationImage(image: NetworkImage('https://picsum.photos/300'), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _isCoverSelected
                      ? null
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, color: Colors.grey),
                              SizedBox(height: 4),
                              Text('Ảnh bìa', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      enabled: !_isSubmitting,
                      decoration: InputDecoration(
                        labelText: 'Tên Album (Title)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: AppColors.card,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleCreateAlbum,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          _isSubmitting ? 'ĐANG TẠO...' : 'TẠO ALBUM',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
