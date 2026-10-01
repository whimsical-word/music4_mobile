import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../providers/player_provider.dart';
import '../../../../core/widgets/app_network_image.dart';

class MiniPlayerWidget extends ConsumerWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerStateAsync = ref.watch(playerNotifierProvider);

    return playerStateAsync.maybeWhen(
      data: (state) {
        if (state.currentTrackId == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => context.push(RouteNames.player),
          child: Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: state.coverUrl != null && state.coverUrl!.isNotEmpty
                        ? AppNetworkImage(
                            imageUrl: state.coverUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(Icons.music_note, color: AppColors.primary),
                            ),
                          ),
                  ),
                ),
                // Track Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        state.artist,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Play/Pause Button
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    final notifier = ref.read(playerNotifierProvider.notifier);
                    state.isPlaying ? notifier.pause() : notifier.play();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
