/// The on-device SQLite database.
///
/// This is a real SQLite file (`khushhal.sqlite` in the app documents
/// directory) with the native engine bundled by `sqlite3_flutter_libs`; Drift
/// only supplies the typed query layer and the `watch()` streams that let the UI
/// rebuild the moment the sync engine writes a row.
///
/// The schema mirrors the backend's Postgres tables for everything that is
/// offline-readable, plus two local-only tables — `sync_ops` (the outbox) and
/// `sync_meta` (bookkeeping) — that have no server counterpart.
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// The generated part file names these enums directly for every `textEnum`
// column, so they have to be visible from this library even though nothing
// below references them.
import '../sync/sync_op.dart';
import 'sync_columns.dart';
import 'tables/business_tables.dart';
import 'tables/insights_tables.dart';
import 'tables/ledger_tables.dart';
import 'tables/reference_tables.dart';
import 'tables/sync_tables.dart';
import 'tables/user_tables.dart';

part 'app_database.g.dart';

/// Keys used in the [SyncMeta] scratchpad.
///
/// Grouped here rather than scattered across callers so it is possible to see
/// everything the sync layer remembers between launches in one place.
abstract final class SyncMetaKeys {
  /// Version of the bundled states/districts asset already seeded.
  static const String referenceVersion = 'reference.version';

  /// Timestamp of the last sync cycle that finished with an empty outbox.
  static const String lastFullSync = 'sync.lastFull';

  /// Timestamp of the last successful pull, per entity: `pull.<entity>`.
  static String lastPull(String entity) => 'pull.$entity';

  /// Set once the legacy Hive ledger outbox has been drained into Drift.
  static const String hiveOutboxDrained = 'migration.hiveOutboxDrained';
}

@DriftDatabase(
  tables: [
    LocalUsers,
    LocalBusinesses,
    LocalMonthlySnapshots,
    LocalLedgerEntries,
    LocalHealthScores,
    LocalForecasts,
    LocalRiskAlerts,
    LocalPlanActions,
    LocalStates,
    LocalDistricts,
    SyncOps,
    SyncMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens (or creates) the database file on device.
  AppDatabase() : super(driftDatabase(name: 'khushhal'));

  /// For tests: hand in `NativeDatabase.memory()` so each test gets a clean
  /// database with no file-system side effects.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Every upgrade adds columns rather than recreating tables: the database
      // holds the outbox, so a wipe-and-rebuild would silently discard writes
      // the user has made but not yet synced.
      if (from < 2) {
        await m.addColumn(localBusinesses, localBusinesses.savingsInr);
        await m.addColumn(localBusinesses, localBusinesses.loanInr);
      }
    },
  );

  // ── SyncMeta helpers ───────────────────────────────────────────────────

  /// Reads a bookkeeping value, or null if it was never written.
  Future<String?> readMeta(String key) async {
    final row = await (select(
      syncMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Writes a bookkeeping value, replacing any previous one.
  Future<void> writeMeta(String key, String? value) async {
    await into(syncMeta).insertOnConflictUpdate(
      SyncMetaData(key: key, value: value, updatedAt: DateTime.now()),
    );
  }

  /// Reads a bookkeeping timestamp.
  Future<DateTime?> readMetaTime(String key) async {
    final raw = await readMeta(key);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  /// Writes a bookkeeping timestamp.
  Future<void> writeMetaTime(String key, DateTime value) =>
      writeMeta(key, value.toIso8601String());

  /// Emits a bookkeeping timestamp whenever it changes, and null until it has
  /// been written at all.
  Stream<DateTime?> watchMetaTime(String key) {
    return (select(syncMeta)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) {
          final raw = row?.value;
          return raw == null ? null : DateTime.tryParse(raw);
        });
  }

  /// Emits the [SyncMetaKeys.lastFullSync] timestamp whenever it changes, so
  /// the Sync screen's "last full sync" line stays live without polling.
  Stream<DateTime?> watchLastFullSync() =>
      watchMetaTime(SyncMetaKeys.lastFullSync);

  // ── Logout ─────────────────────────────────────────────────────────────

  /// Wipes every trace of the signed-in account, leaving the bundled reference
  /// data in place.
  ///
  /// States and districts survive deliberately: they are not user data, they
  /// cost a non-trivial seed to rebuild, and keeping them means the next user
  /// to sign in on this device can pick their location before they are online.
  /// The reference-version key is preserved for the same reason.
  Future<void> wipeUserData() async {
    await transaction(() async {
      await delete(syncOps).go();
      await delete(localLedgerEntries).go();
      await delete(localPlanActions).go();
      await delete(localRiskAlerts).go();
      await delete(localForecasts).go();
      await delete(localHealthScores).go();
      await delete(localMonthlySnapshots).go();
      await delete(localBusinesses).go();
      await delete(localUsers).go();
      await (delete(syncMeta)..where(
            (t) => t.key.isNotValue(SyncMetaKeys.referenceVersion),
          ))
          .go();
    });
  }
}
