import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Key under which the imported catalog version is stored in [KeyValues].
const String kCatalogVersionKey = 'catalog_version';

/// The local database: the single source of truth for the UI.
///
/// Pass a [QueryExecutor] in tests (`NativeDatabase.memory()`); production
/// opens the on-disk file through `drift_flutter`.
@DriftDatabase(tables: [Products, Banners, Shops, Members, KeyValues])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'jdonuts'));

  /// Bump when a table changes and add a step to [_migrateTo].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Versioned, step-by-step: a user on v1 opening a v3 build runs the
      // v2 step, then the v3 step, in order.
      for (var version = from + 1; version <= to; version++) {
        await _migrateTo(m, version);
      }
    },
  );

  /// One method per schema version. Example for a future v2:
  /// `case 2: await m.addColumn(products, products.calories);`
  Future<void> _migrateTo(Migrator m, int version) async {
    switch (version) {
      default:
        break;
    }
  }
}
