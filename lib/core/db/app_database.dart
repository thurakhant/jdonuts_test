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
@DriftDatabase(
  tables: [Products, Banners, Shops, Members, Challenges, KeyValues],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'jdonuts'));

  /// Bump when a table changes and add a step to [_migrateTo].
  @override
  int get schemaVersion => 4;

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

  /// One method per schema version.
  Future<void> _migrateTo(Migrator m, int version) async {
    switch (version) {
      case 2:
        // v2: rewards challenges. Filled by the next catalog refresh.
        await m.createTable(challenges);
      case 3:
        // v3: banner badge pill. Filled by the next catalog refresh.
        await m.addColumn(banners, banners.badge);
      case 4:
        // v4: member tier progress. Forgetting the catalog version makes
        // the next start re-import the seed, which fills the new column.
        await m.addColumn(members, members.tierProgress);
        await (delete(
          keyValues,
        )..where((t) => t.key.equals(kCatalogVersionKey))).go();
      default:
        break;
    }
  }
}
