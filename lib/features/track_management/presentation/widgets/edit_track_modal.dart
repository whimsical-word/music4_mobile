import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../album/presentation/providers/album_provider.dart';
import '../../../upload/presentation/providers/categories_provider.dart';
import '../../../upload/presentation/widgets/image_crop_dialog.dart';
import '../providers/artist_tracks_provider.dart';

class EditTrackModal extends ConsumerStatefulWidget {
  final int trackId;
  final String initialTitle;
  final int? initialAlbumId;
  final String? initialAlbumName;
  final String? initialCoverUrl;
  final List<int> initialCategoryIds;
  final VoidCallback? onSuccess;

  const EditTrackModal({
    super.key,
    required this.trackId,
    required this.initialTitle,
    this.initialAlbumId,
    this.initialAlbumName,
    this.initialCoverUrl,
    this.initialCategoryIds = const [],
    this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required int trackId,
    required String initialTitle,
    int? initialAlbumId,
    String? initialAlbumName,
    String? initialCoverUrl,
    List<int> initialCategoryIds = const [],
    VoidCallback? onSuccess,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => EditTrackModal(
        trackId: trackId,
        initialTitle: initialTitle,
        initialAlbumId: initialAlbumId,
        initialAlbumName: initialAlbumName,
        initialCoverUrl: initialCoverUrl,
        initialCategoryIds: initialCategoryIds,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<EditTrackModal> createState() => _EditTrackModalState();
}

class _EditTrackModalState extends ConsumerState<EditTrackModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  File? _newCoverFile;
  late int? _selectedAlbumId;
  final Set<int> _selectedCategoryIds = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _selectedAlbumId = widget.initialAlbumId;
    _selectedCategoryIds.addAll(widget.initialCategoryIds);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
            SnackBar(content: Text('Định dạng ảnh .$ext không hợp lệ! Chỉ chấp nhận JPG, JPEG, PNG, WEBP.')),
          );
        }
        return;
      }

      if (!mounted) return;
      final croppedFile = await ImageCropDialog.show(context, File(path));
      if (croppedFile != null && mounted) {
        setState(() {
          _newCoverFile = croppedFile;
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất 1 thể loại cho bài hát!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(artistTracksNotifierProvider.notifier).updateTrackMetadata(
            trackId: widget.trackId,
            title: _titleController.text.trim(),
            albumId: _selectedAlbumId ?? -1,
            categoryIds: _selectedCategoryIds.toList(),
            coverImageFile: _newCoverFile,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin bài hát thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        final cleanMsg = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật thất bại: $cleanMsg'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final categoriesAsync = ref.watch(categoriesProvider);
    final albumsAsync = ref.watch(albumNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chỉnh sửa bài hát',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 16),
              const SizedBox(height: 12),

              // Ảnh bìa
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 120,
                        height: 120,
                        color: AppColors.surface,
                        child: _newCoverFile != null
                            ? Image.file(_newCoverFile!, fit: BoxFit.cover)
                            : (widget.initialCoverUrl != null
                                ? Image.network(
                                    ImageUrlHelper.resolve(widget.initialCoverUrl) ?? widget.initialCoverUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Icon(Icons.music_note, size: 48, color: AppColors.primary),
                                  )
                                : const Icon(Icons.music_note, size: 48, color: AppColors.primary)),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: InkWell(
                        key: const Key('edit_track_pick_cover_btn'),
                        onTap: _pickCover,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tên bài hát
              const Text('Tên bài hát *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('edit_track_title_field'),
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên bài hát',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Tên bài hát không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gán / Thay đổi Album
              const Text('Thuộc Album', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              albumsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const Text('Không thể tải danh sách album', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                data: (albums) {
                  return DropdownButtonFormField<int?>(
                    key: const Key('edit_track_album_dropdown'),
                    initialValue: _selectedAlbumId,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Single (Không thuộc Album nào)'),
                      ),
                      ...albums.map(
                        (alb) => DropdownMenuItem<int?>(
                          value: int.tryParse(alb.id),
                          child: Text(alb.title, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedAlbumId = val;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Thể loại (Categories)
              const Text('Thể loại (chọn ít nhất 1) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              categoriesAsync.when(
                loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                error: (_, _) => const Text('Không thể tải thể loại', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                data: (categories) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: categories.map((cat) {
                      final isSelected = _selectedCategoryIds.contains(cat.id);
                      return FilterChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(alpha: 0.25),
                        checkmarkColor: AppColors.primary,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategoryIds.add(cat.id);
                            } else {
                              if (_selectedCategoryIds.length > 1) {
                                _selectedCategoryIds.remove(cat.id);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      key: const Key('edit_track_submit_btn'),
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                            )
                          : const Text('Lưu Thay Đổi', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
