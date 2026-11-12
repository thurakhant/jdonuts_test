import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/catalog/asset_catalog_source.dart';
import 'package:jdonuts_test/core/catalog/catalog_json.dart';
import 'package:jdonuts_test/core/catalog/catalog_sync.dart';
import 'package:jdonuts_test/core/db/app_database.dart';
import 'package:jdonuts_test/core/failure.dart';

import '../support/test_app.dart';

final _seed = File('assets/seed/catalog.json').readAsStringSync();

AssetCatalogSource _source(String text) =>
    AssetCatalogSource(load: () async => text);

String _withVersion(int version) =>
    _seed.replaceFirst(RegExp(r'"version": \d+'), '"version": $version');

/// The seed as an app-version-1 payload: same version, no challenges section.
String _withoutChallenges() {
  final root = jsonDecode(_seed) as Map<String, dynamic>;
  (root['data'] as Map<String, dynamic>).remove('challenges');
  return jsonEncode(root);
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> count() async => (await db.select(db.products).get()).length;
  Future<String?> storedVersion() async => (await (db.select(
    db.keyValues,
  )..where((t) => t.key.equals(kCatalogVersionKey))).getSingleOrNull())?.value;

  test('the bundled seed parses', () {
    final snapshot = parseCatalog(_seed).valueOrNull!;
    expect(snapshot.version, 2);
    expect(snapshot.products.length, 10);
    expect(snapshot.banners.length, 3);
    expect(snapshot.shops.length, 4);
    expect(snapshot.member.tier, 'Silver');
    expect(snapshot.challenges!.map((c) => c.progress), [4, 1, 9]);
  });

  test('first launch imports once and records the version', () async {
    final source = CountingSource(_source(_seed));
    final sync = CatalogSync(database: db, source: source);

    expect((await sync.seedIfNeeded()).isSuccess, isTrue);
    expect((await sync.seedIfNeeded()).isSuccess, isTrue);

    expect(source.fetches, 1);
    expect(await count(), 10);
    expect((await db.select(db.challenges).get()).length, 3);
    expect(await storedVersion(), '2');
  });

  test('refresh with the same version is idempotent', () async {
    final sync = CatalogSync(database: db, source: _source(_seed));
    await sync.seedIfNeeded();
    await sync.refresh();
    await sync.refresh();

    expect(await count(), 10);
    expect((await db.select(db.banners).get()).length, 3);
    expect((await db.select(db.members).get()).length, 1);
  });

  test('refresh applies a newer version, ignores an older one', () async {
    await CatalogSync(database: db, source: _source(_withVersion(3))).refresh();
    expect(await storedVersion(), '3');

    await CatalogSync(database: db, source: _source(_withVersion(2))).refresh();
    expect(await storedVersion(), '3');
  });

  test('an install seeded before challenges existed heals on start', () async {
    // v1 app: catalog imported without a challenges section.
    await CatalogSync(
      database: db,
      source: _source(_withoutChallenges()),
    ).seedIfNeeded();
    expect(await storedVersion(), '2');
    expect((await db.select(db.challenges).get()).length, 0);

    // After the upgrade, startup seeding fills the challenges table even
    // though the stored version matches the seed's.
    final sync = CatalogSync(database: db, source: _source(_seed));
    expect((await sync.seedIfNeeded()).isSuccess, isTrue);
    expect((await db.select(db.challenges).get()).length, 3);
  });

  test('a payload without challenges keeps the saved ones', () async {
    await CatalogSync(database: db, source: _source(_seed)).seedIfNeeded();

    final result = await CatalogSync(
      database: db,
      source: _source(_withoutChallenges()),
    ).refresh();

    expect(result.isSuccess, isTrue);
    expect((await db.select(db.challenges).get()).length, 3);
  });

  test(
    'a payload with an empty challenges list clears the saved ones',
    () async {
      await CatalogSync(database: db, source: _source(_seed)).seedIfNeeded();
      final root = jsonDecode(_seed) as Map<String, dynamic>;
      (root['data'] as Map<String, dynamic>)['challenges'] = <Object>[];

      final result = await CatalogSync(
        database: db,
        source: _source(jsonEncode(root)),
      ).refresh();

      expect(result.isSuccess, isTrue);
      expect(await db.select(db.challenges).get(), isEmpty);
    },
  );

  test('malformed seed returns a typed failure and imports nothing', () async {
    final sync = CatalogSync(database: db, source: _source('{"version": 1}'));
    final result = await sync.seedIfNeeded();

    expect(result.failureOrNull, isA<MalformedCatalog>());
    expect(await count(), 0);
    expect(await storedVersion(), isNull);
  });

  test('unreadable seed returns CatalogUnavailable', () async {
    final sync = CatalogSync(
      database: db,
      source: AssetCatalogSource(load: () async => throw Exception('gone')),
    );
    expect(
      (await sync.seedIfNeeded()).failureOrNull,
      isA<CatalogUnavailable>(),
    );
  });
}
