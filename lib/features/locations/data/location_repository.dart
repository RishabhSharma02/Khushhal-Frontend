/// Reference-data lookups for the location step, served from SQLite.
library;

import 'dart:async';

import '../../auth/data/profile_local_datasource.dart';
import '../../../core/db/app_database.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/sync/outbox_dao.dart';
import '../../../core/sync/sync_op.dart';
import 'location_local_datasource.dart';
import 'location_remote_datasource.dart';

export 'location_remote_datasource.dart' show RemoteState;

/// States, districts, and saving the user's chosen location.
///
/// Reads always come from the local database, which is seeded from a bundled
/// asset before the app has ever been online. The API is used only to refresh
/// that copy in the background, so a slow or dead connection can never leave
/// the location dropdowns empty.
class LocationRepository {
  LocationRepository({
    required LocationLocalDataSource local,
    required LocationRemoteDataSource remote,
    ProfileLocalDataSource? profileLocal,
    OutboxDao? outbox,
  }) : _local = local,
       _remote = remote,
       _profileLocal = profileLocal,
       _outbox = outbox;

  final LocationLocalDataSource _local;
  final LocationRemoteDataSource _remote;
  final ProfileLocalDataSource? _profileLocal;
  final OutboxDao? _outbox;

  bool _refreshed = false;

  /// Every state, from the local table.
  ///
  /// Kicks off a one-per-session background refresh but never waits on it: the
  /// seeded list is complete, so blocking the picker on a network call would
  /// trade a working screen for a spinner.
  Future<List<RemoteState>> listStates() async {
    unawaited(_refreshInBackground());
    return _local.states();
  }

  /// Districts for a state, from the local table.
  Future<List<String>> listDistricts(String stateCode) =>
      _local.districts(stateCode);

  Future<void> _refreshInBackground() async {
    if (_refreshed) return;
    _refreshed = true;
    try {
      final List<RemoteState> states = await _remote.listStates();
      if (states.isEmpty) return;

      // The list endpoint has no districts on it, so fetch them per state. This
      // is the slow path by design — it runs detached from any UI.
      final List<SeedState> seed = <SeedState>[];
      for (final RemoteState s in states) {
        final List<String> districts = await _remote.listDistricts(s.code);
        seed.add(
          SeedState(
            code: s.code,
            nameEn: s.nameEn,
            nameHi: s.nameHi,
            districts: districts,
          ),
        );
      }
      await _local.upsertStates(seed);
    } on ApiException {
      // Offline or the endpoint is down. The seeded copy stands.
    }
  }

  /// Saves the chosen location on the user's profile.
  ///
  /// Writes locally first and queues the PATCH, so changing a location from
  /// Settings works offline. During onboarding the device is online anyway and
  /// the queued op drains on the next cycle, moments later.
  Future<void> saveOnUser({
    required String? state,
    required String? district,
    required String? village,
  }) async {
    final ProfileLocalDataSource? profile = _profileLocal;
    final OutboxDao? outbox = _outbox;
    if (profile == null || outbox == null) return;

    // No-op when the location on the row already matches what would be
    // written: settings and setup screens re-emit the current selection on
    // every rebuild, and enqueueing a PATCH for values the server already
    // has turns into a spurious sync error the moment the device is offline.
    final LocalUser? current = await profile.activeUser();
    if (current != null
        && state == current.state
        && district == current.district
        && village == current.village) {
      return;
    }

    final String? clientId = await profile.updateLocalProfile(
      state: state,
      district: district,
      village: village,
    );
    if (clientId == null) return;

    await outbox.enqueue(
      entity: SyncEntity.userProfile,
      op: SyncOpKind.update,
      localRowId: clientId,
      payload: <String, dynamic>{
        'state': ?state,
        'district': ?district,
        'village': ?village,
      },
    );
  }
}
