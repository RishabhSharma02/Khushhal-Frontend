/// Refreshes the local database from the server.
///
/// Every method here is server-wins with one carve-out: rows that still have an
/// op in the outbox keep their local values. The engine always pushes before it
/// pulls, so a row can only still be pending here if its push failed — and
/// overwriting it in that state would silently discard the user's edit and make
/// the pending badge disappear without the change ever having been saved.
library;

import '../../features/auth/data/profile_local_datasource.dart';
import '../../features/auth/data/profile_remote_datasource.dart';
import '../../features/businesses/data/business_local_datasource.dart';
import '../../features/businesses/data/business_remote_datasource.dart';
import '../../features/entries/data/ledger_local_datasource.dart';
import '../../features/entries/data/ledger_remote_datasource.dart';
import '../../features/insights/data/insights_local_datasource.dart';
import '../../features/insights/data/insights_remote_datasource.dart';
import '../db/app_database.dart';
import '../network/api_exception.dart';
import 'outbox_dao.dart';
import 'sync_op.dart';

/// Pulls server state into SQLite.
class PullService {
  PullService({
    required AppDatabase db,
    required OutboxDao outbox,
    required LedgerLocalDataSource ledgerLocal,
    required LedgerRemoteDataSource ledgerRemote,
    required BusinessLocalDataSource businessLocal,
    required BusinessRemoteDataSource businessRemote,
    required ProfileLocalDataSource profileLocal,
    required ProfileRemoteDataSource profileRemote,
    required InsightsLocalDataSource insightsLocal,
    required InsightsRemoteDataSource insightsRemote,
  }) : _db = db,
       _outbox = outbox,
       _ledgerLocal = ledgerLocal,
       _ledgerRemote = ledgerRemote,
       _businessLocal = businessLocal,
       _businessRemote = businessRemote,
       _profileLocal = profileLocal,
       _profileRemote = profileRemote,
       _insightsLocal = insightsLocal,
       _insightsRemote = insightsRemote;

  final AppDatabase _db;
  final OutboxDao _outbox;
  final LedgerLocalDataSource _ledgerLocal;
  final LedgerRemoteDataSource _ledgerRemote;
  final BusinessLocalDataSource _businessLocal;
  final BusinessRemoteDataSource _businessRemote;
  final ProfileLocalDataSource _profileLocal;
  final ProfileRemoteDataSource _profileRemote;
  final InsightsLocalDataSource _insightsLocal;
  final InsightsRemoteDataSource _insightsRemote;

  /// Refreshes everything the signed-in user can see.
  ///
  /// Individual failures are swallowed on purpose: a pull is a best-effort
  /// refresh of a cache that already has usable data in it, so one dead
  /// endpoint should not abort the rest or surface an error over a screen that
  /// is rendering perfectly good cached content.
  Future<void> pullAll({String? firebaseUid}) async {
    await _guard(() => pullProfile(firebaseUid: firebaseUid));
    await _guard(pullBusinesses);

    final List<int> businessIds = await _businessLocal.serverIds();
    for (final int id in businessIds) {
      await _guard(() => pullLedger(id));
      await _guard(() => pullInsights(id));
    }
  }

  /// `GET /me` into `local_users`.
  Future<void> pullProfile({String? firebaseUid}) async {
    final Map<String, dynamic> me = await _profileRemote.me();
    final Set<String> pending = await _pendingIds(SyncEntity.userProfile);
    final Set<String> pendingMoney = await _pendingIds(SyncEntity.savingsLoan);

    await _profileLocal.upsertFromServer(
      me,
      firebaseUid: firebaseUid,
      preserveLocalEdits: pending.isNotEmpty || pendingMoney.isNotEmpty,
    );
    await _stamp(SyncEntity.userProfile.name);
  }

  /// `GET /businesses` into `local_businesses` plus their snapshots.
  Future<void> pullBusinesses() async {
    final remote = await _businessRemote.list();
    final Set<String> protected = await _pendingIds(SyncEntity.business);
    final LocalUser? user = await _profileLocal.activeUser();

    await _businessLocal.replaceFromServer(
      remote,
      ownerUserId: user?.serverId,
      protectedClientIds: protected,
    );
    await _stamp(SyncEntity.business.name);
  }

  /// Paginated `GET /entries` into `local_ledger_entries`.
  ///
  /// Walks the cursor rather than taking only the first page, because an
  /// account that has been offline for a fortnight can easily have more history
  /// than one page holds, and a partial pull would leave gaps in the list the
  /// user scrolls.
  Future<void> pullLedger(int businessServerId, {int maxPages = 5}) async {
    final Set<String> protected = await _pendingIds(SyncEntity.ledgerEntry);

    int? cursor;
    for (int page = 0; page < maxPages; page++) {
      final result = await _ledgerRemote.list(
        businessId: businessServerId,
        limit: 200,
        cursor: cursor,
      );
      await _ledgerLocal.upsertFromServer(
        result.items,
        protectedClientIds: protected,
      );

      final String? next = result.nextCursor;
      if (next == null) break;
      cursor = int.tryParse(next);
      if (cursor == null) break;
    }
    await _stamp('${SyncEntity.ledgerEntry.name}.$businessServerId');
  }

  /// Health, forecast and alerts for one business.
  Future<void> pullInsights(int businessServerId) async {
    final health = await _insightsRemote.getHealth(businessServerId);
    if (health != null) await _insightsLocal.upsertHealth(health);

    final forecast = await _insightsRemote.getForecast(businessServerId);
    if (forecast != null) await _insightsLocal.upsertForecast(forecast);

    final alerts = await _insightsRemote.getAlerts(businessServerId);
    await _insightsLocal.replaceAlerts(businessServerId, alerts);

    await _stamp('insights.$businessServerId');
  }

  /// One alert's detail, including the plan actions the user can tick.
  Future<void> pullAlertDetail(int businessServerId, int alertServerId) async {
    final alert = await _insightsRemote.getAlertDetail(
      businessServerId,
      alertServerId,
    );
    final Set<String> protected = await _pendingIds(SyncEntity.planAction);
    await _insightsLocal.upsertAlertDetail(
      alert,
      protectedClientIds: protected,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  Future<Set<String>> _pendingIds(SyncEntity entity) =>
      _outbox.pendingRowIds(entity);

  Future<void> _stamp(String entity) =>
      _db.writeMetaTime(SyncMetaKeys.lastPull(entity), DateTime.now());

  Future<void> _guard(Future<void> Function() body) async {
    try {
      await body();
    } on ApiException {
      // Expected on a flaky connection; the cache keeps serving.
    } on Object {
      // A decode failure on one endpoint should not stop the others.
    }
  }
}
