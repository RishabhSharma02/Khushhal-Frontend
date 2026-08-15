/// Builds and wires every long-lived object the app needs.
library;

import 'package:firebase_auth/firebase_auth.dart';

import '../core/db/app_database.dart';
import '../core/db/reference_seeder.dart';
import '../core/network/api_client.dart';
import '../core/sync/connectivity_monitor.dart';
import '../core/sync/outbox_dao.dart';
import '../core/sync/pull_handlers.dart';
import '../core/sync/push_handlers.dart';
import '../core/sync/sync_engine.dart';
import '../core/sync/sync_status.dart';
import '../features/auth/data/mpin_repository.dart';
import '../features/auth/data/profile_local_datasource.dart';
import '../features/auth/data/profile_remote_datasource.dart';
import '../features/auth/data/profile_repository.dart';
import '../features/businesses/data/business_local_datasource.dart';
import '../features/businesses/data/business_remote_datasource.dart';
import '../features/businesses/data/business_repository.dart';
import '../features/entries/data/ledger_local_datasource.dart';
import '../features/entries/data/ledger_outbox.dart';
import '../features/entries/data/ledger_remote_datasource.dart';
import '../features/entries/data/ledger_repository.dart';
import '../features/entries/data/legacy_outbox_migration.dart';
import '../features/insights/data/insights_local_datasource.dart';
import '../features/insights/data/insights_remote_datasource.dart';
import '../features/insights/data/insights_repository.dart';
import '../features/locations/data/location_local_datasource.dart';
import '../features/locations/data/location_remote_datasource.dart';
import '../features/locations/data/location_repository.dart';
import '../features/officers/data/officer_remote_datasource.dart';
import '../features/officers/data/officer_repository.dart';
import '../features/settings/data/language_prefs.dart';

/// Everything `main()` builds once and hands to the widget tree.
///
/// Gathered here rather than inline in `main()` because the offline stack has
/// real ordering constraints — the database must exist before the outbox, the
/// outbox before the engine, and the legacy Hive drain has to finish before the
/// engine starts pushing — and those are much easier to see, and to get right,
/// in one place.
class AppDependencies {
  AppDependencies._({
    required this.db,
    required this.apiClient,
    required this.connectivity,
    required this.syncStatus,
    required this.outbox,
    required this.syncEngine,
    required this.ledgerRepository,
    required this.businessRepository,
    required this.insightsRepository,
    required this.locationRepository,
    required this.profileRepository,
    required this.officerRepository,
    required this.mpinRepository,
    required this.languagePrefs,
    required this.legacyLedgerOutbox,
  });

  final AppDatabase db;
  final ApiClient apiClient;
  final ConnectivityMonitor connectivity;
  final SyncStatusController syncStatus;
  final OutboxDao outbox;
  final SyncEngine syncEngine;
  final LedgerRepository ledgerRepository;
  final BusinessRepository businessRepository;
  final InsightsRepository insightsRepository;
  final LocationRepository locationRepository;
  final ProfileRepository profileRepository;
  final OfficerRepository officerRepository;
  final MpinRepository mpinRepository;
  final LanguagePrefs languagePrefs;

  /// Kept only so logout can clear it; no new writes go here.
  final LedgerOutbox legacyLedgerOutbox;

