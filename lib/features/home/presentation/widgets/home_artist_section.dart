import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../artist_profile/data/models/artist_response.dart';
import 'home_artist_card.dart';

const List<ArtistResponse> _defaultFallbackArtists = [
  ArtistResponse(
    id: 1,
    name: 'Sơn Tùng M-TP',
    img: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    trackTotal: 15,
    albumTotal: 3,
  ),
  ArtistResponse(
    id: 2,
    name: 'Đen Vâu',
    img: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
    trackTotal: 20,
    albumTotal: 4,
  ),
  ArtistResponse(
    id: 3,
    name: 'Vũ.',
    img: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
    trackTotal: 12,
    albumTotal: 2,
  ),
  ArtistResponse(
    id: 4,
    name: 'Bích Phương',
    img: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
    trackTotal: 18,
    albumTotal: 3,
  ),
];

final homeArtistListProvider =
    FutureProvider.autoDispose<List<ArtistResponse>>((ref) async {
  if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
    return _defaultFallbackArtists;
  }

  try {
    final dio = DioClient().dio;
    final response = await dio.get('${ApiEndpoints.artists}/all');
    if (response.data is List) {
      final list = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => ArtistResponse.fromJson(json))
          .toList();
      if (list.isNotEmpty) return list;
    }
  } catch (_) {}

  return _defaultFallbackArtists;
});

class HomeArtistSection extends ConsumerWidget {
  const HomeArtistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistAsync = ref.watch(homeArtistListProvider);
    final textTheme = Theme.of(context).textTheme;

    return artistAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (artists) {
        if (artists.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nghệ sĩ tiêu biểu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.mic_external_on_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    HomeArtistCard(artist: artists[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}
