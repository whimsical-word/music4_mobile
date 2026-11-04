import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/admin/data/models/vector_sync_status.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_sync_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_sync_provider.dart';

class MockAdminSyncRepository extends Mock implements AdminSyncRepository {}

VectorSyncRun run({DateTime? at, int synced = 5, int failed = 0, int removed = 0}) =>
    VectorSyncRun(
      finishedAt: at ?? DateTime(2026, 10, 26, 14, 5),
      synced: synced,
      failed: failed,
      removedOrphans: removed,
    );

VectorSyncStatus status({
  int sql = 5,
  int? indexed = 5,
  bool running = false,
  VectorSyncRun? last,
}) => VectorSyncStatus(
  sqlTracks: sql,
  indexedVectors: indexed,
  inSync: indexed == sql,
  syncRunning: running,
  lastFullSync: last,
);

void main() {
  late MockAdminSyncRepository repository;

  /// getStatus answers with [answers] in order, then repeats the last one.
  /// An Exception in the list is thrown instead of returned.
  void stubStatuses(List<Object> answers) {
    final queue = List<Object>.of(answers);
    when(() => repository.getStatus()).thenAnswer((_) async {
      final next = queue.length > 1 ? queue.removeAt(0) : queue.first;
      if (next is Exception) throw next;
      return next as VectorSyncStatus;
    });
  }

  AdminVectorSyncNotifier notifier({int maxPolls = 20}) {
    final notifier = AdminVectorSyncNotifier(
      repository,
      pollInterval: Duration.zero,
      maxPolls: maxPolls,
    );
    addTearDown(notifier.dispose);
    return notifier;
  }

  setUp(() {
    repository = MockAdminSyncRepository();
  });

  group('[CE190284] AdminVectorSyncNotifier - reading the status', () {
    test('load shows the status', () async {
      stubStatuses([status()]);
      final n = notifier();

      await n.load();

      expect(n.state.status.value?.sqlTracks, 5);
      expect(n.state.isBusy, isFalse);
    });

    test('a failed first load is an error and load() again recovers', () async {
      stubStatuses([const AdminSyncException('Lỗi kết nối máy chủ'), status()]);
      final n = notifier();

      await n.load();
      expect(n.state.status.hasError, isTrue);
      expect(n.state.status.error.toString(), 'Lỗi kết nối máy chủ');

      await n.load();
      expect(n.state.status.hasError, isFalse);
      expect(n.state.status.value?.sqlTracks, 5);
    });

    test('a failed refresh keeps the numbers on screen and says why', () async {
      stubStatuses([status(sql: 7, indexed: 7), const AdminSyncException('Mạng quá yếu, thử lại sau')]);
      final n = notifier();

      await n.load();
      await n.refresh();

      expect(n.state.status.value?.sqlTracks, 7);
      expect(n.state.notice, 'Mạng quá yếu, thử lại sau');
      expect(n.state.noticeIsError, isTrue);
    });

    test('a run that is already going on the backend makes the state busy', () async {
      stubStatuses([status(running: true)]);
      final n = notifier();

      await n.load();

      expect(n.state.isBusy, isTrue);
    });
  });

  group('[CE190284] AdminVectorSyncNotifier - starting a synchronisation', () {
    test('starts, watches the status and reports the result when it ends', () async {
      stubStatuses([
        status(indexed: 3), // load
        status(indexed: 3, running: true), // poll 1
        status(running: true, indexed: 4), // poll 2
        status(last: run(synced: 5, failed: 0, removed: 1)), // poll 3: finished, new result
      ]);
      when(() => repository.startSync()).thenAnswer((_) async => SyncStartResult.started);
      final n = notifier();

      await n.load();
      await n.startSync();

      verify(() => repository.startSync()).called(1);
      expect(n.state.isStarting, isFalse);
      expect(n.state.isWaiting, isFalse);
      expect(n.state.noticeIsError, isFalse);
      expect(n.state.notice, 'Hoàn tất: 5 bài thành công, 0 lỗi, 1 vector mồ côi đã xóa.');
      expect(n.state.status.value?.inSync, isTrue);
    });

    test('a run that is already going is watched instead of started again', () async {
      stubStatuses([
        status(),
        status(last: run(at: DateTime(2026, 10, 26, 15))),
      ]);
      when(() => repository.startSync()).thenAnswer((_) async => SyncStartResult.alreadyRunning);
      final n = notifier();

      await n.load();
      await n.startSync();

      expect(n.state.notice, startsWith('Hoàn tất'));
      expect(n.state.isWaiting, isFalse);
    });

    test('pressing the button while a run is going does nothing', () async {
      stubStatuses([status(running: true)]);
      final n = notifier();

      await n.load();
      await n.startSync();

      verifyNever(() => repository.startSync());
    });

    test('a refused start (not an admin) shows the error and does not watch', () async {
      stubStatuses([status()]);
      when(() => repository.startSync())
          .thenThrow(const AdminSyncException('Chỉ tài khoản ADMIN mới dùng được chức năng này'));
      final n = notifier();

      await n.load();
      await n.startSync();

      expect(n.state.notice, 'Chỉ tài khoản ADMIN mới dùng được chức năng này');
      expect(n.state.noticeIsError, isTrue);
      expect(n.state.isStarting, isFalse);
      expect(n.state.isWaiting, isFalse);
      verify(() => repository.getStatus()).called(1); // only the first load
    });

    test('if nothing ever runs it says so after a few polls instead of waiting forever', () async {
      stubStatuses([status()]); // never running, never a new result
      when(() => repository.startSync()).thenAnswer((_) async => SyncStartResult.started);
      final n = notifier();

      await n.load();
      await n.startSync();

      expect(n.state.noticeIsError, isTrue);
      expect(n.state.notice, startsWith('Không thấy tiến trình nào chạy'));
      expect(n.state.isWaiting, isFalse);
    });

    test('if the status cannot be read while watching it stops and says so', () async {
      stubStatuses([status(), const AdminSyncException('Lỗi kết nối máy chủ')]);
      when(() => repository.startSync()).thenAnswer((_) async => SyncStartResult.started);
      final n = notifier();

      await n.load();
      await n.startSync();

      expect(n.state.isWaiting, isFalse);
      expect(n.state.noticeIsError, isTrue);
      expect(n.state.notice, startsWith('Không theo dõi được tiến trình'));
    });

    test('after the maximum number of polls it stops watching a run that is still going', () async {
      stubStatuses([status(), status(running: true)]);
      when(() => repository.startSync()).thenAnswer((_) async => SyncStartResult.started);
      final n = notifier(maxPolls: 3);

      await n.load();
      await n.startSync();

      expect(n.state.isWaiting, isFalse);
      expect(n.state.notice, startsWith('Vẫn đang đồng bộ'));
      expect(n.state.noticeIsError, isFalse);
    });
  });
}
