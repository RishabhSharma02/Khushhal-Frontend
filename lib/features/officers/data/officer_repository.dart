/// In-memory officer cache in front of `GET /officers/{id}`.
///
/// Officer records rarely change and the home card would otherwise re-fetch
/// on every rebuild. Cache is process-local: switching users or logging out
/// discards it by construction.
library;

import 'dart:async';

import '../../../app/model/assigned_officer.dart';
import 'officer_remote_datasource.dart';

class OfficerRepository {
  OfficerRepository(this._remote);

  final OfficerRemoteDataSource _remote;
  final Map<int, AssignedOfficer> _cache = <int, AssignedOfficer>{};
  final Map<int, Future<AssignedOfficer?>> _inflight =
      <int, Future<AssignedOfficer?>>{};

  /// Returns the cached officer if present. Never touches the network.
  AssignedOfficer? peek(int id) => _cache[id];

  /// Fetches the officer, coalescing concurrent calls for the same id.
  /// Returns null when the server has no such officer or the call fails —
  /// the home card just stays hidden in that case.
  Future<AssignedOfficer?> fetch(int id) async {
    final AssignedOfficer? cached = _cache[id];
    if (cached != null) return cached;

    final Future<AssignedOfficer?>? pending = _inflight[id];
    if (pending != null) return pending;

    final Future<AssignedOfficer?> future = _loadOnce(id);
    _inflight[id] = future;
    try {
      return await future;
    } finally {
      _inflight.remove(id);
    }
  }

  Future<AssignedOfficer?> _loadOnce(int id) async {
    try {
      final remote = await _remote.get(id);
      if (remote == null) return null;
      final AssignedOfficer officer = remote.toDomain();
      _cache[id] = officer;
      return officer;
    } on Object {
      return null;
    }
  }
}
