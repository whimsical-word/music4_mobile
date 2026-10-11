import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../home/data/models/track_detail_model.dart';
import '../../data/mappers/artist_profile_mapper.dart';
import '../../data/models/artist_response.dart';
import '../../data/repositories/artist_profile_repository.dart';
import '../../domain/models/artist_profile_data.dart';

final artistProfileRepositoryProvider = Provider<ArtistProfileRepository>((
  ref,
) {
  return ArtistProfileRepository(ref.read(dioClientProvider));
});

/// Family key of the profile provider: which artist, and whether the owner's
/// dashboard (analytics) must be loaded.
class ArtistProfileParams {
  final String? artistId;
  final bool isOwner;

  const ArtistProfileParams({required this.artistId, this.isOwner = false});

  @override
  bool operator ==(Object other) =>
      other is ArtistProfileParams &&
      other.artistId == artistId &&
      other.isOwner == isOwner;

  @override
  int get hashCode => Object.hash(artistId, isOwner);
}

enum FollowResult { success, needsLogin, failed }

class ArtistProfileNotifier
    extends AutoDisposeFamilyAsyncNotifier<ArtistProfileData, ArtistProfileParams> {
  @override
  Future<ArtistProfileData> build(ArtistProfileParams arg) => _fetchArtistData();

  int? get _artistId => int.tryParse(arg.artistId ?? '');

  int? get _currentUserId {
    final auth = ref.read(authNotifierProvider);
    return auth is AuthAuthenticated ? auth.user.id : null;
  }

  Future<ArtistProfileData> _fetchArtistData() async {
    final artistId = _artistId;
    if (artistId == null) {
      throw const ArtistProfileException('Không tìm thấy nghệ sĩ.');
    }

    final repository = ref.read(artistProfileRepositoryProvider);
    final userId = _currentUserId;

    // Optional parts never fail the whole screen.
    final overviewFuture = _orNull(repository.getOverview(artistId));
    final followingFuture = userId == null
        ? Future<bool?>.value(false)
        : _orNull(repository.isFollowing(userId: userId, artistId: artistId));

    // Required parts, requested in parallel. Future.wait observes every future,
    // so one failure never leaves another as an unhandled error.
    final results = await Future.wait<Object>([
      repository.getArtist(artistId),
      repository.getArtistTracks(artistId),
      repository.getArtistAlbums(artistId),
    ]);
    final artist = results[0] as ArtistResponse;
    final tracks = results[1] as List<TrackDetailModel>;
    final albums = results[2] as List<AlbumInfo>;

    final overview = await overviewFuture;
    final isFollowing = await followingFuture;

    return ArtistProfileData(
      artist: ArtistProfileMapper.toArtist(
        artist,
        followersCount: overview?.totalFollowers,
      ),
      popularTracks: ArtistProfileMapper.toPopularTracks(
        tracks,
        fallbackArtistName: artist.name,
      ),
      albums: ArtistProfileMapper.toAlbums(albums),
      isFollowing: isFollowing ?? false,
      dashboardStats: arg.isOwner && overview != null
          ? ArtistProfileMapper.toDashboardStats(overview)
          : null,
    );
  }

  Future<T?> _orNull<T>(Future<T> future) async {
    try {
      return await future;
    } catch (_) {
      return null;
    }
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchArtistData);
  }

  /// Follows / unfollows through the backend. The UI shows a message for
  /// [FollowResult.needsLogin] and [FollowResult.failed].
  Future<FollowResult> toggleFollow() async {
    final artistId = _artistId;
    final current = state.valueOrNull;
    if (artistId == null || current == null) return FollowResult.failed;

    final userId = _currentUserId;
    if (userId == null) return FollowResult.needsLogin;

    try {
      final following = await ref
          .read(artistProfileRepositoryProvider)
          .toggleFollow(userId: userId, artistId: artistId);

      final latest = state.valueOrNull ?? current;
      final count = latest.artist.followersCount;
      state = AsyncValue.data(
        latest.copyWith(
          isFollowing: following,
          artist: count == null
              ? latest.artist
              : latest.artist.copyWith(
                  followersCount: math.max(0, count + (following ? 1 : -1)),
                ),
        ),
      );
      return FollowResult.success;
    } catch (_) {
      return FollowResult.failed;
    }
  }
}

final artistProfileProvider = AsyncNotifierProvider.autoDispose
    .family<ArtistProfileNotifier, ArtistProfileData, ArtistProfileParams>(
      ArtistProfileNotifier.new,
    );
