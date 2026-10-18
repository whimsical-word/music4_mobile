import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../home/presentation/controllers/home_feed_controller.dart'
    show homeFeedControllerProvider;
import '../../application/playback_tracker.dart';
import '../../data/tracking_repository.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>(
  (ref) => TrackingRepository(ref.read(dioClientProvider)),
);

final playbackTrackerProvider = Provider<PlaybackTracker>((ref) {
  return PlaybackTracker(
    repository: ref.watch(trackingRepositoryProvider),
    // Only a signed-in listener is tracked (guest / artist -> null).
    resolveListenerId: () {
      final auth = ref.read(authNotifierProvider);
      if (auth is AuthAuthenticated && !auth.user.isArtist) {
        return auth.user.id;
      }
      return null;
    },
    // Listening finished -> refresh the Home feed silently (no shimmer).
    onTrackCompleted: () {
      if (ref.exists(homeFeedControllerProvider)) {
        unawaited(
          ref.read(homeFeedControllerProvider.notifier).silentRefresh(),
        );
      }
    },
  );
});
