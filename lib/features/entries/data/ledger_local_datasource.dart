/// Drift-backed local store for ledger entries.
///
/// Every read the UI performs comes from here, and every write lands here
/// first. The network is never on the critical path of a tap.
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../app/model/ledger.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/sync_columns.dart';
import 'ledger_api.dart';

/// Local reads and writes for `local_ledger_entries`.
class LedgerLocalDataSource {
  LedgerLocalDataSource(this._db);

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  // ── Reads ──────────────────────────────────────────────────────────────

  /// Newest-first entries for one business, as a live stream.
  ///
  /// This is what makes an offline save feel instant: the insert into SQLite
  /// pushes a new list down this stream, and the history screen rebuilds
  /// without anyone telling it to.
  Stream<List<LedgerEntry>> watchForBusiness(
    int businessServerId, {
    int limit = 200,
  }) {
    return (_db.select(_db.localLedgerEntries)
          ..where((t) => t.businessServerId.equals(businessServerId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.recordedAt),
            (t) => OrderingTerm.desc(t.localUpdatedAt),
          ])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_toDomain).toList(growable: false));
  }

  /// One-shot read of the same query.
  Future<List<LedgerEntry>> forBusiness(
    int businessServerId, {
    int limit = 200,
  }) async {
    final rows =
        await (_db.select(_db.localLedgerEntries)
              ..where((t) => t.businessServerId.equals(businessServerId))
              ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
              ..limit(limit))
            .get();
    return rows.map(_toDomain).toList(growable: false);
  }

  /// Entries across every business that have not reached the server.
  Future<List<LocalLedgerEntry>> pendingRows() {
    return (_db.select(_db.localLedgerEntries)
          ..where((t) => t.syncState.equalsValue(RowSyncState.synced).not()))
        .get();
  }

  /// Looks a row up by its client UUID.
  Future<LocalLedgerEntry?> byClientId(String clientId) {
    return (_db.select(
      _db.localLedgerEntries,
    )..where((t) => t.clientId.equals(clientId))).getSingleOrNull();
  }

  // ── Local writes ───────────────────────────────────────────────────────

  /// Records a new entry locally and returns its client UUID.
  ///
  /// The UUID doubles as the backend's `client_entry_id`, so replaying this
  /// entry after a half-failed push cannot duplicate it.
  Future<String> insertLocal({
    required int businessServerId,
    required LedgerEntry entry,
    int? ownerUserId,
    String? clientId,
  }) async {
    final String id = clientId ?? _uuid.v4();
    await _db
        .into(_db.localLedgerEntries)
        .insert(
          LocalLedgerEntriesCompanion.insert(
            clientId: id,
            businessServerId: businessServerId,
            ownerUserId: Value(ownerUserId),
            kind: LedgerApiMapper.kind(entry.kind),
            amountInr: entry.amountInr,
            category: LedgerApiMapper.category(entry.category),
            recordedAt: entry.recordedAt,
            source: Value(LedgerApiMapper.source(entry.source)),
            syncState: const Value(RowSyncState.pendingCreate),
            localUpdatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
    return id;
  }

  /// Applies an edit locally.
  ///
  /// A row that has never been sent stays [RowSyncState.pendingCreate]: it
  /// still needs creating, just with different values. Promoting it to
  /// `pendingUpdate` would queue a PATCH against a server id that does not
  /// exist yet.
  Future<void> updateLocal({
    required String clientId,
    int? amountInr,
    String? categoryWire,
    DateTime? recordedAt,
  }) async {
    final LocalLedgerEntry? row = await byClientId(clientId);
    if (row == null) return;

    final RowSyncState next = row.syncState == RowSyncState.pendingCreate
        ? RowSyncState.pendingCreate
        : RowSyncState.pendingUpdate;

    await (_db.update(
      _db.localLedgerEntries,
    )..where((t) => t.clientId.equals(clientId))).write(
      LocalLedgerEntriesCompanion(
        amountInr: amountInr == null ? const Value.absent() : Value(amountInr),
        category: categoryWire == null
            ? const Value.absent()
            : Value(categoryWire),
        recordedAt: recordedAt == null
            ? const Value.absent()
            : Value(recordedAt),
        syncState: Value(next),
        localUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Flags a row whose push was rejected outright, so the Sync screen can show
  /// what was dropped before the next pull overwrites it.
  Future<void> markFailed(String clientId) async {
    await (_db.update(
      _db.localLedgerEntries,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalLedgerEntriesCompanion(syncState: Value(RowSyncState.failed)),
    );
  }

  // ── Server reconciliation ──────────────────────────────────────────────

  /// Marks a row as accepted by the server.
  Future<void> markSynced(
    String clientId, {
    int? serverId,
    DateTime? syncedAt,
  }) async {
    await (_db.update(
      _db.localLedgerEntries,
    )..where((t) => t.clientId.equals(clientId))).write(
      LocalLedgerEntriesCompanion(
        serverId: serverId == null ? const Value.absent() : Value(serverId),
        syncedAt: Value(syncedAt ?? DateTime.now()),
        syncState: const Value(RowSyncState.synced),
      ),
    );
  }

  /// Writes rows from `GET /entries` into the local table, server-wins.
  ///
  /// [protectedClientIds] are rows with an op still in the outbox. Those keep
  /// their local values: the push has not happened yet (or has just failed), so
  /// overwriting them here would throw away the user's unsent edit and make the
  /// pending badge lie. Everything else is replaced wholesale.
  Future<void> upsertFromServer(
    List<Map<String, dynamic>> rows, {
    required Set<String> protectedClientIds,
  }) async {
    if (rows.isEmpty) return;
    await _db.batch((batch) {
      for (final Map<String, dynamic> row in rows) {
        final String? clientId = row['client_entry_id'] as String?;
        if (clientId == null) continue;
        if (protectedClientIds.contains(clientId)) continue;

        final DateTime? syncedAt = switch (row['synced_at']) {
          final String s => DateTime.tryParse(s),
          _ => null,
        };

        batch.insert(
          _db.localLedgerEntries,
          LocalLedgerEntriesCompanion.insert(
            clientId: clientId,
            businessServerId: row['business_id'] as int,
            kind: row['kind'] as String,
            amountInr: row['amount_inr'] as int,
            category: row['category'] as String,
            recordedAt: DateTime.parse(row['recorded_at'] as String),
            source: Value((row['source'] as String?) ?? 'manual'),
            serverId: Value(row['id'] as int?),
            syncedAt: Value(syncedAt),
            syncState: const Value(RowSyncState.synced),
            localUpdatedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Fills in server ids for rows we created, matching on `client_entry_id`.
  ///
  /// The batch sync endpoint returns `accepted_ids` with no indication of which
  /// client id each belongs to, so a subsequent read is the only way to learn
  /// the mapping. Without it an entry created offline could never be edited,
  /// because the PATCH URL needs a server id.
  Future<int> attachServerIds(Map<String, int> serverIdByClientId) async {
    if (serverIdByClientId.isEmpty) return 0;
    int updated = 0;
    await _db.transaction(() async {
      for (final MapEntry<String, int> e in serverIdByClientId.entries) {
        updated +=
            await (_db.update(_db.localLedgerEntries)..where(
                  (t) => t.clientId.equals(e.key) & t.serverId.isNull(),
                ))
                .write(LocalLedgerEntriesCompanion(serverId: Value(e.value)));
      }
    });
    return updated;
  }

  /// Deletes every entry for a business. Used when the server reports the
  /// business gone.
  Future<void> deleteForBusiness(int businessServerId) async {
    await (_db.delete(
      _db.localLedgerEntries,
    )..where((t) => t.businessServerId.equals(businessServerId))).go();
  }

  // ── Mapping ────────────────────────────────────────────────────────────

  LedgerEntry _toDomain(LocalLedgerEntry row) {
    return LedgerEntry(
      kind: LedgerApiMapper.kindFromWire(row.kind),
      amountInr: row.amountInr,
      category: LedgerApiMapper.categoryFromWire(row.category),
      recordedAt: row.recordedAt,
      source: LedgerApiMapper.sourceFromWire(row.source),
      syncState: _toDomainSyncState(row.syncState),
      backendId: row.serverId,
      clientId: row.clientId,
    );
  }

  static EntrySyncState _toDomainSyncState(RowSyncState state) {
    return switch (state) {
      RowSyncState.synced => EntrySyncState.synced,
      RowSyncState.pendingCreate => EntrySyncState.pending,
      RowSyncState.pendingUpdate => EntrySyncState.pending,
      RowSyncState.pendingDelete => EntrySyncState.pending,
      // The domain has no "rejected" state and the history list should not
      // claim a dropped entry is safe. Showing it as pending keeps it visible
      // and un-ticked; the Sync screen carries the actual error text.
      RowSyncState.failed => EntrySyncState.pending,
    };
  }

  /// Builds the `POST /entries/sync` body for a locally-created row.
  static Map<String, dynamic> toSyncPayload(LocalLedgerEntry row) {
    return <String, dynamic>{
      'client_entry_id': row.clientId,
      'kind': row.kind,
      'amount_inr': row.amountInr,
      'category': row.category,
      'recorded_at': row.recordedAt.toUtc().toIso8601String(),
      'source': row.source,
    };
  }
}
