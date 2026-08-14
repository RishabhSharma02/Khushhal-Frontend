/// Drift-backed local store for businesses and their monthly baseline.
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../app/model/business.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/sync_columns.dart';
import '../../../core/sync/sync_op.dart';
import 'business_api.dart';

/// A local business row paired with its decoded domain object.
///
/// The business switcher needs both: the domain [Business] to render, and the
/// backend id to scope every other query by.
class LocalBusinessRecord {
  const LocalBusinessRecord({
    required this.clientId,
    required this.serverId,
    required this.business,
    required this.syncState,
  });

  final String clientId;
  final int? serverId;
  final Business business;
  final RowSyncState syncState;

  /// Whether this business has an edit the server has not accepted.
  bool get isPending => syncState.isPending;
}

/// Local reads and writes for `local_businesses` and
/// `local_monthly_snapshots`.
class BusinessLocalDataSource {
  BusinessLocalDataSource(this._db);

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  // ── Reads ──────────────────────────────────────────────────────────────

  /// Live list of the user's businesses in server order.
  Stream<List<LocalBusinessRecord>> watchAll() {
    final query = _db.select(_db.localBusinesses)
      ..orderBy([
        (t) => OrderingTerm.asc(t.sortOrder),
        (t) => OrderingTerm.asc(t.clientId),
      ]);
    return query.watch().asyncMap(_withSnapshots);
  }

  /// Emits when `GET /businesses` last succeeded on this device, and null
  /// until it ever has.
  ///
  /// An empty [watchAll] is ambiguous on its own — a device that has never
  /// reached the server looks exactly like an account with no businesses — so
  /// callers that act on emptiness need this to tell the two apart.
  Stream<DateTime?> watchServerPullTime() =>
      _db.watchMetaTime(SyncMetaKeys.lastPull(SyncEntity.business.name));

  /// One-shot read of the same list.
  Future<List<LocalBusinessRecord>> all() async {
    final rows =
        await (_db.select(_db.localBusinesses)..orderBy([
              (t) => OrderingTerm.asc(t.sortOrder),
              (t) => OrderingTerm.asc(t.clientId),
            ]))
            .get();
    return _withSnapshots(rows);
  }

  /// Backend ids of every cached business — the set the sync engine iterates
  /// when pulling per-business data.
  Future<List<int>> serverIds() async {
    final rows = await (_db.select(
      _db.localBusinesses,
    )..where((t) => t.serverId.isNotNull())).get();
    return rows.map((r) => r.serverId!).toList(growable: false);
  }

  Future<LocalBusiness?> byServerId(int serverId) {
    return (_db.select(
      _db.localBusinesses,
    )..where((t) => t.serverId.equals(serverId))).getSingleOrNull();
  }

