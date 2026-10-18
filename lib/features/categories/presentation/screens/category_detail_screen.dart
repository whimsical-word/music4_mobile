import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/router/route_names.dart';
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

    return Scaffold(
      body: categoryAsync.when(
        loading: () => const CategoryDetailShimmer(),
        error: (error, _) => _buildError(context, ref, catId, error),
        data: (category) => _buildContent(context, ref, category),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    WidgetRef ref,
    int catId,
    Object error,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Thể loại')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(error.toString(), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(categoryDetailProvider(catId).notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
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
    final theme = Theme.of(context);
    final tracks = category.tracks;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),
        ),
        if (tracks.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Chưa có bài hát nào trong thể loại này.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '${tracks.length} bài hát',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _playTrack(context, ref, tracks, 0),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Phát tất cả'),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final track = tracks[index];
                return CategoryTrackTile(
                  track: track,
                  index: index,
                  onTap: () => _playTrack(context, ref, tracks, index),
                );
              },
              childCount: tracks.length,
            ),
          ),
        ],
      ],
    );
  }

  void _playTrack(
    BuildContext context,
    WidgetRef ref,
    List<CategoryTrackModel> tracks,
    int index,
  ) {
    final playlist = tracks
        .map(
          (t) => TrackQueueItem(
            id: t.id.toString(),
            title: t.name,
            artist: t.artists.isNotEmpty
                ? t.artists.map((a) => a.name).join(', ')
                : 'Nhiều nghệ sĩ',
            coverUrl: ApiEndpoints.buildImageUrl(t.img),
            duration: Duration(seconds: t.duration ?? 0),
          ),
        )
        .toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(playlist, index);
    context.push(RouteNames.player);
  }
}
