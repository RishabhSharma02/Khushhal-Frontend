import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khushhal/app/model/ledger.dart';
import 'package:khushhal/core/db/app_database.dart';
import 'package:khushhal/core/network/api_client.dart';
import 'package:khushhal/core/network/api_exception.dart';
import 'package:khushhal/core/sync/connectivity_monitor.dart';
import 'package:khushhal/core/sync/outbox_dao.dart';
import 'package:khushhal/core/sync/pull_handlers.dart';
import 'package:khushhal/core/sync/push_handlers.dart';
import 'package:khushhal/core/sync/sync_engine.dart';
import 'package:khushhal/core/sync/sync_op.dart';
import 'package:khushhal/core/sync/sync_status.dart';
import 'package:khushhal/features/auth/data/profile_local_datasource.dart';
import 'package:khushhal/features/auth/data/profile_remote_datasource.dart';
import 'package:khushhal/features/businesses/data/business_local_datasource.dart';
import 'package:khushhal/features/businesses/data/business_remote_datasource.dart';
import 'package:khushhal/features/entries/data/ledger_local_datasource.dart';
import 'package:khushhal/features/entries/data/ledger_remote_datasource.dart';
import 'package:khushhal/features/insights/data/insights_local_datasource.dart';
import 'package:khushhal/features/insights/data/insights_remote_datasource.dart';

/// A network the test can switch off, with the two ledger endpoints scripted.
class _FakeApi extends ApiClient {
  _FakeApi();

  bool offline = false;

  final List<String> calls = <String>[];

  /// What `GET /entries` hands back, keyed by nothing — the tests only ever use
  /// one business.
  List<Map<String, dynamic>> entries = <Map<String, dynamic>>[];

  void _record(String method, String path) {
    if (offline) throw ApiException.offline();
    calls.add('$method $path');
  }

  int countOf(String call) => calls.where((String c) => c == call).length;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    _record('GET', path);
    if (path.endsWith('/entries')) {
      return <String, dynamic>{'items': entries, 'next_cursor': null};
    }
    return <String, dynamic>{};
  }

  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    _record('GET', path);
    return const <dynamic>[];
  }

  @override
  Future<Map<String, dynamic>> postJson(String path, {Object? body}) async {
    _record('POST', path);
    return <String, dynamic>{'accepted': 1, 'duplicates': 0};
  }

  @override
  Future<Map<String, dynamic>> patchJson(String path, {Object? body}) async {
    _record('PATCH', path);
    return <String, dynamic>{};
  }
}

/// Reports reachability without touching the platform channel or the network.
class _FakeConnectivity extends ConnectivityMonitor {
  _FakeConnectivity() : super(probeClient: Dio(), baseUrl: 'http://localhost');

  final ValueNotifier<bool> _flag = ValueNotifier<bool>(true);
  final StreamController<void> _reconnects = StreamController<void>.broadcast();

  bool online = true;

  @override
  ValueListenable<bool> get isOnline => _flag;

  @override
  Stream<void> get onReconnected => _reconnects.stream;

  @override
  Future<bool> refresh() async {
    _flag.value = online;
    return online;
  }

  /// Simulates the radio coming back.
  void reconnect() {
    online = true;
    _flag.value = true;
    _reconnects.add(null);
  }

