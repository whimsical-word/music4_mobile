// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:music4_mobile/features/player/data/services/audio_cache_service.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final String path;
  FakePathProviderPlatform(this.path);

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('audio_cache_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('[CE190036] AudioCacheService & Offline Cache Tests UC42', () {
    final service = AudioCacheService.instance;

    test('getCacheFile returns file pointing to app documents directory with trackId', () async {
      final file = await service.getCacheFile('99');
      expect(file.path, contains('music4_cache_99.mp3'));
      expect(file.path, startsWith(tempDir.path));
    });

    test('isTrackCached returns false when file does not exist', () async {
      final isCached = await service.isTrackCached('not_exist');
      expect(isCached, isFalse);
    });

    test('isTrackCached returns false when file size is under 100KB', () async {
      final file = await service.getCacheFile('tiny');
      await file.writeAsString('small dummy audio content');
      final isCached = await service.isTrackCached('tiny');
      expect(isCached, isFalse);
      if (await file.exists()) await file.delete();
    });

    test('isTrackCached returns true when file exists and size is over 100KB', () async {
      final file = await service.getCacheFile('101');
      // Create a 150KB dummy file
      final largeData = List<int>.filled(153600, 42);
      await file.writeAsBytes(largeData);

      final isCached = await service.isTrackCached('101');
      expect(isCached, isTrue);

      final size = await service.getCacheSize();
      expect(size, greaterThanOrEqualTo(153600));

      await service.clearTrackCache('101');
      expect(await file.exists(), isFalse);
      expect(await service.isTrackCached('101'), isFalse);
    });

    test('clearAllCache deletes all cached audio files', () async {
      final file1 = await service.getCacheFile('track_a');
      final file2 = await service.getCacheFile('track_b');
      await file1.writeAsBytes(List<int>.filled(105000, 1));
      await file2.writeAsBytes(List<int>.filled(105000, 2));

      expect(await file1.exists(), isTrue);
      expect(await file2.exists(), isTrue);

      await service.clearAllCache();

      expect(await file1.exists(), isFalse);
      expect(await file2.exists(), isFalse);
    });
  });

  group('[CE190036] PlayerStateData Offline State Tests UC42', () {
    test('default PlayerStateData has isOfflineCached = false', () {
      const state = PlayerStateData();
      expect(state.isOfflineCached, isFalse);
    });

    test('copyWith updates isOfflineCached correctly', () {
      const state = PlayerStateData();
      final updated = state.copyWith(isOfflineCached: true);
      expect(updated.isOfflineCached, isTrue);
    });
  });
}