  /// Constructs the graph and performs first-launch work.
  static Future<AppDependencies> boot({
    required bool firebaseReady,
    required LedgerOutbox legacyOutbox,
  }) async {
    final AppDatabase db = AppDatabase();
    final OutboxDao outbox = OutboxDao(db);
    final SyncStatusController syncStatus = SyncStatusController();
    final ConnectivityMonitor connectivity = ConnectivityMonitor();

    // The client asks the monitor whether to bother trying, so an offline tap
    // fails in microseconds instead of after a 10-second connect timeout.
    final ApiClient apiClient = ApiClient(
      auth: firebaseReady ? FirebaseAuth.instance : null,
      isOnline: () => connectivity.isOnline.value,
    );

    final ledgerLocal = LedgerLocalDataSource(db);
    final ledgerRemote = LedgerRemoteDataSource(apiClient);
    final businessLocal = BusinessLocalDataSource(db);
    final businessRemote = BusinessRemoteDataSource(apiClient);
    final profileLocal = ProfileLocalDataSource(db);
    final profileRemote = ProfileRemoteDataSource(apiClient);
    final insightsLocal = InsightsLocalDataSource(db);
    final insightsRemote = InsightsRemoteDataSource(apiClient);
    final locationLocal = LocationLocalDataSource(db);
    final locationRemote = LocationRemoteDataSource(apiClient);
    final officerRemote = OfficerRemoteDataSource(apiClient);

    // States and districts ship with the app, so the location step works on a
    // device that has never reached the backend.
    await ReferenceSeeder(db: db, local: locationLocal).seedIfNeeded();

    // Carry over any entries stranded in the old Hive outbox by an upgrade
    // that happened while the user was offline. Must complete before the
    // engine starts, or those entries would miss the first drain.
    await LegacyOutboxMigration(
      db: db,
      local: ledgerLocal,
      outbox: outbox,
    ).run(legacyOutbox);

    final push = PushDispatcher(
      ledgerLocal: ledgerLocal,
      ledgerRemote: ledgerRemote,
      businessLocal: businessLocal,
      businessRemote: businessRemote,
      profileLocal: profileLocal,
      profileRemote: profileRemote,
      insightsLocal: insightsLocal,
      insightsRemote: insightsRemote,
    );

    final pull = PullService(
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
    );

    final SyncEngine engine = SyncEngine(
      db: db,
      outbox: outbox,
      push: push,
      pull: pull,
      connectivity: connectivity,
      status: syncStatus,
      ledgerLocal: ledgerLocal,
    );

    await connectivity.start();
    await engine.start();

    return AppDependencies._(
      db: db,
      apiClient: apiClient,
      connectivity: connectivity,
      syncStatus: syncStatus,
      outbox: outbox,
      syncEngine: engine,
      ledgerRepository: LedgerRepository(local: ledgerLocal, outbox: outbox),
      businessRepository: BusinessRepository(
        local: businessLocal,
        remote: businessRemote,
        outbox: outbox,
        profileLocal: profileLocal,
      ),
      insightsRepository: InsightsRepository(
        local: insightsLocal,
        remote: insightsRemote,
        outbox: outbox,
      ),
      locationRepository: LocationRepository(
        local: locationLocal,
        remote: locationRemote,
        profileLocal: profileLocal,
        outbox: outbox,
      ),
      profileRepository: ProfileRepository(
        local: profileLocal,
        remote: profileRemote,
        outbox: outbox,
      ),
      officerRepository: OfficerRepository(officerRemote),
      mpinRepository: MpinRepository(),
      languagePrefs: await LanguagePrefs.open(),
      legacyLedgerOutbox: legacyOutbox,
    );
  }

  /// Signs the user out and clears their data from the device.
  ///
  /// Attempts a final sync first and reports how many writes were still
  /// unsent, so the caller can warn before anything is discarded. The mPIN is
  /// cleared too: leaving it behind would let the next person unlock into an
  /// empty database and look like the previous user.
  Future<int> logout({required bool firebaseReady}) async {
    final int unsent = await syncEngine.flushBeforeLogout();

    await db.wipeUserData();
    await mpinRepository.clear();
    await legacyLedgerOutbox.clear();
    if (firebaseReady) await FirebaseAuth.instance.signOut();

    syncStatus.setCounts(pending: 0, failed: 0);
    return unsent;
  }

  /// Releases timers, listeners and the database handle.
  Future<void> dispose() async {
    syncEngine.dispose();
    connectivity.dispose();
    syncStatus.dispose();
    await db.close();
  }
}
