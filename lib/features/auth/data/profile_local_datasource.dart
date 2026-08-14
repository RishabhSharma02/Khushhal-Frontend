/// Drift-backed local store for the signed-in user's profile.
///
/// This table is what makes offline login work. The mPIN check was always
/// local, but the profile behind it only ever arrived from
/// `POST /auth/session`, so an offline unlock had no name to show and the lock
/// gate fell through to the name-capture screen. Mirroring `/me` here closes
/// that hole.
library;

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/sync_columns.dart';

/// Local reads and writes for `local_users`.
class ProfileLocalDataSource {
  ProfileLocalDataSource(this._db);

  final AppDatabase _db;
  static const Uuid _uuid = Uuid();

  // ── Reads ──────────────────────────────────────────────────────────────

  /// The account currently signed in on this device, if any.
  Future<LocalUser?> activeUser() {
    return (_db.select(
      _db.localUsers,
    )..where((t) => t.isActive.equals(true))).getSingleOrNull();
  }

  /// Live view of the active user, for screens that show the name or the
  /// savings and loan tiles.
  Stream<LocalUser?> watchActiveUser() {
    return (_db.select(
      _db.localUsers,
    )..where((t) => t.isActive.equals(true))).watchSingleOrNull();
  }

  /// Whether this device has ever completed onboarding for someone.
  ///
  /// Used alongside the stored mPIN to decide "existing user" — see the note in
  /// `LockCubit.check()` about not treating a keychain failure as a new user.
  Future<bool> hasOnboardedUser() async {
    final LocalUser? user = await activeUser();
    return user != null && (user.name ?? '').trim().isNotEmpty;
  }

  // ── Server reconciliation ──────────────────────────────────────────────

  /// Writes the `/me` payload into the local table and marks it active.
  ///
  /// Server-wins, with one exception: if the row still has an unpushed local
  /// edit ([RowSyncState.pendingUpdate]), the fields the user changed are left
  /// alone. The engine pushes before it pulls, so reaching this branch means
  /// the push failed, and clobbering the edit would lose it silently.
  Future<void> upsertFromServer(
    Map<String, dynamic> me, {
    String? firebaseUid,
    bool preserveLocalEdits = false,
  }) async {
    final int serverId = me['id'] as int;
    final LocalUser? existing = await byServerId(serverId);

    final bool keepLocal =
        preserveLocalEdits && existing?.syncState == RowSyncState.pendingUpdate;
    if (keepLocal) {
      // Still refresh the identity fields, which the device never edits.
      await (_db.update(_db.localUsers)
            ..where((t) => t.serverId.equals(serverId)))
          .write(
            LocalUsersCompanion(
              phoneE164: Value(me['phone_e164'] as String?),
              firebaseUid: firebaseUid == null
                  ? const Value.absent()
                  : Value(firebaseUid),
              isActive: const Value(true),
            ),
          );
      return;
    }

    await _db.transaction(() async {
      // Only one account can be active at a time; a different user signing in
      // must not leave the previous one flagged.
      await _db
          .update(_db.localUsers)
          .write(const LocalUsersCompanion(isActive: Value(false)));

      await _db
          .into(_db.localUsers)
          .insert(
            LocalUsersCompanion.insert(
              clientId: existing?.clientId ?? _uuid.v4(),
              serverId: Value(serverId),
              firebaseUid: Value(firebaseUid ?? existing?.firebaseUid),
              phoneE164: Value(me['phone_e164'] as String?),
              name: Value(me['name'] as String?),
              language: Value((me['language'] as String?) ?? 'hi'),
              state: Value(me['state'] as String?),
              district: Value(me['district'] as String?),
              village: Value(me['village'] as String?),
              savingsInr: Value((me['savings_inr'] as int?) ?? 0),
              loanInr: Value((me['loan_inr'] as int?) ?? 0),
              notificationsEnabled: Value(
                (me['notifications_enabled'] as bool?) ?? true,
              ),
              isActive: const Value(true),
              syncState: const Value(RowSyncState.synced),
              localUpdatedAt: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
  }

  /// Looks up a row by backend id.
  Future<LocalUser?> byServerId(int serverId) {
    return (_db.select(
      _db.localUsers,
    )..where((t) => t.serverId.equals(serverId))).getSingleOrNull();
  }

  // ── Local writes ───────────────────────────────────────────────────────

  /// Applies a profile edit locally and flags it for push.
  ///
  /// Returns the row's client id so the caller can queue an outbox op against
  /// it, or null when there is no active user to edit.
  Future<String?> updateLocalProfile({
    String? name,
    String? language,
    String? state,
    String? district,
    String? village,
    bool? notificationsEnabled,
  }) async {
    final LocalUser? user = await activeUser();
    if (user == null) return null;

    await (_db.update(_db.localUsers)
          ..where((t) => t.clientId.equals(user.clientId)))
        .write(
          LocalUsersCompanion(
            name: name == null ? const Value.absent() : Value(name),
            language: language == null
                ? const Value.absent()
                : Value(language),
            state: state == null ? const Value.absent() : Value(state),
            district: district == null ? const Value.absent() : Value(district),
            village: village == null ? const Value.absent() : Value(village),
            notificationsEnabled: notificationsEnabled == null
                ? const Value.absent()
                : Value(notificationsEnabled),
            syncState: const Value(RowSyncState.pendingUpdate),
            localUpdatedAt: Value(DateTime.now()),
          ),
        );
    return user.clientId;
  }

  /// Applies a savings/loan edit locally and flags it for push.
  Future<String?> updateLocalSavingsLoan({
    required int savingsInr,
    required int loanInr,
  }) async {
    final LocalUser? user = await activeUser();
    if (user == null) return null;

    await (_db.update(_db.localUsers)
          ..where((t) => t.clientId.equals(user.clientId)))
        .write(
          LocalUsersCompanion(
            savingsInr: Value(savingsInr),
            loanInr: Value(loanInr),
            syncState: const Value(RowSyncState.pendingUpdate),
            localUpdatedAt: Value(DateTime.now()),
          ),
        );
    return user.clientId;
  }

  /// Clears the pending flag after a successful push.
  Future<void> markSynced(String clientId) async {
    await (_db.update(
      _db.localUsers,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalUsersCompanion(syncState: Value(RowSyncState.synced)),
    );
  }

  /// Flags a rejected push.
  Future<void> markFailed(String clientId) async {
    await (_db.update(
      _db.localUsers,
    )..where((t) => t.clientId.equals(clientId))).write(
      const LocalUsersCompanion(syncState: Value(RowSyncState.failed)),
    );
  }
}
