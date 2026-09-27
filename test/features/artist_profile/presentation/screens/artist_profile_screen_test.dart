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
    ];

    dummyData = ArtistProfileData(
      artist: mockArtist,
      popularTracks: mockTracks,
      isFollowing: false,
    );

    emptyData = ArtistProfileData(
      artist: mockArtist,
      popularTracks: [],
      isFollowing: false,
    );
  });

  Widget createWidgetUnderTest(AsyncValue<ArtistProfileData> state) {
    return ProviderScope(
      overrides: [
        artistProfileProvider.overrideWith(() => MockArtistProfileNotifier(state)),
      ],
      child: const MaterialApp(
        home: ArtistProfileScreen(),
      ),
    );
  }

  testWidgets('1. Loaded state hiển thị artist profile và featured tracks', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData)));
    await tester.pumpAndSettle();

    // Verify UI
    expect(find.byType(ArtistHeader), findsOneWidget);
    expect(find.text('Ngọt'), findsNWidgets(3)); // Artist name + 2 track artists
    expect(find.text('154.0K Người theo dõi'), findsOneWidget);
    expect(find.text('Bài hát phổ biến'), findsOneWidget);
    
    // Tracks
    expect(find.byType(TrackListItem), findsNWidgets(2));
    expect(find.text('Lần Cuối'), findsOneWidget);
    expect(find.text('Cho Tôi Đi Theo'), findsOneWidget);
  });

  testWidgets('2. Loading state hiển thị đúng (Shimmer)', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncValue.loading()));
    // No pumpAndSettle for infinite animation
    await tester.pump();

    expect(find.byType(ArtistProfileShimmer), findsOneWidget);
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('3. Error state hiển thị và Retry button xuất hiện', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.error('Network Error', StackTrace.empty)));
    await tester.pumpAndSettle();

    expect(find.text('Đã xảy ra lỗi khi tải dữ liệu'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('4. Empty state hiển thị khi không có track', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(emptyData)));
    await tester.pumpAndSettle();

    expect(find.byType(ArtistHeader), findsOneWidget);
    expect(find.text('Chưa có bài hát nào.'), findsOneWidget);
    expect(find.byType(TrackListItem), findsNothing);
  });

  testWidgets('5. Layout 360dp không bị overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(dummyData)));
    await tester.pumpAndSettle();

    // Check for any FlutterError
    expect(tester.takeException(), isNull);
    
    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
