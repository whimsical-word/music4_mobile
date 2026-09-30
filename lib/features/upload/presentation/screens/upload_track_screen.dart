import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/upload_provider.dart';
import '../widgets/file_picker_area.dart';
import '../widgets/upload_form_fields.dart';
import '../widgets/upload_progress_widget.dart';

class UploadTrackScreen extends ConsumerStatefulWidget {
  const UploadTrackScreen({super.key});

  @override
  ConsumerState<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends ConsumerState<UploadTrackScreen> {
  final _titleController = TextEditingController();
  final _albumController = TextEditingController();
  final _collabArtistsController = TextEditingController();
  bool _isAudioSelected = false, _isCoverSelected = false;
  String? _selectedCategory;
  final _categories = ['Pop (1)', 'Rock (2)', 'Hip-Hop (3)', 'Acoustic (4)'];

  @override
  void dispose() {
    _titleController.dispose();
    _albumController.dispose();
    _collabArtistsController.dispose();
    super.dispose();
  }

  void _onUpload() {
    if (!_isAudioSelected || !_isCoverSelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn đủ File Âm thanh và Ảnh bìa!')));
      return;
    }
    if (_titleController.text.trim().isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập Tên bài hát và Thể loại!')));
      return;
    }

    ref.read(uploadNotifierProvider.notifier).uploadTrack(
      title: _titleController.text.trim(),
      categoryId: _selectedCategory!.replaceAll(RegExp(r'[^0-9]'), ''),
      albumId: _albumController.text.trim(),
      collabArtists: _collabArtistsController.text.trim(),
      audioFilePath: '/fake/path/audio.mp3', // TODO: Use real file picker
      coverFilePath: '/fake/path/cover.jpg', // TODO: Use real file picker
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadNotifierProvider);
    final isUploading = uploadState is AsyncLoading;

    ref.listen(uploadNotifierProvider, (_, next) {
      if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tải lên thành công! Bài hát đang chờ duyệt.')));
        setState(() { _isAudioSelected = false; _isCoverSelected = false; _selectedCategory = null; });
        _titleController.clear(); _albumController.clear(); _collabArtistsController.clear();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Artist Studio - Upload Nhạc'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilePickerArea(
              isUploading: isUploading, isCoverSelected: _isCoverSelected, isAudioSelected: _isAudioSelected,
              onCoverTap: () => setState(() => _isCoverSelected = !_isCoverSelected),
              onAudioTap: () => setState(() => _isAudioSelected = !_isAudioSelected),
            ),
            const SizedBox(height: 24),
            if (isUploading) const UploadProgressWidget(progress: 0.5), // Dummy progress
            UploadFormFields(
              titleController: _titleController, collabArtistsController: _collabArtistsController,
              albumController: _albumController, isUploading: isUploading,
              selectedCategory: _selectedCategory, categories: _categories,
              onCategoryChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isUploading ? null : _onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isUploading ? 'ĐANG XỬ LÝ...' : 'TẢI LÊN & XUẤT BẢN', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
