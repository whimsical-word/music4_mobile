import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/artist.dart';
import '../../domain/models/artist_profile_data.dart';
import '../../domain/models/track.dart';

class ArtistProfileNotifier extends AutoDisposeAsyncNotifier<ArtistProfileData> {
  @override
  FutureOr<ArtistProfileData> build() async {
    return _fetchArtistData();
  }

  Future<ArtistProfileData> _fetchArtistData() async {
    // Giả lập delay mạng
    await Future.delayed(const Duration(seconds: 1));

    // Dữ liệu mock
    final mockArtist = Artist(
      id: 'a1',
      name: 'Ngọt',
      bio: 'Ban nhạc Indie Pop hàng đầu Việt Nam.',
      avatarUrl: 'https://example.com/avatar.jpg', // Có thể dùng placeholder Icon ở UI
      coverUrl: 'https://example.com/cover.jpg',
      followersCount: 154000,
    );

    final mockTracks = [
      Track(
        id: 't1',
        title: 'Lần Cuối',
        artistName: 'Ngọt',
        artworkUrl: 'https://example.com/art1.jpg',
        durationSeconds: 215,
      ),
      Track(
        id: 't2',
        title: 'Cho Tôi Đi Theo',
        artistName: 'Ngọt',
        artworkUrl: 'https://example.com/art2.jpg',
        durationSeconds: 198,
      ),
      Track(
        id: 't3',
        title: 'Em Dạo Này',
        artistName: 'Ngọt',
        artworkUrl: 'https://example.com/art3.jpg',
        durationSeconds: 185,
      ),
      Track(
        id: 't4',
        title: 'Xanh',
        artistName: 'Ngọt',
        artworkUrl: 'https://example.com/art4.jpg',
        durationSeconds: 240,
      ),
    ];

    return ArtistProfileData(
      artist: mockArtist,
      popularTracks: mockTracks,
      isFollowing: false,
    );
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchArtistData());
  }

  Future<void> toggleFollow() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // Cập nhật UI ngay lập tức (Optimistic Update cho bài này)
    state = AsyncValue.data(
      currentState.copyWith(isFollowing: !currentState.isFollowing),
    );
    
    // Nếu có API thật, sẽ gọi API ở đây.
  }
}

final artistProfileProvider =
    AutoDisposeAsyncNotifierProvider<ArtistProfileNotifier, ArtistProfileData>(
  () => ArtistProfileNotifier(),
);
