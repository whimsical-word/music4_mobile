import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/admin/data/models/vector_sync_status.dart';

void main() {
  group('[CE190284] VectorSyncStatus', () {
    test('parses the backend answer', () {
      final status = VectorSyncStatus.fromJson({
        'sqlTracks': 13,
        'indexedVectors': 11,
        'inSync': false,
        'syncRunning': true,
        'lastFullSync': {
          'finishedAt': '2026-10-26T14:05:33.123456',
          'synced': 12,
          'failed': 1,
          'removedOrphans': 2,
        },
      });

      expect(status.sqlTracks, 13);
      expect(status.indexedVectors, 11);
      expect(status.inSync, isFalse);
      expect(status.syncRunning, isTrue);
      expect(status.missingVectors, 2);
      expect(status.lastFullSync?.synced, 12);
      expect(status.lastFullSync?.failed, 1);
      expect(status.lastFullSync?.removedOrphans, 2);
      expect(status.lastFullSync?.finishedAt, DateTime(2026, 10, 26, 14, 5, 33, 123, 456));
    });

    test('indexedVectors is null when Elasticsearch could not be reached', () {
      final status = VectorSyncStatus.fromJson({
        'sqlTracks': 3,
        'indexedVectors': null,
        'inSync': false,
        'syncRunning': false,
        'lastFullSync': null,
      });

      expect(status.indexedVectors, isNull);
      expect(status.lastFullSync, isNull);
      expect(status.missingVectors, 0); // unknown is not "missing"
    });

    test('numbers may arrive as int or double', () {
      final status = VectorSyncStatus.fromJson({
        'sqlTracks': 4.0,
        'indexedVectors': 4,
        'inSync': true,
        'syncRunning': false,
      });

      expect(status.sqlTracks, 4);
      expect(status.indexedVectors, 4);
      expect(status.inSync, isTrue);
    });

    test('missing fields fall back to safe defaults', () {
      final status = VectorSyncStatus.fromJson({});

      expect(status.sqlTracks, 0);
      expect(status.indexedVectors, isNull);
      expect(status.inSync, isFalse);
      expect(status.syncRunning, isFalse);
    });

    test('missingVectors is 0 when the index has as many or more vectors', () {
      expect(
        VectorSyncStatus.fromJson({'sqlTracks': 3, 'indexedVectors': 5}).missingVectors,
        0,
      );
    });

    test('an unreadable finishedAt gives a null date, not a crash', () {
      final run = VectorSyncRun.fromJson({'finishedAt': 'not a date', 'synced': 1});

      expect(run.finishedAt, isNull);
      expect(run.synced, 1);
    });
  });
}
