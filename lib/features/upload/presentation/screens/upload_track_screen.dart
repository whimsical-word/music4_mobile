import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../album/presentation/providers/album_provider.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../search/data/models/search_models.dart';
import '../../../track_management/presentation/providers/artist_tracks_provider.dart';
import '../../data/models/category_model.dart';
import '../providers/categories_provider.dart';
import '../providers/upload_provider.dart';
import '../widgets/file_picker_area.dart';
import '../widgets/image_crop_dialog.dart';
import '../widgets/upload_form_fields.dart';
import '../widgets/upload_progress_widget.dart';

class UploadTrackScreen extends ConsumerStatefulWidget {
  final String? initialAlbumId;
  const UploadTrackScreen({super.key, this.initialAlbumId});

  @override
  ConsumerState<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends ConsumerState<UploadTrackScreen> {
  final _titleController = TextEditingController();
  int? _selectedAlbumId;
  List<SearchItem> _selectedCollabArtists = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialAlbumId != null && widget.initialAlbumId!.isNotEmpty) {
      _selectedAlbumId = int.tryParse(widget.initialAlbumId!);
    }
  }

  File? _selectedAudioFile;
  String? _audioFileName;
  String? _audioFileSize;
  Duration? _audioDuration;
  bool _isValidatingAudio = false;

  File? _selectedCoverFile;
  CategoryModel? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'flac', 'm4a', 'aac'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final path = file.path;
      if (path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể đọc đường dẫn file nhạc.')),
          );
        }
        return;
      }

      // 1. Kiểm tra định dạng (whitelist audio)
      final extension = (file.extension ?? path.split('.').last).toLowerCase();
      const allowedExts = ['mp3', 'wav', 'flac', 'm4a', 'aac'];
      if (!allowedExts.contains(extension)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Định dạng .$extension không được hỗ trợ! Chỉ chấp nhận MP3, WAV, FLAC, M4A, AAC.',
              ),
            ),
          );
        }
        return;
      }

      // 2. Kiểm tra dung lượng file (Giới hạn tối đa 30MB)
      final sizeBytes = file.size;
      if (sizeBytes > 30 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Dung lượng file nhạc vượt quá 30MB! Vui lòng chọn file nhẹ hơn.',
              ),
            ),
          );
        }
        return;
      }

      // 3. Kiểm tra thời lượng file nhạc (Không quá 10 phút = 600s)
      setState(() => _isValidatingAudio = true);
      Duration? duration;
      final tempPlayer = AudioPlayer();
      try {
        duration = await tempPlayer.setFilePath(path);
      } catch (e) {
        debugPrint('Lỗi đọc thời lượng audio: $e');
      } finally {
        await tempPlayer.dispose();
      }

      if (!mounted) return;
      setState(() => _isValidatingAudio = false);

      if (duration != null && duration > const Duration(minutes: 10)) {
        final mins = duration.inMinutes;
        final secs = duration.inSeconds % 60;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Thời lượng bài hát ($mins phút $secs giây) vượt quá giới hạn 10 phút cho phép!',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final sizeMb = (sizeBytes / (1024 * 1024)).toStringAsFixed(1);
      setState(() {
        _selectedAudioFile = File(path);
        _audioFileName = file.name;
        _audioFileSize = '$sizeMb MB';
        _audioDuration = duration;
        if (_titleController.text.trim().isEmpty) {
          final cleanName = file.name.replaceAll(
            RegExp(r'\.[a-zA-Z0-9]+$'),
            '',
          );
          _titleController.text = cleanName;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isValidatingAudio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chọn file nhạc: $e')),
        );
      }
    }
  }

  Future<void> _pickCover() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final path = picked.path;
      final ext = path.split('.').last.toLowerCase();
      const allowedImgExts = ['jpg', 'jpeg', 'png', 'webp'];
      if (!allowedImgExts.contains(ext)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Định dạng ảnh .$ext không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP.',
              ),
            ),
          );
        }
        return;
      }

      if (!mounted) return;

      final croppedFile = await ImageCropDialog.show(context, File(path));
      if (croppedFile != null && mounted) {
        setState(() {
          _selectedCoverFile = croppedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi chọn ảnh bìa: $e')),
        );
      }
    }
  }

  void _onUpload() {
    if (_selectedAudioFile == null || _selectedCoverFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn đủ File Âm thanh và Ảnh bìa!'),
        ),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Tên bài hát và chọn Thể loại!'),
        ),
      );
      return;
    }

    final List<int>? artistIds = _selectedCollabArtists.isNotEmpty
        ? _selectedCollabArtists.map((a) => a.id).toList()
        : null;

    ref.read(uploadNotifierProvider.notifier).uploadTrack(
      title: _titleController.text.trim(),
      categoryIds: [_selectedCategory!.id],
      albumId: _selectedAlbumId?.toString(),
      artistIds: artistIds,
      audioFilePath: _selectedAudioFile!.path,
      coverFilePath: _selectedCoverFile!.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isArtist = authState is AuthAuthenticated && authState.user.isArtist;

    if (!isArtist) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Artist Studio - Upload Nhạc'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chỉ dành cho Nghệ sĩ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tính năng Tải lên bài hát chỉ dành riêng cho tài khoản Nghệ sĩ (Artist). Vui lòng đăng nhập bằng tài khoản Nghệ sĩ để truy cập.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final uploadState = ref.watch(uploadNotifierProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? defaultBackendCategories;
    final albumsAsync = ref.watch(albumNotifierProvider);
    final albums = albumsAsync.value ?? [];
    final isUploading = uploadState.isLoading || _isValidatingAudio;
    final currentArtistId = authState.user.id;

    ref.listen<UploadState>(uploadNotifierProvider, (previous, next) {
      if (next.isSuccess && (previous == null || !previous.isSuccess)) {
        ref.read(artistTracksNotifierProvider.notifier).refresh();
        ref.read(albumNotifierProvider.notifier).fetchMyAlbums(currentArtistId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tải lên thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedAudioFile = null;
          _audioFileName = null;
          _audioFileSize = null;
          _audioDuration = null;
          _selectedCoverFile = null;
          _selectedCategory = null;
          _selectedAlbumId = widget.initialAlbumId != null
              ? int.tryParse(widget.initialAlbumId!)
              : null;
          _selectedCollabArtists = [];
        });
        _titleController.clear();
        ref.read(uploadNotifierProvider.notifier).reset();
      } else if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

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
              isUploading: isUploading,
              coverFile: _selectedCoverFile,
              audioFile: _selectedAudioFile,
              audioFileName: _audioFileName,
              audioFileSize: _audioFileSize,
              audioDuration: _audioDuration,
              onCoverTap: _pickCover,
              onAudioTap: _pickAudio,
            ),
            const SizedBox(height: 24),
            if (uploadState.isLoading)
              UploadProgressWidget(progress: uploadState.progress),
            if (widget.initialAlbumId != null &&
                widget.initialAlbumId!.isNotEmpty &&
                _selectedAlbumId == int.tryParse(widget.initialAlbumId!)) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.album_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đang gán bài hát vào Album',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'Mã Album ID: #${widget.initialAlbumId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            UploadFormFields(
              titleController: _titleController,
              isUploading: isUploading,
              selectedCategory: _selectedCategory,
              categories: categories,
              onCategoryChanged: (val) =>
                  setState(() => _selectedCategory = val),
              selectedAlbumId: _selectedAlbumId,
              albums: albums,
              onAlbumChanged: (val) => setState(() => _selectedAlbumId = val),
              selectedCollabArtists: _selectedCollabArtists,
              onCollabArtistAdded: (artist) {
                if (!_selectedCollabArtists.any((a) => a.id == artist.id)) {
                  setState(() {
                    _selectedCollabArtists.add(artist);
                  });
                }
              },
              onCollabArtistRemoved: (artist) {
                setState(() {
                  _selectedCollabArtists.removeWhere((a) => a.id == artist.id);
                });
              },
              currentArtistId: currentArtistId,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isUploading ? null : _onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isValidatingAudio
                                ? 'ĐANG KIỂM TRA FILE...'
                                : 'ĐANG TẢI LÊN (${(uploadState.progress * 100).toInt()}%)...',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'TẢI LÊN & XUẤT BẢN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
