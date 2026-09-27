import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/file_picker_area.dart';
import '../widgets/upload_form_fields.dart';

class UploadTrackScreen extends StatefulWidget {
  const UploadTrackScreen({super.key});

  @override
  State<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _collabArtistsController = TextEditingController();

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  bool _isAudioSelected = false;
  bool _isCoverSelected = false;
  
  String? _selectedCategory;
  final List<String> _categories = ['Pop (1)', 'Rock (2)', 'Hip-Hop (3)', 'Acoustic (4)'];

  @override
  void dispose() {
    _titleController.dispose();
    _albumController.dispose();
    _collabArtistsController.dispose();
    super.dispose();
  }

  void _simulateUpload() {
    if (!_isAudioSelected || !_isCoverSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đủ File Âm thanh và Ảnh bìa!')),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Tên bài hát và Thể loại!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    Future(() async {
      for (int i = 1; i <= 100; i += 5) {
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) setState(() => _uploadProgress = i / 100.0);
      }
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isAudioSelected = false;
          _isCoverSelected = false;
          _titleController.clear();
          _albumController.clear();
          _collabArtistsController.clear();
          _selectedCategory = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải lên thành công! Bài hát đang chờ duyệt.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Studio - Upload Nhạc'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilePickerArea(
              isUploading: _isUploading,
              isCoverSelected: _isCoverSelected,
              isAudioSelected: _isAudioSelected,
              onCoverTap: () => setState(() => _isCoverSelected = !_isCoverSelected),
              onAudioTap: () => setState(() => _isAudioSelected = !_isAudioSelected),
            ),
            const SizedBox(height: 24),
            
            if (_isUploading) ...[
              const Text('Đang đẩy 2 files lên AWS S3...', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: _uploadProgress, backgroundColor: AppColors.divider, color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
              const SizedBox(height: 8),
              Text('${(_uploadProgress * 100).toInt()}%', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 24),
            ],

            UploadFormFields(
              titleController: _titleController,
              collabArtistsController: _collabArtistsController,
              albumController: _albumController,
              isUploading: _isUploading,
              selectedCategory: _selectedCategory,
              categories: _categories,
              onCategoryChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _simulateUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _isUploading ? 'ĐANG XỬ LÝ...' : 'TẢI LÊN & XUẤT BẢN',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
