import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khushhal/app/model/ledger.dart';
import 'package:khushhal/core/db/app_database.dart';
import 'package:khushhal/core/network/api_client.dart';
import 'package:khushhal/core/network/api_exception.dart';
import 'package:khushhal/core/sync/outbox_dao.dart';
import 'package:khushhal/core/sync/push_handlers.dart';
import 'package:khushhal/core/sync/sync_op.dart';
import 'package:khushhal/features/auth/data/profile_local_datasource.dart';
import 'package:khushhal/features/auth/data/profile_remote_datasource.dart';
import 'package:khushhal/features/businesses/data/business_local_datasource.dart';
import 'package:khushhal/features/businesses/data/business_remote_datasource.dart';
import 'package:khushhal/features/entries/data/ledger_local_datasource.dart';
import 'package:khushhal/features/entries/data/ledger_remote_datasource.dart';
import 'package:khushhal/features/insights/data/insights_local_datasource.dart';
import 'package:khushhal/features/insights/data/insights_remote_datasource.dart';

/// Stands in for the network so a test can decide, per call, whether the
/// device is reachable.
class _FakeApi extends ApiClient {
  _FakeApi();

  bool offline = false;

  final List<String> calls = <String>[];
  final List<Object?> bodies = <Object?>[];

  /// Rows `GET /entries` should return.
  List<Map<String, dynamic>> entries = <Map<String, dynamic>>[];

  void _record(String method, String path, Object? body) {
    if (offline) throw ApiException.offline();
    calls.add('$method $path');
    bodies.add(body);
  }

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    _record('GET', path, query);
    if (path.endsWith('/entries')) {
      return <String, dynamic>{'items': entries, 'next_cursor': null};
    }
    return <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> postJson(String path, {Object? body}) async {
    _record('POST', path, body);
    return <String, dynamic>{'accepted': 1, 'duplicates': 0};
  }

  @override
  Future<Map<String, dynamic>> patchJson(String path, {Object? body}) async {
    _record('PATCH', path, body);
    return <String, dynamic>{};
  }
}

