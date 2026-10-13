import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../album/data/models/album_model.dart';
import '../../../album/data/repositories/album_repository.dart';
import 'home_album_card.dart';

final homeAlbumListProvider = FutureProvider.autoDispose<List<AlbumModel>>((ref) async {
  final repo = ref.watch(albumRepositoryProvider);
  try {
    final list = await repo.getAlbums();
    if (list.isNotEmpty) return list;
  } catch (_) {}
  return [
    AlbumModel(
      id: '1',
      title: 'Tuyển Tập Sơn Tùng M-TP',
      coverUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=300',
      artistId: '1',
      artistName: 'Sơn Tùng M-TP',
      releaseDate: DateTime(2024, 6, 1),
      trackCount: 8,
    ),
    AlbumModel(
      id: '2',
      title: 'Chúng Ta Của Tương Lai',
      coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=300',
      artistId: '1',
      artistName: 'Sơn Tùng M-TP',
      releaseDate: DateTime(2024, 3, 8),
      trackCount: 4,
    ),
    AlbumModel(
      id: '3',
      title: 'Sky Tour 2024',
      coverUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300',
      artistId: '1',
      artistName: 'Sơn Tùng M-TP',
      releaseDate: DateTime(2023, 11, 15),
      trackCount: 12,
    ),
  ];
});

class HomeAlbumSection extends ConsumerWidget {
  const HomeAlbumSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumAsync = ref.watch(homeAlbumListProvider);
    final textTheme = Theme.of(context).textTheme;

    return albumAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (albums) {
        if (albums.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Album nổi bật',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(Icons.album_outlined, color: AppColors.primary, size: 20),
                ],
              ),
            ),
            SizedBox(
              height: 172,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => HomeAlbumCard(album: albums[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}
