import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khushhal/app/model/ledger.dart';
import 'package:khushhal/core/db/app_database.dart';
import 'package:khushhal/core/db/sync_columns.dart';
import 'package:khushhal/features/entries/data/ledger_local_datasource.dart';

void main() {
  late AppDatabase db;
  late LedgerLocalDataSource local;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = LedgerLocalDataSource(db);
  });

  tearDown(() => db.close());

  LedgerEntry entry({
    int amount = 100,
    EntryKind kind = EntryKind.moneyIn,
    DateTime? at,
  }) {
    return LedgerEntry(
      kind: kind,
      amountInr: amount,
      category: EntryCategory.milkSale,
      recordedAt: at ?? DateTime(2026, 8, 13, 10),
    );
  }

  test('a new entry is stored pending and reads back immediately', () async {
    final String id = await local.insertLocal(
      businessServerId: 7,
      entry: entry(amount: 250),
    );

    final List<LedgerEntry> rows = await local.forBusiness(7);
    expect(rows, hasLength(1));
    expect(rows.single.amountInr, 250);
    expect(rows.single.clientId, id);
    expect(rows.single.syncState, EntrySyncState.pending);
    expect(rows.single.backendId, isNull);
  });

  test('editing an unsent entry keeps it a create, not an update', () async {
    // A PATCH would have no server id to aim at, so the row has to stay
    // pendingCreate and let the outbox fold the edit into the create.
    final String id = await local.insertLocal(
      businessServerId: 7,
      entry: entry(amount: 100),
    );

    await local.updateLocal(clientId: id, amountInr: 400);

    final LocalLedgerEntry? row = await local.byClientId(id);
    expect(row!.amountInr, 400);
    expect(row.syncState, RowSyncState.pendingCreate);
  });

  test('editing a synced entry marks it for update', () async {
    final String id = await local.insertLocal(
      businessServerId: 7,
      entry: entry(),
    );
    await local.markSynced(id, serverId: 42);

    await local.updateLocal(clientId: id, amountInr: 500);

    final LocalLedgerEntry? row = await local.byClientId(id);
    expect(row!.syncState, RowSyncState.pendingUpdate);
    expect(row.serverId, 42);
  });

  test('server ids attach by client id after a batch push', () async {
    final String a = await local.insertLocal(
      businessServerId: 7,
      entry: entry(amount: 10),
    );
    final String b = await local.insertLocal(
      businessServerId: 7,
      entry: entry(amount: 20),
    );

    final int updated = await local.attachServerIds(<String, int>{
      a: 101,
      b: 102,
    });

    expect(updated, 2);
    expect((await local.byClientId(a))!.serverId, 101);
    expect((await local.byClientId(b))!.serverId, 102);
  });

  test('attachServerIds never overwrites an id already known', () async {
    final String id = await local.insertLocal(
      businessServerId: 7,
      entry: entry(),
    );
    await local.markSynced(id, serverId: 55);

    await local.attachServerIds(<String, int>{id: 999});

    expect((await local.byClientId(id))!.serverId, 55);
  });

  group('server-wins pull', () {
    Map<String, dynamic> serverRow(String clientId, int amount) {
      return <String, dynamic>{
        'id': 900,
        'business_id': 7,
        'client_entry_id': clientId,
        'kind': 'in',
        'amount_inr': amount,
        'category': 'milk_sale',
        'recorded_at': '2026-08-13T10:00:00Z',
        'source': 'manual',
        'synced_at': '2026-08-13T10:05:00Z',
      };
    }

    test('overwrites a local row that has nothing queued', () async {
      final String id = await local.insertLocal(
        businessServerId: 7,
        entry: entry(amount: 100),
      );
      await local.markSynced(id, serverId: 900);

      await local.upsertFromServer(<Map<String, dynamic>>[
        serverRow(id, 777),
      ], protectedClientIds: const <String>{});

      final LocalLedgerEntry? row = await local.byClientId(id);
      expect(row!.amountInr, 777);
      expect(row.syncState, RowSyncState.synced);
    });

    test('leaves a row alone while its edit is still queued', () async {
      // Server-wins is about resolving stale data, not about discarding a
      // change the user made that has not been pushed yet.
      final String id = await local.insertLocal(
        businessServerId: 7,
        entry: entry(amount: 100),
      );

      await local.upsertFromServer(<Map<String, dynamic>>[
        serverRow(id, 777),
      ], protectedClientIds: <String>{id});

      final LocalLedgerEntry? row = await local.byClientId(id);
      expect(row!.amountInr, 100);
      expect(row.syncState, RowSyncState.pendingCreate);
    });

    test('inserts rows this device has never seen', () async {
      await local.upsertFromServer(<Map<String, dynamic>>[
        serverRow('from-another-phone', 300),
      ], protectedClientIds: const <String>{});

      final List<LedgerEntry> rows = await local.forBusiness(7);
      expect(rows, hasLength(1));
      expect(rows.single.syncState, EntrySyncState.synced);
    });
  });

  test('the history stream emits when a row is written', () async {
    final Future<List<LedgerEntry>> populated = local
        .watchForBusiness(7)
        .firstWhere((List<LedgerEntry> rows) => rows.isNotEmpty);

    await local.insertLocal(businessServerId: 7, entry: entry(amount: 60));

    expect((await populated).single.amountInr, 60);
  });

  test('pendingRows spans every business', () async {
    await local.insertLocal(businessServerId: 7, entry: entry());
    final String synced = await local.insertLocal(
      businessServerId: 8,
      entry: entry(),
    );
    await local.markSynced(synced, serverId: 1);
    await local.insertLocal(businessServerId: 9, entry: entry());

    expect(await local.pendingRows(), hasLength(2));
  });
}
