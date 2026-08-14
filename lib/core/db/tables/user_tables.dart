/// Local mirror of the backend `users` table.
library;

import 'package:drift/drift.dart';

import '../sync_columns.dart';

/// The signed-in user's profile, mirrored from `GET /api/v1/me`.
///
/// Enum-ish fields ([language]) are stored as the backend wire string rather
/// than a Dart enum. Every table in this database follows that rule: the
/// `Remote*` DTOs already carry wire strings, and several of the frontend's
/// `*FromWire` mappers are lossy — `RemoteAlert.toDomainKind()` collapses six
/// backend kinds into three domain kinds, and `_sectorFromWire` folds anything
/// unrecognised into `other`. Storing the domain enum would make a
/// pull-then-push round trip silently rewrite the user's data, so the wire
/// string is the stored form and conversion happens at the edges.
///
/// Savings and loan live here as scalar columns because that is exactly how the
/// backend models them — there is no loans or savings table.
class LocalUsers extends Table with SyncableRow {
  /// Firebase UID from the ID token. The join key for "is this the same person
  /// who was signed in last time?" when starting up offline.
  TextColumn get firebaseUid => text().nullable()();

  /// E.164 phone, e.g. `+919876543210`.
  TextColumn get phoneE164 => text().nullable()();

  /// Display name. Captured once during online onboarding and then never
  /// asked for again — this column is what makes that promise keepable
  /// offline.
  TextColumn get name => text().nullable()();

  /// `hi` | `en`.
  TextColumn get language => text().withDefault(const Constant('hi'))();

  TextColumn get state => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get village => text().nullable()();

  IntColumn get savingsInr => integer().withDefault(const Constant(0))();
  IntColumn get loanInr => integer().withDefault(const Constant(0))();

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  /// True for the row representing the account currently signed in on this
  /// device. Exactly one row should carry this at a time.
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
}
