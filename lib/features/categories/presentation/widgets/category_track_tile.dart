import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../data/models/category_detail_model.dart';

class CategoryTrackTile extends StatelessWidget {
  final CategoryTrackModel track;
  final int index;
  final VoidCallback onTap;

  const CategoryTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artistNames = track.artists.isNotEmpty
        ? track.artists.map((a) => a.name).join(', ')
        : 'Nhiều nghệ sĩ';

    final durationSec = track.duration ?? 0;
    final minutes = durationSec ~/ 60;
    final seconds = (durationSec % 60).toString().padLeft(2, '0');
    final formattedDuration = '$minutes:$seconds';

    final imgUrl = ApiEndpoints.buildImageUrl(track.img);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          height: 50,
          child: imgUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _placeholder(theme),
                )
              : _placeholder(theme),
        ),
      ),
      title: Text(
        track.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        artistNames,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formattedDuration,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.music_note, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}
