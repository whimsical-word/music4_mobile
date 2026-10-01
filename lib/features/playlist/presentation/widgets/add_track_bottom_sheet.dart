import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/playlist_track_model.dart';

class AddTrackBottomSheet extends StatefulWidget {
  final List<PlaylistTrackModel> tracks;
  final ValueChanged<PlaylistTrackModel> onTrackAdded;

  const AddTrackBottomSheet({
    super.key,
    required this.tracks,
    required this.onTrackAdded,
  });

  static void show(
    BuildContext context, {
    required List<PlaylistTrackModel> tracks,
    required ValueChanged<PlaylistTrackModel> onAdded,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => AddTrackBottomSheet(
        tracks: tracks,
        onTrackAdded: onAdded,
      ),
    );
  }

  @override
  State<AddTrackBottomSheet> createState() => _AddTrackBottomSheetState();
}

class _AddTrackBottomSheetState extends State<AddTrackBottomSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filteredTracks = query.isEmpty
        ? widget.tracks
        : widget.tracks.where((t) {
            return t.name.toLowerCase().contains(query) ||
                t.artistNames.toLowerCase().contains(query);
          }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm bài hát (${filteredTracks.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên bài hát hoặc nghệ sĩ...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            const Divider(color: AppColors.divider),
            if (filteredTracks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'Không tìm thấy bài hát nào',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredTracks.length,
                    itemBuilder: (context, index) {
                      final track = filteredTracks[index];
                      return ListTile(
                        leading: const Icon(Icons.music_note, color: AppColors.primary),
                        title: Text(
                          track.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${track.artistNames} • ${track.formattedDuration}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle, color: AppColors.primary),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            widget.onTrackAdded(track);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
