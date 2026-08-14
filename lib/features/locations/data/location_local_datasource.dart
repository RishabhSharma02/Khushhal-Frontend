/// Drift-backed store for the states and districts reference data.
library;

import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import 'location_remote_datasource.dart';

/// Local reads and writes for `local_states` and `local_districts`.
class LocationLocalDataSource {
  LocationLocalDataSource(this._db);

  final AppDatabase _db;

  /// Every state, alphabetical by English name.
  Future<List<RemoteState>> states() async {
    final rows = await (_db.select(
      _db.localStates,
    )..orderBy([(t) => OrderingTerm.asc(t.nameEn)])).get();
    return rows
        .map(
          (r) => RemoteState(
            code: r.code,
            nameEn: r.nameEn,
            nameHi: r.nameHi ?? r.nameEn,
          ),
        )
        .toList(growable: false);
  }

  /// District names for one state, alphabetical.
  Future<List<String>> districts(String stateCode) async {
    final rows =
        await (_db.select(_db.localDistricts)
              ..where((t) => t.stateCode.equals(stateCode))
              ..orderBy([(t) => OrderingTerm.asc(t.nameEn)]))
            .get();
    return rows.map((r) => r.nameEn).toList(growable: false);
  }

  /// True once the reference tables hold anything at all.
  Future<bool> hasStates() async {
    final Expression<int> c = _db.localStates.code.count();
    final row = await (_db.selectOnly(_db.localStates)..addColumns([c]))
        .getSingle();
    return (row.read(c) ?? 0) > 0;
  }

  /// Bulk-writes states and their districts.
  ///
  /// Used by both the first-launch asset seed and the background refresh from
  /// `/api/v1/locations/states`, so the two paths cannot drift apart. Existing
  /// rows are replaced rather than deleted first, which keeps the location
  /// picker usable throughout the write.
  Future<void> upsertStates(List<SeedState> seed) async {
    if (seed.isEmpty) return;
    final DateTime now = DateTime.now();
    await _db.batch((batch) {
      for (final SeedState s in seed) {
        batch.insert(
          _db.localStates,
          LocalStatesCompanion.insert(
            code: s.code,
            nameEn: s.nameEn,
            nameHi: Value(s.nameHi),
            fetchedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
        for (final String d in s.districts) {
          batch.insert(
            _db.localDistricts,
            LocalDistrictsCompanion.insert(
              stateCode: s.code,
              nameEn: d,
              fetchedAt: Value(now),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }
}

/// One state and its districts, as read from the bundled asset or the API.
class SeedState {
  const SeedState({
    required this.code,
    required this.nameEn,
    this.nameHi,
    this.districts = const <String>[],
  });

  final String code;
  final String nameEn;
  final String? nameHi;
  final List<String> districts;

  /// Parses a row of the bundled `india_locations.json`.
  factory SeedState.fromJson(Map<String, dynamic> json) {
    final raw = json['districts'];
    return SeedState(
      code: json['code'] as String,
      nameEn: json['name_en'] as String,
      nameHi: json['name_hi'] as String?,
      districts: raw is List
          ? raw.whereType<String>().toList(growable: false)
          : const <String>[],
    );
  }
}
