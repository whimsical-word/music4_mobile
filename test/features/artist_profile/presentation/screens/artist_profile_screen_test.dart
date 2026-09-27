import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/artist.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/artist_profile_data.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/track.dart';
import 'package:music4_mobile/features/artist_profile/presentation/providers/artist_profile_provider.dart';
import 'package:music4_mobile/features/artist_profile/presentation/screens/artist_profile_screen.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_profile_shimmer.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/track_list_item.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_header.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_dashboard.dart';
import 'package:shimmer/shimmer.dart';

// Mock Notifier để tiêm state mong muốn vào Widget Test
class MockArtistProfileNotifier extends ArtistProfileNotifier {
  final AsyncValue<ArtistProfileData> forcedState;

  MockArtistProfileNotifier(this.forcedState);

  @override
  FutureOr<ArtistProfileData> build() async {
    if (forcedState.isLoading) {
      return Completer<ArtistProfileData>().future; // Mãi mãi loading
    } else if (forcedState.hasError) {
      throw forcedState.error!;
    } else {
      return forcedState.requireValue;
    }
  }
}

void main() {
  late ArtistProfileData dummyData;
  late ArtistProfileData emptyData;

  setUp(() {
    final mockArtist = Artist(
      id: 'a1',
      name: 'Ngọt',
      bio: 'Ban nhạc Indie Pop hàng đầu Việt Nam.',
      avatarUrl: 'https://example.com/avatar.jpg',
      coverUrl: 'https://example.com/cover.jpg',
      followersCount: 154000,
    );

    final mockTracks = List.generate(
      5,
      (index) => Track(
        id: 't$index',
        title: 'Track $index',
        artistName: 'Ngọt',
        artworkUrl: 'https://example.com/art$index.jpg',
        durationSeconds: 200,
      ),
    );

    final mockStats = ArtistDashboardStats(
      totalViews: 1000,
      totalLikes: 100,
      totalFollowers: 154000,
      totalComments: 50,
      chartViews: [10, 20, 30, 40, 50, 60, 70],
    );

    dummyData = ArtistProfileData(
      artist: mockArtist,
      popularTracks: mockTracks,
      isFollowing: false,
      dashboardStats: mockStats,
    );

    emptyData = ArtistProfileData(
      artist: mockArtist,
      popularTracks: [],
      isFollowing: false,
    );
  });

  Widget createWidgetUnderTest(AsyncValue<ArtistProfileData> state, {ArtistProfileMode mode = ArtistProfileMode.listener}) {
    return ProviderScope(
      overrides: [
        artistProfileProvider.overrideWith(() => MockArtistProfileNotifier(state)),
      ],
      child: MaterialApp(
        home: ArtistProfileScreen(mode: mode),
      ),
    );
  }

  testWidgets('1. Listener mode displays artist info + Follow button + Top 5 tracks', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData), mode: ArtistProfileMode.listener));
    await tester.pumpAndSettle();

    expect(find.byType(ArtistHeader), findsOneWidget);
    expect(find.text('Theo dõi'), findsOneWidget); // Follow button is visible
    
    // Scroll to see the last track
    await tester.scrollUntilVisible(
      find.text('Track 4'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Track 4'), findsOneWidget);
  });

  testWidgets('2. Listener mode does NOT display dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData), mode: ArtistProfileMode.listener));
    await tester.pumpAndSettle();

    expect(find.byType(ArtistDashboard), findsNothing);
  });

  testWidgets('3. Owner mode displays artist info + Top 5 tracks + Artist Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData), mode: ArtistProfileMode.owner));
    await tester.pumpAndSettle();

    // ArtistHeader is visible at top
    expect(find.byType(ArtistHeader), findsOneWidget);

    // Scroll to Dashboard
    await tester.scrollUntilVisible(
      find.byType(ArtistDashboard),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(ArtistDashboard), findsOneWidget);
  });

  testWidgets('4. Owner mode does NOT display Follow button', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData), mode: ArtistProfileMode.owner));
    await tester.pumpAndSettle();

    expect(find.text('Theo dõi'), findsNothing);
    expect(find.text('Đang theo dõi'), findsNothing);
  });

  testWidgets('5. Loading state hiển thị đúng (Shimmer)', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncValue.loading()));
    await tester.pump();

    expect(find.byType(ArtistProfileShimmer), findsOneWidget);
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('6. Error state hiển thị và Retry button xuất hiện', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.error('Network Error', StackTrace.empty)));
    await tester.pumpAndSettle();

    expect(find.text('Đã xảy ra lỗi khi tải dữ liệu'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('7. Empty state hiển thị khi không có track', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(emptyData)));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có bài hát nào.'), findsOneWidget);
    expect(find.byType(TrackListItem), findsNothing);
  });

  testWidgets('8. 360dp responsive layout with no RenderFlex overflow in Owner mode', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData), mode: ArtistProfileMode.owner));
    await tester.pumpAndSettle();
    
    // Scoll down fully
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
    await tester.pumpAndSettle();

    // Check for any FlutterError
    expect(tester.takeException(), isNull);
    
    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
