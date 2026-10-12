import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/models/album_detail_model.dart';
import '../controllers/album_detail_controller.dart';
import '../widgets/album_detail_error_state.dart';
import '../widgets/album_detail_header.dart';
import '../widgets/album_detail_shimmer.dart';
import '../widgets/album_detail_track_tile.dart';

class AlbumDetailScreen extends ConsumerStatefulWidget {
  final String? albumId;
  const AlbumDetailScreen({super.key, this.albumId});

  @override
  ConsumerState<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends ConsumerState<AlbumDetailScreen> {
  int get _id => int.tryParse(widget.albumId ?? '1') ?? 1;

  void _showNotification(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _playAllTracks(List<AlbumTrackModel> tracks, String? albumCover, {bool shuffle = false}) {
    if (tracks.isEmpty) {
      _showNotification('Album này hiện chưa có bài hát nào để phát.');
      return;
    }

    final playList = shuffle ? (List<AlbumTrackModel>.from(tracks)..shuffle()) : tracks;

    final queue = playList.map((t) {
      return TrackQueueItem(
        id: t.id.toString(),
        title: t.name,
        artist: t.artistsDisplayText,
        coverUrl: ImageUrlHelper.resolve(t.img ?? albumCover),
        duration: Duration(seconds: t.duration),
      );
    }).toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, 0);
    context.push(RouteNames.player);
  }

  void _playSingleTrack(List<AlbumTrackModel> tracks, int index, String? albumCover) {
    final queue = tracks.map((t) {
      return TrackQueueItem(
        id: t.id.toString(),
        title: t.name,
        artist: t.artistsDisplayText,
        coverUrl: ImageUrlHelper.resolve(t.img ?? albumCover),
        duration: Duration(seconds: t.duration),
      );
    }).toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, index);
    context.push(RouteNames.player);
  }

  void _showTrackOptions(AlbumTrackModel track, List<AlbumTrackModel> allTracks, int index, String? albumCover) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(track.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(track.artistsDisplayText),
                trailing: const Icon(Icons.music_note, color: AppColors.primary),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Phát bài này'),
                onTap: () {
                  modalContext.pop();
                  _playSingleTrack(allTracks, index, albumCover);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Xem chi tiết bài hát'),
                onTap: () {
                  modalContext.pop();
                  context.push('/track/${track.id}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Sao chép liên kết bài hát'),
                onTap: () {
                  modalContext.pop();
                  _showNotification('Đã sao chép liên kết: music4://track/${track.id}');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final albumState = ref.watch(albumDetailControllerProvider(_id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi tiết Album'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ album',
            onPressed: () => _showNotification('Đã sao chép liên kết album: music4://album/$_id'),
          ),
        ],
      ),
      body: albumState.when(
        loading: () => const AlbumDetailShimmer(),
        error: (err, _) => AlbumDetailErrorState(
          message: err.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.read(albumDetailControllerProvider(_id).notifier).loadAlbumDetail(),
        ),
        data: (state) {
          final album = state.album;
          final tracks = album.tracks;
          final year = album.releaseYear;
          final durationText = album.formattedTotalDuration;

          final metadataParts = <String>['Album'];
          if (year.isNotEmpty) metadataParts.add(year);
          metadataParts.add('${tracks.length} bài hát');
          if (durationText.isNotEmpty) metadataParts.add(durationText);
          final metadata = metadataParts.join(' • ');

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            children: [
              AlbumDetailHeader(
                title: album.title,
                artist: album.artistName ?? 'Chưa rõ nghệ sĩ',
                metadata: metadata,
                imageUrl: album.coverUrl,
                isFavorite: state.isFavorite,
                onPlay: () => _playAllTracks(tracks, album.coverUrl, shuffle: false),
                onShuffle: () => _playAllTracks(tracks, album.coverUrl, shuffle: true),
                onToggleFavorite: () {
                  ref.read(albumDetailControllerProvider(_id).notifier).toggleFavorite();
                  _showNotification(
                    !state.isFavorite
                        ? 'Đã lưu album vào Thư viện yêu thích'
                        : 'Đã xóa album khỏi Thư viện',
                  );
                },
                onShare: () => _showNotification('Đã sao chép liên kết album: music4://album/$_id'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Danh sách bài hát (${tracks.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (tracks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text(
                      'Album này hiện chưa có bài hát nào.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...tracks.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final track = entry.value;
                    return AlbumDetailTrackTile(
                      trackNumber: index + 1,
                      title: track.name,
                      artist: track.artistsDisplayText,
                      duration: track.formattedDuration,
                      onTap: () => _playSingleTrack(tracks, index, album.coverUrl),
                      onMorePressed: () => _showTrackOptions(track, tracks, index, album.coverUrl),
                    );
                  },
                ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      '© ${year.isNotEmpty ? year : DateTime.now().year} ${album.artistName ?? "Music4 Entertainment"}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Phát hành trên nền tảng Music4 Streaming',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
