/// Pre-seeded reference data: Indian states and districts.
///
/// Unlike every other table here these rows are not per-user and are not synced
/// through the outbox. They are bundled with the app as an asset and seeded on
/// first launch so the location step works before the user has ever been
/// online, then refreshed from `/api/v1/locations/states` opportunistically.
library;

import 'package:drift/drift.dart';

import '../sync_columns.dart';

/// A state or union territory.
class LocalStates extends Table with CachedRow {
  /// Two-letter code, e.g. `AP`. Matches the backend's `code`.
  TextColumn get code => text()();

  TextColumn get nameEn => text()();
  TextColumn get nameHi => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

/// A district within a state.
///
/// The backend serves districts as bare names under a state code, with no id of
/// their own, so the natural key is the pair.
class LocalDistricts extends Table with CachedRow {
  TextColumn get stateCode => text()();
  TextColumn get nameEn => text()();

  @override
  Set<Column<Object>> get primaryKey => {stateCode, nameEn};
}
