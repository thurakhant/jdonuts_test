import 'dart:io';

import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:jdonuts_test/core/catalog/asset_catalog_source.dart';
import 'package:jdonuts_test/core/catalog/catalog_source.dart';
import 'package:jdonuts_test/core/connectivity/connectivity_providers.dart';
import 'package:jdonuts_test/core/db/app_database.dart';
import 'package:jdonuts_test/core/db/database_providers.dart';

/// Provider overrides that keep widget tests off the real disk DB, the
/// connectivity plugin and the network. [online] feeds `onlineProvider`.
List<Override> dataOverrides({
  AppDatabase? database,
  Stream<bool>? online,
  CatalogSource? source,
}) {
  return [
    appDatabaseProvider.overrideWith((ref) {
      final db = database ?? memoryDatabase();
      ref.onDispose(db.close);
      return db;
    }),
    catalogSourceProvider.overrideWithValue(source ?? seedFileSource()),
    onlineProvider.overrideWith((ref) => online ?? Stream.value(true)),
  ];
}

/// The real seed file read synchronously (rootBundle does real I/O, which
/// never completes inside a fake-async widget test).
CatalogSource seedFileSource() => AssetCatalogSource(
  load: () async => File('assets/seed/catalog.json').readAsStringSync(),
);

/// In-memory DB whose query streams close synchronously, so widget tests do
/// not end with drift's zero-duration cleanup timers still pending.
AppDatabase memoryDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

String seedFileText() => File('assets/seed/catalog.json').readAsStringSync();
