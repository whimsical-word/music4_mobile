import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../data/repositories/album_repository.dart';
import '../controllers/album_detail_controller.dart';
import '../providers/album_provider.dart';

Future<bool?> showExistingTracksPickerBottomSheet(
  BuildContext context, {
  required int albumId,
  required String albumTitle,
  required int artistId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ExistingTracksPickerBottomSheet(
      albumId: albumId,
      albumTitle: albumTitle,
      artistId: artistId,
    ),
  );
}

class ExistingTracksPickerBottomSheet extends ConsumerStatefulWidget {
  final int albumId;
  final String albumTitle;
  final int artistId;

  const ExistingTracksPickerBottomSheet({
    super.key,
    required this.albumId,
    required this.albumTitle,
    required this.artistId,
  });

  @override
  ConsumerState<ExistingTracksPickerBottomSheet> createState() =>
      _ExistingTracksPickerBottomSheetState();
}

class _ExistingTracksPickerBottomSheetState
    extends ConsumerState<ExistingTracksPickerBottomSheet> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _tracks = [];
  final Set<int> _selectedTrackIds = {};
  final Set<int> _alreadyInAlbumTrackIds = {};

  @override
  void initState() {
    super.initState();
    _loadArtistTracks();
  }

  Future<void> _loadArtistTracks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(albumRepositoryProvider);
      final tracks = await repo.getArtistTracks(widget.artistId);

      final alreadyIn = <int>{};
      for (final t in tracks) {
        final albumName = t['albumName']?.toString();
        final id = t['id'] is int ? t['id'] as int : int.tryParse(t['id'].toString());
        if (id != null && albumName != null && albumName == widget.albumTitle) {
          alreadyIn.add(id);
        }
      }

      if (mounted) {
        setState(() {
          _tracks = tracks;
          _alreadyInAlbumTrackIds.addAll(alreadyIn);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onConfirm() async {
    if (_selectedTrackIds.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(albumRepositoryProvider);
      for (final trackId in _selectedTrackIds) {
        await repo.assignTrackToAlbum(
          trackId: trackId,
          albumId: widget.albumId,
        );
      }

      // Refresh lại AlbumDetail và AlbumNotifier
      ref.invalidate(albumDetailControllerProvider(widget.albumId));
      ref.invalidate(albumNotifierProvider);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã thêm ${_selectedTrackIds.length} bài hát vào "${widget.albumTitle}" thành công!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final cleanMsg = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi gán bài hát: $cleanMsg'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  String _formatDuration(dynamic durationVal) {
    if (durationVal == null) return '0:00';
    final secs = durationVal is int ? durationVal : int.tryParse(durationVal.toString()) ?? 0;
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSheetHeight = mediaQuery.size.height * 0.75;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: EdgeInsets.fromLTRB(20, 20, 20, mediaQuery.viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thêm bài hát có sẵn',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chọn bài hát của bạn để gán vào "${widget.albumTitle}"',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 24),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                  const SizedBox(height: 12),
                  Text(_errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadArtistTracks,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          else if (_tracks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.music_off_outlined, color: AppColors.textMuted, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'Bạn chưa phát hành bài hát nào.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hãy tải lên bài hát mới trước khi thêm vào Album!',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _tracks.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final track = _tracks[index];
                  final id = track['id'] is int
                      ? track['id'] as int
                      : int.tryParse(track['id'].toString()) ?? 0;
                  final title = track['name']?.toString() ?? 'Chưa đặt tên';
                  final duration = _formatDuration(track['duration']);
                  final coverUrl = ImageUrlHelper.resolve(track['img']?.toString());
                  final albumName = track['albumName']?.toString() ?? 'Single';
                  final isAlreadyIn = _alreadyInAlbumTrackIds.contains(id);
                  final isSelected = _selectedTrackIds.contains(id);

                  return CheckboxListTile(
                    value: isAlreadyIn ? true : isSelected,
                    enabled: !_isSubmitting && !isAlreadyIn,
                    onChanged: isAlreadyIn
                        ? null
                        : (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedTrackIds.add(id);
                              } else {
                                _selectedTrackIds.remove(id);
                              }
                            });
                          },
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isAlreadyIn ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          duration,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isAlreadyIn
                                ? Colors.grey.withValues(alpha: 0.2)
                                : AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isAlreadyIn ? 'Đã trong Album này' : albumName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAlreadyIn ? Colors.grey : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondary: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 44,
                        height: 44,
                        color: AppColors.surface,
                        child: coverUrl != null
                            ? Image.network(
                                coverUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.music_note,
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(Icons.music_note, color: AppColors.primary),
                      ),
                    ),
                    activeColor: AppColors.primary,
                    checkColor: Colors.black,
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  key: const Key('confirm_assign_tracks_btn'),
                  onPressed: (_isSubmitting || _selectedTrackIds.isEmpty) ? null : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : Text(
                          _selectedTrackIds.isEmpty
                              ? 'Chọn bài hát'
                              : 'Gán vào Album (${_selectedTrackIds.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
