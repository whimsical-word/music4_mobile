import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/admin/data/models/vector_sync_status.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_sync_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_sync_provider.dart';
import 'package:music4_mobile/features/admin/presentation/widgets/vector_sync_card.dart';

/// Answers from memory and counts the calls.
class FakeAdminSyncRepository extends AdminSyncRepository {
  final List<Object> statuses;
  final Object startAnswer;
  int statusCalls = 0;
  int startCalls = 0;

  FakeAdminSyncRepository(
    this.statuses, {
    this.startAnswer = SyncStartResult.started,
  }) : super(DioClient());

  @override
  Future<VectorSyncStatus> getStatus() async {
    statusCalls++;
    final index = statusCalls - 1 < statuses.length ? statusCalls - 1 : statuses.length - 1;
    final next = statuses[index];
    if (next is Exception) throw next;
    return next as VectorSyncStatus;
  }

  @override
  Future<SyncStartResult> startSync() async {
    startCalls++;
    final answer = startAnswer;
    if (answer is Exception) throw answer;
    return answer as SyncStartResult;
  }
}

VectorSyncRun run({int synced = 5, int failed = 0, int removed = 0, DateTime? at}) =>
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
  Future<FakeAdminSyncRepository> pumpCard(
    WidgetTester tester,
    List<Object> statuses, {
    Object startAnswer = SyncStartResult.started,
  }) async {
    final repository = FakeAdminSyncRepository(statuses, startAnswer: startAnswer);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminVectorSyncProvider.overrideWith(
            (ref) => AdminVectorSyncNotifier(
              repository,
              pollInterval: const Duration(milliseconds: 10),
            )..load(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: VectorSyncCard())),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    return repository;
  }

  Future<void> letTimeRun(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  group('[CE190284] VectorSyncCard - what it shows', () {
    testWidgets('matching counts: Đã khớp, last run, button ready', (tester) async {
      await pumpCard(tester, [status(sql: 13, indexed: 13, last: run(synced: 13, removed: 2))]);

      expect(find.text('Đồng bộ gợi ý (Elasticsearch)'), findsOneWidget);
      expect(find.text('Bài hát trong SQL'), findsOneWidget);
      expect(find.text('13'), findsNWidgets(2)); // SQL and Elasticsearch
      expect(find.text('Đã khớp'), findsOneWidget);
      expect(
        find.text('Lần gần nhất: 26/10 14:05 · 13 thành công, 0 lỗi, 2 vector mồ côi đã xóa'),
        findsOneWidget,
      );
      expect(find.text('Đồng bộ ngay'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('vector_sync_button'))).onPressed, isNotNull);
    });

    testWidgets('missing vectors are counted', (tester) async {
      await pumpCard(tester, [status(sql: 13, indexed: 11)]);

      expect(find.text('Thiếu 2 vector'), findsOneWidget);
      expect(find.text('Đã khớp'), findsNothing);
    });

    testWidgets('Elasticsearch unreachable: unknown, not "missing"', (tester) async {
      await pumpCard(tester, [status(sql: 13, indexed: null)]);

      expect(find.text('Không kết nối được'), findsOneWidget);
      expect(find.text('Không xác định'), findsOneWidget);
    });

    testWidgets('no run since the backend started', (tester) async {
      await pumpCard(tester, [status()]);

      expect(
        find.text('Chưa có lần đồng bộ toàn bộ nào kể từ khi backend khởi động.'),
        findsOneWidget,
      );
    });

    testWidgets('a run in progress disables the button', (tester) async {
      await pumpCard(tester, [status(running: true)]);

      expect(find.text('Đang đồng bộ...'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('vector_sync_button'))).onPressed, isNull);
    });

    testWidgets('a failed load shows the message and Thử lại loads again', (tester) async {
      final repository = await pumpCard(
        tester,
        [const AdminSyncException('Lỗi kết nối máy chủ'), status()],
      );

      expect(find.byKey(const Key('vector_sync_error')), findsOneWidget);
      expect(find.text('Lỗi kết nối máy chủ'), findsOneWidget);

      await tester.tap(find.byKey(const Key('vector_sync_retry_btn')));
      await tester.pump();
      await tester.pump();

      expect(repository.statusCalls, 2);
      expect(find.byKey(const Key('vector_sync_error')), findsNothing);
      expect(find.text('Bài hát trong SQL'), findsOneWidget);
    });

    testWidgets('the refresh button reads the status again', (tester) async {
      final repository = await pumpCard(tester, [status(sql: 5, indexed: 3), status(sql: 5, indexed: 5)]);
      expect(find.text('Thiếu 2 vector'), findsOneWidget);

      await tester.tap(find.byKey(const Key('vector_sync_refresh_btn')));
      await tester.pump();
      await tester.pump();

      expect(repository.statusCalls, 2);
      expect(find.text('Đã khớp'), findsOneWidget);
    });
  });

  group('[CE190284] VectorSyncCard - starting a synchronisation', () {
    testWidgets('asks for confirmation, then starts and reports the result', (tester) async {
      final repository = await pumpCard(tester, [
        status(sql: 5, indexed: 3),
        status(sql: 5, indexed: 4, running: true),
        status(sql: 5, indexed: 5, last: run(synced: 5, removed: 0)),
      ]);

      await tester.tap(find.byKey(const Key('vector_sync_button')));
      await tester.pump();
      expect(find.text('Đồng bộ lại toàn bộ?'), findsOneWidget);
      expect(repository.startCalls, 0); // nothing yet

      await tester.tap(find.byKey(const Key('vector_sync_confirm_btn')));
      await letTimeRun(tester);

      expect(repository.startCalls, 1);
      expect(find.text('Hoàn tất: 5 bài thành công, 0 lỗi, 0 vector mồ côi đã xóa.'), findsOneWidget);
      expect(find.text('Đã khớp'), findsOneWidget);
      expect(find.text('Đồng bộ ngay'), findsOneWidget); // ready again
    });

    testWidgets('Hủy does not start anything', (tester) async {
      final repository = await pumpCard(tester, [status()]);

      await tester.tap(find.byKey(const Key('vector_sync_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('vector_sync_cancel_btn')));
      await tester.pump(const Duration(milliseconds: 300)); // let the dialog close

      expect(repository.startCalls, 0);
      expect(find.text('Đồng bộ lại toàn bộ?'), findsNothing);
    });

    testWidgets('a refused start shows the error under the button', (tester) async {
      await pumpCard(
        tester,
        [status()],
        startAnswer: const AdminSyncException('Chỉ tài khoản ADMIN mới dùng được chức năng này'),
      );

      await tester.tap(find.byKey(const Key('vector_sync_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('vector_sync_confirm_btn')));
      await letTimeRun(tester);

      expect(find.byKey(const Key('vector_sync_notice')), findsOneWidget);
      expect(find.text('Chỉ tài khoản ADMIN mới dùng được chức năng này'), findsOneWidget);
      expect(find.text('Đồng bộ ngay'), findsOneWidget); // can try again
    });

    testWidgets('a run already going (409) is announced and watched', (tester) async {
      await pumpCard(
        tester,
        [status(), status(last: run(at: DateTime(2026, 10, 26, 15)))],
        startAnswer: SyncStartResult.alreadyRunning,
      );

      await tester.tap(find.byKey(const Key('vector_sync_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('vector_sync_confirm_btn')));
      await tester.pump();
      await tester.pump();
      expect(find.text('Một tiến trình đồng bộ khác đang chạy. Đang theo dõi...'), findsOneWidget);
      expect(find.text('Đang đồng bộ...'), findsOneWidget);

      await letTimeRun(tester);
      expect(find.textContaining('Hoàn tất'), findsOneWidget);
    });
  });
}
