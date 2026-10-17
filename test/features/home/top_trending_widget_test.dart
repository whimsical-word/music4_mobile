import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:go_router/go_router.dart';
import 'package:music4_mobile/core/router/route_names.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/home/data/models/home_track_item.dart';
import 'package:music4_mobile/features/home/presentation/widgets/trending_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/trending_track_tile.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}
class MockAppAudioHandler extends Mock implements AppAudioHandler {}
class MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

AudioPlayer createMockAudioPlayer() {
  final mock = MockAudioPlayer();
  when(() => mock.playerStateStream).thenAnswer((_) => Stream.empty());
  when(() => mock.positionStream).thenAnswer((_) => Stream.empty());
  when(() => mock.bufferedPositionStream).thenAnswer((_) => Stream.empty());
  when(() => mock.durationStream).thenAnswer((_) => Stream.empty());
  when(() => mock.playbackEventStream).thenAnswer((_) => Stream.empty());
  return mock;
}

class MockPlayerNotifier extends PlayerNotifier {
  List<TrackQueueItem>? lastPlayedPlaylist;
  int? lastPlayedIndex;

  MockPlayerNotifier()
      : super(
          createMockAudioPlayer(),
          MockTrackDetailRepo(),
          MockAppAudioHandler(),
        );

  @override
  Future<void> playPlaylist(List<TrackQueueItem> tracks, int startIndex) async {
    lastPlayedPlaylist = tracks;
    lastPlayedIndex = startIndex;
  }
}

void main() {
  late MockPlayerNotifier mockPlayerNotifier;

  setUp(() {
    mockPlayerNotifier = MockPlayerNotifier();
  });

  final sampleTracks = List.generate(
    7,
    (index) => HomeTrackItem(
      id: 'track_${index + 1}',
      title: 'Trending Hit #${index + 1}',
      artist: 'Artist ${index + 1}',
      artistId: 'art_${index + 1}',
      duration: '3:30',
      durationSeconds: 210,
      playsCount: '${(index + 1) * 10}K',
    ),
  );

  Widget createWidget({required List<HomeTrackItem> tracks}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: TrendingSection(tracks: tracks),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.player,
          builder: (context, state) => const Scaffold(body: Text('PlayerScreen')),
        ),
        GoRoute(
          path: '/track/:id',
          builder: (context, state) => const Scaffold(body: Text('TrackDetailScreen')),
        ),
        GoRoute(
          path: '/artist/:id',
          builder: (context, state) => const Scaffold(body: Text('ArtistProfileScreen')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        playerNotifierProvider.overrideWith((ref) => mockPlayerNotifier),
      ],
      child: MaterialApp.router(
        theme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }

  group('[CE190036] UC52 Top 5 Trending Tracks Display & Interaction', () {
    testWidgets('TrendingSection renders header, Top 5 badge and exactly 5 items when given >5 items', (tester) async {
      await tester.pumpWidget(createWidget(tracks: sampleTracks));
      await tester.pumpAndSettle();

      // Verify Header and Top 5 badge
      expect(find.text('Thịnh hành'), findsOneWidget);
      expect(find.text('Top 5'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

      // Verify at most 5 TrendingTrackTiles are rendered
      expect(find.byType(TrendingTrackTile), findsNWidgets(5));

      // Verify top 5 tracks are visible
      expect(find.text('Trending Hit #1'), findsOneWidget);
      expect(find.text('Trending Hit #2'), findsOneWidget);
      expect(find.text('Trending Hit #3'), findsOneWidget);
      expect(find.text('Trending Hit #4'), findsOneWidget);
      expect(find.text('Trending Hit #5'), findsOneWidget);

      // #6 and #7 must NOT be in the Top 5
      expect(find.text('Trending Hit #6'), findsNothing);
      expect(find.text('Trending Hit #7'), findsNothing);
    });

    testWidgets('TrendingTrackTile shows correct ranks, artist, and views count', (tester) async {
      await tester.pumpWidget(createWidget(tracks: sampleTracks.sublist(0, 3)));
      await tester.pumpAndSettle();

      // Check Rank numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Check Artist name and Views count
      expect(find.text('Artist 1'), findsOneWidget);
      expect(find.text(' • 10K lượt nghe'), findsOneWidget);
      expect(find.text('Artist 2'), findsOneWidget);
      expect(find.text(' • 20K lượt nghe'), findsOneWidget);
    });

    testWidgets('Tapping play button triggers playPlaylist on player provider', (tester) async {
      await tester.pumpWidget(createWidget(tracks: sampleTracks.sublist(0, 5)));
      await tester.pumpAndSettle();

      final playButtons = find.byTooltip('Phát bài hát');
      expect(playButtons, findsNWidgets(5));

      // Tap on second track's play button
      await tester.tap(playButtons.at(1));
      await tester.pump();

      expect(mockPlayerNotifier.lastPlayedPlaylist, isNotNull);
      expect(mockPlayerNotifier.lastPlayedPlaylist!.length, 5);
      expect(mockPlayerNotifier.lastPlayedIndex, 1);
      expect(mockPlayerNotifier.lastPlayedPlaylist![1].title, 'Trending Hit #2');
    });

    testWidgets('Tapping popup menu button opens options including Chi tiết bài hát and Trang nghệ sĩ', (tester) async {
      await tester.pumpWidget(createWidget(tracks: sampleTracks.sublist(0, 1)));
      await tester.pumpAndSettle();

      final moreButtons = find.byTooltip('Tùy chọn');
      expect(moreButtons, findsOneWidget);

      await tester.tap(moreButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Chi tiết bài hát'), findsOneWidget);
      expect(find.text('Trang nghệ sĩ'), findsOneWidget);
    });

    testWidgets('TrendingSection returns SizedBox.shrink when tracks list is empty', (tester) async {
      await tester.pumpWidget(createWidget(tracks: []));
      await tester.pumpAndSettle();

      expect(find.text('Thịnh hành'), findsNothing);
      expect(find.byType(TrendingTrackTile), findsNothing);
    });
  });
}