  @override
  void dispose() {
    _reconnects.close();
    _flag.dispose();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late _FakeApi api;
  late _FakeConnectivity connectivity;
  late OutboxDao outbox;
  late LedgerLocalDataSource ledgerLocal;
  late SyncStatusController status;
  late SyncEngine engine;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    api = _FakeApi();
    connectivity = _FakeConnectivity();
    outbox = OutboxDao(db);
    ledgerLocal = LedgerLocalDataSource(db);
    status = SyncStatusController();

    final ledgerRemote = LedgerRemoteDataSource(api);
    final businessLocal = BusinessLocalDataSource(db);
    final businessRemote = BusinessRemoteDataSource(api);
    final profileLocal = ProfileLocalDataSource(db);
    final profileRemote = ProfileRemoteDataSource(api);
    final insightsLocal = InsightsLocalDataSource(db);
    final insightsRemote = InsightsRemoteDataSource(api);

    engine = SyncEngine(
      db: db,
      outbox: outbox,
      push: PushDispatcher(
        ledgerLocal: ledgerLocal,
        ledgerRemote: ledgerRemote,
        businessLocal: businessLocal,
        businessRemote: businessRemote,
        profileLocal: profileLocal,
        profileRemote: profileRemote,
        insightsLocal: insightsLocal,
        insightsRemote: insightsRemote,
      ),
      pull: PullService(
        db: db,
        outbox: outbox,
        ledgerLocal: ledgerLocal,
        ledgerRemote: ledgerRemote,
        businessLocal: businessLocal,
        businessRemote: businessRemote,
        profileLocal: profileLocal,
        profileRemote: profileRemote,
        insightsLocal: insightsLocal,
        insightsRemote: insightsRemote,
      ),
      connectivity: connectivity,
      status: status,
      ledgerLocal: ledgerLocal,
    );
  });

  tearDown(() {
    engine.dispose();
    connectivity.dispose();
    status.dispose();
    return db.close();
  });

  LedgerEntry entry(int amount) => LedgerEntry(
    kind: EntryKind.moneyIn,
    amountInr: amount,
    category: EntryCategory.milkSale,
    recordedAt: DateTime(2026, 8, 13, 9),
  );

  Future<String> addEntryOffline(int amount) async {
    final String id = await ledgerLocal.insertLocal(
      businessServerId: 7,
      entry: entry(amount),
    );
    await outbox.enqueue(
      entity: SyncEntity.ledgerEntry,
      op: SyncOpKind.create,
      localRowId: id,
      businessServerId: 7,
    );
    return id;
  }

  test('a cycle while offline sends nothing and keeps the queue', () async {
    await addEntryOffline(100);
    connectivity.online = false;

    final SyncCycleResult result = await engine.syncNow();

    expect(result.skippedOffline, isTrue);
    expect(api.calls, isEmpty);
    expect(await outbox.pendingCount(), 1);
    expect(status.value.state, SyncState.offline);
  });

  test('reconnecting drains everything queued offline', () async {
    connectivity.online = false;
    final String a = await addEntryOffline(100);
    final String b = await addEntryOffline(200);
    await engine.syncNow();
    expect(await outbox.pendingCount(), 2);

    connectivity.online = true;
    api.entries = <Map<String, dynamic>>[
      <String, dynamic>{'id': 501, 'client_entry_id': a},
      <String, dynamic>{'id': 502, 'client_entry_id': b},
    ];

    final SyncCycleResult result = await engine.syncNow();

    expect(result.pushed, 2);
    expect(await outbox.pendingCount(), 0);
    expect(
      api.countOf('POST /api/v1/businesses/7/entries/sync'),
      1,
      reason: 'a week of entries is one round trip, not one per entry',
    );
  });

  test('drained creates learn their server ids so edits can follow', () async {
    connectivity.online = false;
    final String id = await addEntryOffline(100);
    connectivity.online = true;
    api.entries = <Map<String, dynamic>>[
      <String, dynamic>{'id': 777, 'client_entry_id': id},
    ];

    await engine.syncNow();

    expect((await ledgerLocal.byClientId(id))!.serverId, 777);
  });

  test('a successful cycle records the last full sync time', () async {
    expect(await db.readMetaTime(SyncMetaKeys.lastFullSync), isNull);

    await engine.syncNow();

    expect(await db.readMetaTime(SyncMetaKeys.lastFullSync), isNotNull);
    expect(status.value.lastFullSync, isNotNull);
  });

  test('an offline cycle does not claim a full sync happened', () async {
    connectivity.online = false;

    await engine.syncNow();

    expect(await db.readMetaTime(SyncMetaKeys.lastFullSync), isNull);
  });

  test('two concurrent calls share one cycle', () async {
    await addEntryOffline(100);

    final List<SyncCycleResult> results = await Future.wait(
      <Future<SyncCycleResult>>[engine.syncNow(), engine.syncNow()],
    );

    expect(results.first, same(results.last));
    expect(api.countOf('POST /api/v1/businesses/7/entries/sync'), 1);
  });

  group('logout gate', () {
    test('an empty queue needs no warning', () async {
      expect(await engine.flushBeforeLogout(), 0);
    });

    test('a queue that drains needs no warning', () async {
      final String id = await addEntryOffline(100);
      api.entries = <Map<String, dynamic>>[
        <String, dynamic>{'id': 501, 'client_entry_id': id},
      ];

      expect(await engine.flushBeforeLogout(), 0);
    });

    test('a queue that cannot drain reports what would be lost', () async {
      await addEntryOffline(100);
      await addEntryOffline(200);
      connectivity.online = false;

      expect(await engine.flushBeforeLogout(), 2);
    });

    test('a rejected op still counts against signing out', () async {
      await addEntryOffline(100);
      await outbox.recordFailure(
        (await outbox.claimReady()).single,
        error: '422',
        retryable: false,
      );

      expect(await engine.flushBeforeLogout(), 1);
    });
  });
}
