import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khushhal/core/db/app_database.dart';
import 'package:khushhal/core/db/reference_seeder.dart';
import 'package:khushhal/features/locations/data/location_local_datasource.dart';

/// Serves a canned asset and counts how often it was read, which is how these
/// tests tell "seeded once" apart from "seeded every launch".
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.payload);

  String? payload;
  int reads = 0;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    reads++;
    final String? body = payload;
    if (body == null) throw StateError('missing asset: $key');
    return body;
  }

  @override
  Future<ByteData> load(String key) async {
    final String body = await loadString(key);
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(body)));
  }
}

String _asset() {
  return jsonEncode(<String, dynamic>{
    'states': <Map<String, dynamic>>[
      <String, dynamic>{
        'code': 'MH',
        'name_en': 'Maharashtra',
        'name_hi': 'महाराष्ट्र',
        'districts': <String>['Pune', 'Nagpur'],
      },
      <String, dynamic>{
        'code': 'BR',
        'name_en': 'Bihar',
        'districts': <String>['Patna'],
      },
    ],
  });
}

void main() {
  late AppDatabase db;
  late LocationLocalDataSource local;
  late _FakeBundle bundle;
  late ReferenceSeeder seeder;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = LocationLocalDataSource(db);
    bundle = _FakeBundle(_asset());
    seeder = ReferenceSeeder(db: db, local: local, bundle: bundle);
  });

  tearDown(() => db.close());

  test('first launch loads states and districts from the asset', () async {
    expect(await seeder.seedIfNeeded(), isTrue);

    final states = await local.states();
    expect(states.map((s) => s.code).toList(), <String>['BR', 'MH']);
    expect(states.first.nameHi, 'Bihar', reason: 'falls back to the English name');
    expect(await local.districts('MH'), <String>['Nagpur', 'Pune']);
  });

  test('a second launch does no work', () async {
    await seeder.seedIfNeeded();
    final int readsAfterSeed = bundle.reads;

    expect(await seeder.seedIfNeeded(), isFalse);
    expect(bundle.reads, readsAfterSeed);
  });

  test('re-seeding does not duplicate rows', () async {
    await seeder.seedIfNeeded();
    await db.writeMeta(SyncMetaKeys.referenceVersion, 'older');

    expect(await seeder.seedIfNeeded(), isTrue);
    expect(await local.states(), hasLength(2));
    expect(await local.districts('MH'), <String>['Nagpur', 'Pune']);
  });

  test('empty tables re-seed even when the version says otherwise', () async {
    // A database that predates the asset can carry the key without the rows.
    await db.writeMeta(
      SyncMetaKeys.referenceVersion,
      ReferenceSeeder.assetVersion,
    );

    expect(await seeder.seedIfNeeded(), isTrue);
    expect(await local.hasStates(), isTrue);
  });

  test('a missing asset does not stop the app from booting', () async {
    bundle.payload = null;

    expect(await seeder.seedIfNeeded(), isFalse);
    expect(await local.states(), isEmpty);
    expect(await db.readMeta(SyncMetaKeys.referenceVersion), isNull);
  });

  test('malformed json is ignored rather than half-applied', () async {
    bundle.payload = '{"states": "not a list"}';

    expect(await seeder.seedIfNeeded(), isFalse);
    expect(await local.states(), isEmpty);
  });

  test('reference data survives a logout wipe', () async {
    // Keeping it means the next user can pick a location before going online.
    await seeder.seedIfNeeded();

    await db.wipeUserData();

    expect(await local.states(), hasLength(2));
    expect(
      await db.readMeta(SyncMetaKeys.referenceVersion),
      ReferenceSeeder.assetVersion,
    );
  });
}