  Future<LocalBusiness?> byClientId(String clientId) {
    return (_db.select(
      _db.localBusinesses,
    )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();
  }

  Future<List<LocalBusinessRecord>> _withSnapshots(
    List<LocalBusiness> rows,
  ) async {
    if (rows.isEmpty) return const <LocalBusinessRecord>[];

    final List<int> ids = rows
        .where((r) => r.serverId != null)
        .map((r) => r.serverId!)
        .toList(growable: false);

    final snapshots = ids.isEmpty
        ? const <LocalMonthlySnapshot>[]
        : await (_db.select(_db.localMonthlySnapshots)
                ..where((t) => t.businessServerId.isIn(ids))
                ..orderBy([(t) => OrderingTerm.desc(t.month)]))
              .get();

    // Keep only the newest snapshot per business — the backend's
    // `latest_snapshot` semantics.
    final Map<int, LocalMonthlySnapshot> latest =
        <int, LocalMonthlySnapshot>{};
    for (final LocalMonthlySnapshot s in snapshots) {
      latest.putIfAbsent(s.businessServerId, () => s);
    }

    return rows
        .map(
          (r) => LocalBusinessRecord(
            clientId: r.clientId,
            serverId: r.serverId,
            syncState: r.syncState,
            business: _toDomain(
              r,
              r.serverId == null ? null : latest[r.serverId],
            ),
          ),
        )
        .toList(growable: false);
  }

  // ── Server reconciliation ──────────────────────────────────────────────

  /// Replaces the cached business list with the server's, server-wins.
  ///
  /// Businesses removed on the server are deleted locally, along with their
  /// snapshots — but only when they have no pending local edit, so a failed
  /// push is never mistaken for a deletion.
  Future<void> replaceFromServer(
    List<RemoteBusiness> remote, {
    int? ownerUserId,
    Set<String> protectedClientIds = const <String>{},
  }) async {
    await _db.transaction(() async {
      final List<LocalBusiness> existing = await _db
          .select(_db.localBusinesses)
          .get();
      final Map<int, LocalBusiness> byServer = <int, LocalBusiness>{
        for (final LocalBusiness b in existing)
          if (b.serverId != null) b.serverId!: b,
      };

      for (int i = 0; i < remote.length; i++) {
        final RemoteBusiness r = remote[i];
        final LocalBusiness? prior = byServer[r.id];

        if (prior != null && protectedClientIds.contains(prior.clientId)) {
          // Keep the unsent edit, but still record the server's ordering.
          await (_db.update(_db.localBusinesses)
                ..where((t) => t.clientId.equals(prior.clientId)))
              .write(LocalBusinessesCompanion(sortOrder: Value(i)));
          await _upsertSnapshot(r);
          continue;
        }

        await _db
            .into(_db.localBusinesses)
            .insert(
              LocalBusinessesCompanion.insert(
                clientId: prior?.clientId ?? _uuid.v4(),
                serverId: Value(r.id),
                ownerUserId: Value(ownerUserId ?? prior?.ownerUserId),
                name: r.name,
                segment: r.segment,
                sector: r.sector,
                tenure: r.tenure,
                staffCount: Value(r.staffCount),
                isNewBusiness: Value(r.isNewBusiness),
                yearsInOperation: Value(r.yearsInOperation),
                // A backend without the per-business money columns says
                // nothing about savings, which is not the same as saying
                // zero — keep what this device already knows.
                savingsInr: Value(
                  r.carriesMoney ? r.savingsInr : (prior?.savingsInr ?? 0),
                ),
                loanInr: Value(
                  r.carriesMoney ? r.loanInr : (prior?.loanInr ?? 0),
                ),
                sortOrder: Value(i),
                syncState: const Value(RowSyncState.synced),
                localUpdatedAt: Value(DateTime.now()),
              ),
              mode: InsertMode.insertOrReplace,
            );
        await _upsertSnapshot(r);
      }

      final Set<int> serverIds = remote.map((r) => r.id).toSet();
      for (final LocalBusiness b in existing) {
        final bool gone = b.serverId != null && !serverIds.contains(b.serverId);
        if (!gone) continue;
        if (protectedClientIds.contains(b.clientId)) continue;
        await (_db.delete(_db.localBusinesses)
              ..where((t) => t.clientId.equals(b.clientId)))
            .go();
        await (_db.delete(_db.localMonthlySnapshots)
              ..where((t) => t.businessServerId.equals(b.serverId!)))
            .go();
      }
    });
  }

  Future<void> _upsertSnapshot(RemoteBusiness r) async {
    final MonthlyMoney? snap = r.latestSnapshot;
    if (snap == null) return;
    final DateTime now = DateTime.now();
    final DateTime month = snap.month == null
        ? DateTime(now.year, now.month)
        : DateTime(snap.month!.year, snap.month!.month);

    // The server only ever sends `latest_snapshot`, so this table holds one row
    // per business. Clearing the others keeps a stale month — including rows an
    // earlier build stamped with the wrong month — from shadowing the real one.
    await (_db.delete(_db.localMonthlySnapshots)..where(
          (t) => t.businessServerId.equals(r.id) & t.month.isNotValue(month),
        ))
        .go();

    await _db
        .into(_db.localMonthlySnapshots)
        .insert(
          LocalMonthlySnapshotsCompanion.insert(
            businessServerId: r.id,
            month: month,
            moneyIn: Value(snap.moneyIn),
            moneyOut: Value(snap.moneyOut),
            loanEmi: Value(snap.loanEmi),
            savings: Value(snap.savings),
            basis: Value(BusinessApiMapper.basis(snap.basis)),
            fetchedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Inserts a business that was just created on the server.
  ///
  /// Creation is online-only, so this always has a server id in hand.
  ///
  /// [savingsInr] and [loanInr] override what the create response echoed —
  /// the caller knows the figures the user typed, which is the better answer
  /// when the server's own copy is missing.
  Future<String> insertCreated(
    RemoteBusiness r, {
    int? ownerUserId,
    int? savingsInr,
    int? loanInr,
  }) async {
    final String clientId = _uuid.v4();
    final int count = await _countRows();
    await _db
        .into(_db.localBusinesses)
        .insert(
          LocalBusinessesCompanion.insert(
            clientId: clientId,
            serverId: Value(r.id),
            ownerUserId: Value(ownerUserId),
            name: r.name,
            segment: r.segment,
            sector: r.sector,
            tenure: r.tenure,
            staffCount: Value(r.staffCount),
            isNewBusiness: Value(r.isNewBusiness),
            yearsInOperation: Value(r.yearsInOperation),
            savingsInr: Value(savingsInr ?? r.savingsInr),
            loanInr: Value(loanInr ?? r.loanInr),
            sortOrder: Value(count),
            syncState: const Value(RowSyncState.synced),
            localUpdatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
    await _upsertSnapshot(r);
    return clientId;
  }

  Future<int> _countRows() async {
    final Expression<int> c = _db.localBusinesses.clientId.count();
    final row = await (_db.selectOnly(_db.localBusinesses)..addColumns([c]))
        .getSingle();
    return row.read(c) ?? 0;
  }

  // ── Local writes ───────────────────────────────────────────────────────

  /// Applies an edit from the Settings sheet or the savings & loan screen
  /// locally, flagged for push.
  Future<void> updateLocal({
    required String clientId,
    String? name,
    int? staffCount,
    String? tenureWire,
    int? savingsInr,
    int? loanInr,
  }) async {
    await (_db.update(
      _db.localBusinesses,
    )..where((t) => t.clientId.equals(clientId))).write(
      LocalBusinessesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        staffCount: staffCount == null
            ? const Value.absent()
            : Value(staffCount),
        tenure: tenureWire == null ? const Value.absent() : Value(tenureWire),
        savingsInr: savingsInr == null
            ? const Value.absent()
            : Value(savingsInr),
        loanInr: loanInr == null ? const Value.absent() : Value(loanInr),
        syncState: const Value(RowSyncState.pendingUpdate),
        localUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> markSynced(String clientId) async {
    await (_db.update(
      _db.localBusinesses,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalBusinessesCompanion(syncState: Value(RowSyncState.synced)),
    );
  }

  Future<void> markFailed(String clientId) async {
    await (_db.update(
      _db.localBusinesses,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalBusinessesCompanion(syncState: Value(RowSyncState.failed)),
    );
  }

  // ── Mapping ────────────────────────────────────────────────────────────

  Business _toDomain(LocalBusiness row, LocalMonthlySnapshot? snap) {
    return RemoteBusiness(
      id: row.serverId ?? 0,
      name: row.name,
      segment: row.segment,
      sector: row.sector,
      tenure: row.tenure,
      staffCount: row.staffCount,
      isNewBusiness: row.isNewBusiness,
      yearsInOperation: row.yearsInOperation,
      savingsInr: row.savingsInr,
      loanInr: row.loanInr,
      latestSnapshot: snap == null
          ? null
          : MonthlyMoney(
              moneyIn: snap.moneyIn,
              moneyOut: snap.moneyOut,
              loanEmi: snap.loanEmi,
              savings: snap.savings,
              basis: snap.basis == 'records'
                  ? MoneyBasis.fromRecords
                  : MoneyBasis.roughEstimate,
              month: snap.month,
            ),
    ).toDomain();
  }
}