void main() {
  late AppDatabase db;
  late _FakeApi api;
  late OutboxDao outbox;
  late LedgerLocalDataSource ledgerLocal;
  late ProfileLocalDataSource profileLocal;
  late PushDispatcher dispatcher;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    api = _FakeApi();
    outbox = OutboxDao(db);
    ledgerLocal = LedgerLocalDataSource(db);
    profileLocal = ProfileLocalDataSource(db);
    dispatcher = PushDispatcher(
      ledgerLocal: ledgerLocal,
      ledgerRemote: LedgerRemoteDataSource(api),
      businessLocal: BusinessLocalDataSource(db),
      businessRemote: BusinessRemoteDataSource(api),
      profileLocal: profileLocal,
      profileRemote: ProfileRemoteDataSource(api),
      insightsLocal: InsightsLocalDataSource(db),
      insightsRemote: InsightsRemoteDataSource(api),
    );
  });

  tearDown(() => db.close());

  LedgerEntry entry(int amount) => LedgerEntry(
    kind: EntryKind.moneyIn,
    amountInr: amount,
    category: EntryCategory.milkSale,
    recordedAt: DateTime(2026, 8, 13, 9),
  );

  Future<String> addOfflineEntry(int amount) async {
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

  group('offline to online', () {
    test('a batch push while offline is retryable and sends nothing', () async {
      await addOfflineEntry(100);
      api.offline = true;

      final PushResult result = await dispatcher.pushLedgerBatch(
        businessServerId: 7,
        rows: await ledgerLocal.pendingRows(),
      );

      expect(result.outcome, PushOutcome.retryable);
      expect(api.calls, isEmpty);
      expect(await outbox.pendingCount(), 1);
    });

    test('entries queued offline drain in one request when online', () async {
      final String a = await addOfflineEntry(100);
      final String b = await addOfflineEntry(200);

      final PushResult result = await dispatcher.pushLedgerBatch(
        businessServerId: 7,
        rows: await ledgerLocal.pendingRows(),
      );

      expect(result.outcome, PushOutcome.success);
      expect(api.calls, <String>['POST /api/v1/businesses/7/entries/sync']);

      final body = api.bodies.single! as Map<String, dynamic>;
      final entries = body['entries']! as List<dynamic>;
      expect(entries, hasLength(2));
      expect(
        entries
            .cast<Map<String, dynamic>>()
            .map((Map<String, dynamic> e) => e['client_entry_id'])
            .toSet(),
        <String>{a, b},
      );
    });

    test('the batch body carries the client id the server dedupes on', () async {
      final String id = await addOfflineEntry(100);

      await dispatcher.pushLedgerBatch(
        businessServerId: 7,
        rows: await ledgerLocal.pendingRows(),
      );

      final body = api.bodies.single! as Map<String, dynamic>;
      final row = (body['entries']! as List<dynamic>).single
          as Map<String, dynamic>;
      expect(row['client_entry_id'], id);
      expect(row['amount_inr'], 100);
      expect(row['kind'], 'in');
    });
  });

  group('server id resolution', () {
    test('reads entries back and attaches ids by client id', () async {
      final String id = await addOfflineEntry(100);
      api.entries = <Map<String, dynamic>>[
        <String, dynamic>{'id': 501, 'client_entry_id': id},
      ];

      final int attached = await dispatcher.resolveServerIds(7);

      expect(attached, 1);
      expect((await ledgerLocal.byClientId(id))!.serverId, 501);
    });

    test('an edit is deferred until its create has an id, then sends', () async {
      final String id = await addOfflineEntry(100);
      await ledgerLocal.updateLocal(clientId: id, amountInr: 900);
      await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.update,
        localRowId: id,
      );

      // Coalescing folds the edit into the unsent create, so there is one op.
      final SyncOpRow op = (await outbox.claimReady()).single;
      expect(op.op, SyncOpKind.create);

      // A create reaching push() directly is deferred to the batch pass.
      expect((await dispatcher.push(op)).outcome, PushOutcome.deferred);

      await dispatcher.pushLedgerBatch(
        businessServerId: 7,
        rows: await ledgerLocal.pendingRows(),
      );
      final body = api.bodies.single! as Map<String, dynamic>;
      final row = (body['entries']! as List<dynamic>).single
          as Map<String, dynamic>;
      expect(row['amount_inr'], 900, reason: 'the edit rides on the create');
    });

    test('an edit to a synced entry PATCHes the server id', () async {
      final String id = await addOfflineEntry(100);
      // The create has landed, so its op is gone and the edit queues its own.
      await ledgerLocal.markSynced(id, serverId: 501);
      await outbox.completeIfUnchanged((await outbox.claimReady()).single);

      await ledgerLocal.updateLocal(clientId: id, amountInr: 900);
      final int opId = await outbox.enqueue(
        entity: SyncEntity.ledgerEntry,
        op: SyncOpKind.update,
        localRowId: id,
      );

      final SyncOpRow op = (await outbox.claimReady()).firstWhere(
        (SyncOpRow o) => o.id == opId,
      );
      final PushResult result = await dispatcher.push(op);

      expect(result.outcome, PushOutcome.success);
      expect(api.calls, contains('PATCH /api/v1/businesses/7/entries/501'));
      expect((await ledgerLocal.byClientId(id))!.serverId, 501);
    });
  });

  group('profile', () {
    Future<void> seedUser() {
      return profileLocal.upsertFromServer(<String, dynamic>{
        'id': 3,
        'phone_e164': '+919000000000',
        'name': 'Asha',
        'language': 'hi',
        'savings_inr': 0,
        'loan_inr': 0,
        'notifications_enabled': true,
      });
    }

    test('a queued savings edit PATCHes what the row now says', () async {
      await seedUser();
      await profileLocal.updateLocalSavingsLoan(savingsInr: 1200, loanInr: 300);
      final int opId = await outbox.enqueue(
        entity: SyncEntity.savingsLoan,
        op: SyncOpKind.update,
        localRowId: (await profileLocal.activeUser())!.clientId,
        payload: <String, dynamic>{'savings_inr': 1200, 'loan_inr': 300},
      );

      final SyncOpRow op = (await outbox.claimReady()).firstWhere(
        (SyncOpRow o) => o.id == opId,
      );
      expect((await dispatcher.push(op)).outcome, PushOutcome.success);

      expect(api.calls, contains('PATCH /api/v1/me/savings-loan'));
      expect(api.bodies.last, <String, dynamic>{
        'savings_inr': 1200,
        'loan_inr': 300,
      });
    });

    test('going offline mid-queue reports retryable, not permanent', () async {
      await seedUser();
      await profileLocal.updateLocalProfile(name: 'Asha Devi');
      final int opId = await outbox.enqueue(
        entity: SyncEntity.userProfile,
        op: SyncOpKind.update,
        localRowId: (await profileLocal.activeUser())!.clientId,
        payload: <String, dynamic>{'name': 'Asha Devi'},
      );
      api.offline = true;

      final SyncOpRow op = (await outbox.claimReady()).firstWhere(
        (SyncOpRow o) => o.id == opId,
      );
      final PushResult result = await dispatcher.push(op);

      expect(result.outcome, PushOutcome.retryable);
      await outbox.recordFailure(op, error: result.error!, retryable: true);
      expect(await outbox.failedCount(), 0, reason: 'offline is not a refusal');
    });
  });
}
