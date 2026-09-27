import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteTrack {
  final String id;
  final String title;
  final String artist;
  final String artworkUrl;
  final String duration;
  final DateTime addedAt;

  FavoriteTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.artworkUrl,
    required this.duration,
    required this.addedAt,
  });
}

class FavoritesNotifier extends AsyncNotifier<List<FavoriteTrack>> {
  @override
  Future<List<FavoriteTrack>> build() async {
    return _fetchFavorites();
  }

  Future<List<FavoriteTrack>> _fetchFavorites() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate mock data
    return List.generate(
      10,
      (index) => FavoriteTrack(
        id: 'track_${index + 1}',
        title: 'Bài hát yêu thích ${index + 1}',
        artist: 'Nghệ sĩ ${index % 3 + 1}',
        artworkUrl: 'mock_artwork', // We'll just use a placeholder icon in UI
        duration: '3:${(index * 15 % 60).toString().padLeft(2, '0')}',
        addedAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    try {
      final data = await _fetchFavorites();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleFavorite(String id) async {
    // In a real app, this would call an API.
    // Here we just remove it from the list.
    if (state.value != null) {
      final currentList = state.value!;
      state = AsyncValue.data(
        currentList.where((track) => track.id != id).toList(),
      );
    }
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<FavoriteTrack>>(
  () => FavoritesNotifier(),
);
