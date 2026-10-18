import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/models/category_detail_model.dart';
import '../providers/category_detail_provider.dart';
import '../widgets/category_detail_shimmer.dart';
import '../widgets/category_track_tile.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catId = int.tryParse(categoryId) ?? 1;
    final categoryAsync = ref.watch(categoryDetailProvider(catId));

    return categoryAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.search);
              }
            },
          ),
          title: const Text('Chi tiết Thể loại'),
          centerTitle: true,
        ),
        body: const CategoryDetailShimmer(),
      ),
      error: (error, _) => _buildError(context, ref, catId, error),
      data: (category) => _buildContent(context, ref, category),
    );
  }

  Widget _buildError(
    BuildContext context,
    WidgetRef ref,
    int catId,
    Object error,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.search);
            }
          },
        ),
        title: const Text('Chi tiết Thể loại'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 54, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'Không thể tải thể loại',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll('CategoryException: ', ''),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(categoryDetailProvider(catId).notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    CategoryDetailModel category,
  ) {
    final tracks = category.tracks;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.search);
            }
          },
        ),
        title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ thể loại',
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã sao chép liên kết thể loại: music4://category/${category.id}'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(categoryDetailProvider(category.id).notifier).refresh(),
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            _buildCategoryBanner(context, ref, category),
            const SizedBox(height: 24),
            if (tracks.isEmpty)
              _buildEmptyState(context, ref, category)
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Danh sách bài hát (${tracks.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ...tracks.asMap().entries.map((entry) {
                final index = entry.key;
                final track = entry.value;
                return CategoryTrackTile(
                  track: track,
                  index: index,
                  onTap: () => _playSingleTrack(context, ref, tracks, index),
                  onMorePressed: () =>
                      _showTrackOptions(context, ref, track, tracks, index),
                );
              }),
            ],
            const SizedBox(height: 36),
            _buildFooter(category),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBanner(
    BuildContext context,
    WidgetRef ref,
    CategoryDetailModel category,
  ) {
    final tracks = category.tracks;
    final gradientColors = _getCategoryGradient(category.id, category.name);

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.music_note_rounded,
                size: 80,
                color: Colors.white.withValues(alpha: 0.18),
              ),
              const Icon(
                Icons.queue_music_rounded,
                size: 56,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: const Text(
            'THỂ LOẠI NHẠC',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${tracks.length} bài hát • Phát hành trên Music4',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        if (tracks.isNotEmpty) ...[
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _playAllTracks(context, ref, tracks, shuffle: false);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Phát tất cả'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _playAllTracks(context, ref, tracks, shuffle: true);
                },
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Trộn bài'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    CategoryDetailModel category,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: const Icon(
              Icons.music_off_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chưa có bài hát nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Hiện tại chưa có bài hát nào thuộc thể loại "${category.name}".\nHãy khám phá thêm nhiều bài hát hấp dẫn khác nhé!',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(categoryDetailProvider(category.id).notifier).refresh();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Làm mới'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.search);
                  }
                },
                icon: const Icon(Icons.search, size: 18, color: Colors.black),
                label: const Text(
                  'Khám phá bài khác',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(CategoryDetailModel category) {
    return Center(
      child: Column(
        children: [
          Text(
            '© ${DateTime.now().year} Music4 Entertainment • Thể loại ${category.name}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            'Phát hành trên nền tảng Music4 Streaming',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<Color> _getCategoryGradient(int id, String name) {
    final List<List<Color>> palettes = [
      [const Color(0xFFE91E63), const Color(0xFF880E4F)], // Pop / Rose
      [const Color(0xFF7B1FA2), const Color(0xFF4A148C)], // Purple / EDM
      [const Color(0xFF1976D2), const Color(0xFF0D47A1)], // Blue / Ballad
      [const Color(0xFF00897B), const Color(0xFF004D40)], // Teal / Acoustic
      [const Color(0xFFF4511E), const Color(0xFFBF360C)], // Deep Orange / Rock
      [const Color(0xFFFB8C00), const Color(0xFFE65100)], // Orange / HipHop
      [const Color(0xFF43A047), const Color(0xFF1B5E20)], // Green / Indie
      [const Color(0xFF3949AB), const Color(0xFF1A237E)], // Indigo / Jazz
    ];
    final index = (id.abs() + name.length) % palettes.length;
    return palettes[index];
  }

  void _playAllTracks(
    BuildContext context,
    WidgetRef ref,
    List<CategoryTrackModel> tracks, {
    bool shuffle = false,
  }) {
    if (tracks.isEmpty) return;

    final playList = shuffle ? (List<CategoryTrackModel>.from(tracks)..shuffle()) : tracks;

    final queue = playList.map((t) {
      final artistNames = t.artists.isNotEmpty
          ? t.artists.map((a) => a.name).join(', ')
          : 'Nhiều nghệ sĩ';
      return TrackQueueItem(
        id: t.id.toString(),
        title: t.name,
        artist: artistNames,
        coverUrl: ApiEndpoints.buildImageUrl(t.img),
        duration: Duration(seconds: t.duration ?? 0),
      );
    }).toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, 0);
    context.push(RouteNames.player);
  }

  void _playSingleTrack(
    BuildContext context,
    WidgetRef ref,
    List<CategoryTrackModel> tracks,
    int index,
  ) {
    final queue = tracks.map((t) {
      final artistNames = t.artists.isNotEmpty
          ? t.artists.map((a) => a.name).join(', ')
          : 'Nhiều nghệ sĩ';
      return TrackQueueItem(
        id: t.id.toString(),
        title: t.name,
        artist: artistNames,
        coverUrl: ApiEndpoints.buildImageUrl(t.img),
        duration: Duration(seconds: t.duration ?? 0),
      );
    }).toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, index);
    context.push(RouteNames.player);
  }

  void _showTrackOptions(
    BuildContext context,
    WidgetRef ref,
    CategoryTrackModel track,
    List<CategoryTrackModel> allTracks,
    int index,
  ) {
    final artistNames = track.artists.isNotEmpty
        ? track.artists.map((a) => a.name).join(', ')
        : 'Nhiều nghệ sĩ';

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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: CachedNetworkImage(
                      imageUrl: ApiEndpoints.buildImageUrl(track.img),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.card,
                        child: const Icon(Icons.music_note, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  track.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  artistNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Phát bài này'),
                onTap: () {
                  modalContext.pop();
                  _playSingleTrack(context, ref, allTracks, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Xem chi tiết bài hát'),
                onTap: () {
                  modalContext.pop();
                  context.push(
                    RouteNames.trackDetail
                        .replaceAll(':id', track.id.toString()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Sao chép liên kết bài hát'),
                onTap: () {
                  modalContext.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã sao chép liên kết: music4://track/${track.id}'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
