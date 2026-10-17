import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/track_management/data/models/artist_track_model.dart';
import 'package:music4_mobile/features/track_management/data/repositories/track_management_repository.dart';
import 'package:music4_mobile/features/track_management/presentation/providers/artist_tracks_provider.dart';

class MockTrackManagementRepository extends Mock implements TrackManagementRepository {}

void main() {
  late MockTrackManagementRepository mockRepo;
  late ArtistTracksNotifier notifier;

  const sampleTrack1 = ArtistTrackItemModel(
    id: 1,
    name: 'Song A',
    albumName: 'Single',
    duration: 180,
    viewCount: 1000,
  );

  const sampleTrack2 = ArtistTrackItemModel(
    id: 2,
    name: 'Song B',
    albumName: 'Album ABC',
    duration: 200,
    viewCount: 5000,
  );

  setUp(() {
    mockRepo = MockTrackManagementRepository();
    notifier = ArtistTracksNotifier(mockRepo);
  });

  group('[CE190036] ArtistTracksNotifier Unit Tests (UC47, UC50, UC51)', () {
    test('fetchArtistTracks emits AsyncData when success (UC47)', () async {
      when(() => mockRepo.getArtistTracks(5)).thenAnswer((_) async => [sampleTrack1, sampleTrack2]);

      await notifier.fetchArtistTracks(5);

      expect(notifier.state, isA<AsyncData<List<ArtistTrackItemModel>>>());
      expect(notifier.state.value?.length, 2);
      expect(notifier.state.value?[0].name, 'Song A');
      expect(notifier.state.value?[1].name, 'Song B');
    });

    test('fetchArtistTracks emits AsyncError when failure (UC47)', () async {
      when(() => mockRepo.getArtistTracks(5)).thenThrow(Exception('Lỗi mạng'));

      await notifier.fetchArtistTracks(5);

      expect(notifier.state, isA<AsyncError>());
    });

    test('updateTrackMetadata delegates to repo and refreshes tracks (UC50)', () async {
      when(() => mockRepo.getArtistTracks(5)).thenAnswer((_) async => [sampleTrack1]);
      when(() => mockRepo.updateTrackMetadata(
            trackId: 1,
            title: any(named: 'title'),
            albumId: any(named: 'albumId'),
            categoryIds: any(named: 'categoryIds'),
            collabArtistIds: any(named: 'collabArtistIds'),
            coverImageFile: any(named: 'coverImageFile'),
          )).thenAnswer((_) async {});

      await notifier.fetchArtistTracks(5);
      await notifier.updateTrackMetadata(trackId: 1, title: 'Updated Song A');

      verify(() => mockRepo.updateTrackMetadata(
            trackId: 1,
            title: 'Updated Song A',
            albumId: null,
            categoryIds: null,
            collabArtistIds: null,
            coverImageFile: null,
          )).called(1);
      verify(() => mockRepo.getArtistTracks(5)).called(2);
    });

    test('deleteTrack removes track from state list (UC51)', () async {
      when(() => mockRepo.getArtistTracks(5)).thenAnswer((_) async => [sampleTrack1, sampleTrack2]);
      when(() => mockRepo.deleteTrack(1)).thenAnswer((_) async {});

      await notifier.fetchArtistTracks(5);
      expect(notifier.state.value?.length, 2);

      await notifier.deleteTrack(1);

      verify(() => mockRepo.deleteTrack(1)).called(1);
      expect(notifier.state.value?.length, 1);
      expect(notifier.state.value?[0].id, 2);
    });
  });
}
