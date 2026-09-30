import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/album_provider.dart';

class AlbumCreationForm extends ConsumerStatefulWidget {
  const AlbumCreationForm({super.key});

  @override
  ConsumerState<AlbumCreationForm> createState() => _AlbumCreationFormState();
}

class _AlbumCreationFormState extends ConsumerState<AlbumCreationForm> {
  final _titleController = TextEditingController();
  bool _isCoverSelected = false;

  @override
  void dispose() { _titleController.dispose(); super.dispose(); }

  void _onCreate() {
    if (!_isCoverSelected || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên và chọn ảnh bìa!')));
      return;
    }
    ref.read(albumNotifierProvider.notifier).createAlbum(_titleController.text.trim(), '/fake/path/album_cover.jpg');
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tạo Album...')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tạo Album Mới', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isCoverSelected = !_isCoverSelected),
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: _isCoverSelected ? AppColors.primary : Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(12), color: AppColors.card,
                    image: _isCoverSelected ? const DecorationImage(image: NetworkImage('https://picsum.photos/300'), fit: BoxFit.cover) : null,
                  ),
                  child: _isCoverSelected ? null : const Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_photo_alternate, color: Colors.grey), Text('Ảnh bìa', style: TextStyle(fontSize: 12))]),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Tên Album (Title)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), filled: true, fillColor: AppColors.card),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: ElevatedButton(
                        onPressed: _onCreate,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('TẠO ALBUM', style: TextStyle(fontWeight: FontWeight.bold)),
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
