import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../catalog/asset_catalog_source.dart';
import '../catalog/catalog_source.dart';
import '../catalog/catalog_sync.dart';
import '../failure.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Swap this one provider for an HTTP source to go online for real.
final catalogSourceProvider = Provider<CatalogSource>(
  (ref) => AssetCatalogSource(),
);

final catalogSyncProvider = Provider<CatalogSync>(
  (ref) => CatalogSync(
    database: ref.watch(appDatabaseProvider),
    source: ref.watch(catalogSourceProvider),
  ),
);

/// Completes once the first-launch import is done (instant afterwards).
/// Every data stream waits on it; a failure surfaces as an error state with
/// the typed [Failure] so screens can offer Retry.
final catalogReadyProvider = FutureProvider<void>((ref) async {
  final result = await ref.watch(catalogSyncProvider).seedIfNeeded();
  final failure = result.failureOrNull;
  if (failure != null) throw failure;
});
