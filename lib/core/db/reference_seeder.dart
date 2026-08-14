/// Seeds the states and districts tables from the bundled asset.
library;

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../features/locations/data/location_local_datasource.dart';
import 'app_database.dart';

/// Loads `assets/reference/india_locations.json` into SQLite on first launch.
///
/// Reference data is the one thing in this database that does not come from the
/// user's account, so it is bundled with the app rather than fetched. That is
/// what lets a brand-new install pick a state and district while offline —
/// which matters because the location step sits inside onboarding, and a user
/// on a weak connection should not be blocked from getting that far.
///
/// Seeding is guarded by a version string, so shipping an updated asset
/// re-seeds exactly once and a normal launch does no work at all.
class ReferenceSeeder {
  ReferenceSeeder({
    required AppDatabase db,
    required LocationLocalDataSource local,
    AssetBundle? bundle,
  }) : _db = db,
       _local = local,
       _bundle = bundle ?? rootBundle;

  final AppDatabase _db;
  final LocationLocalDataSource _local;
  final AssetBundle _bundle;

  /// Bump when the bundled asset changes so existing installs re-seed.
  static const String assetVersion = '2026-08-13';

  static const String assetPath = 'assets/reference/india_locations.json';

  /// Seeds if needed. Safe to call on every launch.
  ///
  /// Returns true when rows were written.
  Future<bool> seedIfNeeded() async {
    final String? seeded = await _db.readMeta(SyncMetaKeys.referenceVersion);
    final bool upToDate = seeded == assetVersion;
    // The version key surviving a logout wipe is deliberate, but the tables
    // themselves could still be empty on a database that predates this asset,
    // so check both rather than trusting the key alone.
    if (upToDate && await _local.hasStates()) return false;

    final List<SeedState> states = await _readAsset();
    if (states.isEmpty) return false;

    await _local.upsertStates(states);
    await _db.writeMeta(SyncMetaKeys.referenceVersion, assetVersion);
    return true;
  }

  Future<List<SeedState>> _readAsset() async {
    try {
      final String raw = await _bundle.loadString(assetPath);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return const <SeedState>[];

      final rows = decoded['states'];
      if (rows is! List) return const <SeedState>[];

      return rows
          .whereType<Map<String, dynamic>>()
          .map(SeedState.fromJson)
          .toList(growable: false);
    } on Object {
      // A missing or malformed asset must not stop the app from booting; the
      // location step falls back to fetching from the API when online.
      return const <SeedState>[];
    }
  }
}
