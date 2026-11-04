import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/models/artist_track_model.dart';
import '../providers/artist_tracks_provider.dart';
import '../widgets/edit_track_modal.dart';

class ArtistTrackManagementScreen extends ConsumerStatefulWidget {
  const ArtistTrackManagementScreen({super.key});

  @override
  ConsumerState<ArtistTrackManagementScreen> createState() => _ArtistTrackManagementScreenState();
}

class _ArtistTrackManagementScreenState extends ConsumerState<ArtistTrackManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // 'all', 'single', 'album'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(artistTracksNotifierProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _playTrack(ArtistTrackItemModel track, List<ArtistTrackItemModel> allTracks) {
    HapticFeedback.lightImpact();
    final queue = allTracks.map((t) {
      return TrackQueueItem(
        id: t.id.toString(),
        title: t.name,
        artist: t.artistNames.isNotEmpty ? t.artistNames.join(', ') : 'Chưa rõ nghệ sĩ',
        coverUrl: t.coverUrl,
        duration: Duration(seconds: t.duration),
      );
    }).toList();

    final index = allTracks.indexWhere((t) => t.id == track.id);
    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, index >= 0 ? index : 0);
    context.push(RouteNames.player);
  }

  Future<void> _handleDeleteTrack(ArtistTrackItemModel track) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa bài hát', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn xóa bài hát "${track.name}"?'),
            const SizedBox(height: 8),
            const Text(
              'Hành động này sẽ xóa bài hát vĩnh viễn khỏi hệ thống và các playlist của người nghe.',
              style: TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
        ),
        actionsOverflowButtonSpacing: 8,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            key: const Key('confirm_delete_track_btn'),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Xác nhận xóa', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(artistTracksNotifierProvider.notifier).deleteTrack(track.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xóa bài hát "${track.name}" thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          final cleanMsg = e.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa bài hát: $cleanMsg'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.music_note, size: 24, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isArtist = authState is AuthAuthenticated && authState.user.isArtist;

    if (!isArtist) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quản lý Bài hát'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: AppColors.textMuted),
                const SizedBox(height: 16),
                const Text(
                  'Chỉ dành cho Nghệ sĩ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trang Quản lý Bài hát chỉ dành riêng cho tài khoản Nghệ sĩ (Artist). Vui lòng đăng nhập tài khoản Nghệ sĩ để truy cập.',
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

    final tracksState = ref.watch(artistTracksNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Studio - Quản lý Bài hát'),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('track_mgmt_appbar_album_btn'),
            icon: const Icon(Icons.album_outlined, color: AppColors.textSecondary, size: 24),
            tooltip: 'Quản lý Album',
            onPressed: () async {
              await context.push(RouteNames.albumManagement);
              if (mounted) {
                ref.read(artistTracksNotifierProvider.notifier).refresh();
              }
            },
          ),
          IconButton(
            key: const Key('track_mgmt_appbar_upload_btn'),
            icon: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 26),
            tooltip: 'Tải lên bài hát mới',
            onPressed: () async {
              await context.push(RouteNames.upload);
              if (mounted) {
                ref.read(artistTracksNotifierProvider.notifier).refresh();
              }
            },
          ),
        ],
      ),
      body: tracksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(err.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(artistTracksNotifierProvider.notifier).refresh(),
                  child: const Text('Thử Lại'),
                ),
              ],
            ),
          ),
        ),
        data: (allTracks) {
          // Lọc danh sách theo query tìm kiếm và filter chip
          final filteredTracks = allTracks.where((track) {
            final matchesQuery = _searchQuery.isEmpty ||
                track.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (track.albumName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

            if (!matchesQuery) return false;

            if (_selectedFilter == 'single') return track.isSingle;
            if (_selectedFilter == 'album') return !track.isSingle;
            return true;
          }).toList();

          return Column(
            children: [
              // Thanh tìm kiếm và bộ lọc
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm bài hát của bạn...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: _selectedFilter == 'all',
                            label: Text('Tất cả (${allTracks.length})'),
                            onSelected: (_) => setState(() => _selectedFilter = 'all'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _selectedFilter == 'single',
                            label: Text('Single (${allTracks.where((t) => t.isSingle).length})'),
                            onSelected: (_) => setState(() => _selectedFilter = 'single'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _selectedFilter == 'album',
                            label: Text('Thuộc Album (${allTracks.where((t) => !t.isSingle).length})'),
                            onSelected: (_) => setState(() => _selectedFilter = 'album'),
                            selectedColor: AppColors.primary.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Danh sách bài hát
              Expanded(
                child: filteredTracks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.music_off_outlined, size: 64, color: AppColors.textMuted),
                              const SizedBox(height: 16),
                              Text(
                                allTracks.isEmpty ? 'Bạn chưa tải lên bài hát nào' : 'Không tìm thấy bài hát phù hợp',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                allTracks.isEmpty
                                    ? 'Hãy tải lên bài hát đầu tiên để bắt đầu sự nghiệp âm nhạc!'
                                    : 'Hãy thử tìm kiếm với từ khóa khác hoặc bỏ lọc.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                              ),
                              if (allTracks.isEmpty) ...[
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => context.push(RouteNames.upload),
                                  icon: const Icon(Icons.cloud_upload_outlined, color: Colors.black),
                                  label: const Text('Upload Bài Hát Mới', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.read(artistTracksNotifierProvider.notifier).refresh(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: filteredTracks.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final track = filteredTracks[index];
                            final cover = track.coverUrl;

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                              onTap: () => _playTrack(track, filteredTracks),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: cover != null
                                      ? Image.network(
                                          cover,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                                        )
                                      : _buildPlaceholder(),
                                ),
                              ),
                              title: Text(
                                track.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: track.isSingle
                                              ? Colors.blueAccent.withValues(alpha: 0.15)
                                              : AppColors.primary.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          track.isSingle ? 'Single' : 'Album: ${track.albumName}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: track.isSingle ? Colors.blueAccent : AppColors.primary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.remove_red_eye_outlined, size: 12, color: AppColors.textSecondary),
                                          const SizedBox(width: 3),
                                          Text(
                                            track.formattedViews,
                                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                                          const SizedBox(width: 3),
                                          Text(
                                            track.formattedDuration,
                                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                onSelected: (action) async {
                                  if (action == 'play') {
                                    _playTrack(track, filteredTracks);
                                  } else if (action == 'detail') {
                                    await context.push('/track/${track.id}');
                                    if (mounted) {
                                      ref.read(artistTracksNotifierProvider.notifier).refresh();
                                    }
                                  } else if (action == 'edit') {
                                    await EditTrackModal.show(
                                      context,
                                      trackId: track.id,
                                      initialTitle: track.name,
                                      initialAlbumName: track.albumName,
                                      initialCoverUrl: track.rawImg,
                                      initialCategoryIds: track.categoryIds,
                                    );
                                    if (mounted) {
                                      ref.read(artistTracksNotifierProvider.notifier).refresh();
                                    }
                                  } else if (action == 'delete') {
                                    _handleDeleteTrack(track);
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                    value: 'play',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.play_circle_outline, color: AppColors.primary, size: 20),
                                        SizedBox(width: 10),
                                        Flexible(child: Text('Phát nhạc')),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.info_outline, size: 20),
                                        SizedBox(width: 10),
                                        Flexible(child: Text('Chi tiết')),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                                        SizedBox(width: 10),
                                        Flexible(child: Text('Sửa bài hát')),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                        SizedBox(width: 10),
                                        Flexible(child: Text('Xóa bài hát', style: TextStyle(color: Colors.redAccent))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('track_mgmt_fab_upload'),
        onPressed: () => context.push(RouteNames.upload),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.cloud_upload_outlined),
        label: const Text('Upload Nhạc Mới', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
