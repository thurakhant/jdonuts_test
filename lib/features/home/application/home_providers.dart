import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/connectivity/connectivity_providers.dart';
import '../../../core/db/database_providers.dart';
import '../data/drift_home_repository.dart';
import '../domain/home_repository.dart';
import '../domain/promo_banner.dart';
import '../domain/shop.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => DriftHomeRepository(ref.watch(appDatabaseProvider)),
);

final bannersProvider = StreamProvider<List<PromoBanner>>((ref) async* {
  await ref.watch(catalogReadyProvider.future);
  yield* ref.watch(homeRepositoryProvider).watchBanners();
});

final shopsProvider = StreamProvider<List<Shop>>((ref) async* {
  await ref.watch(catalogReadyProvider.future);
  yield* ref.watch(homeRepositoryProvider).watchShops();
});

/// Refreshes the catalog in the background each time the app comes back
/// online (offline -> online edge). Home watches this to keep it alive.
final reconnectRefreshProvider = Provider<void>((ref) {
  ref.listen(onlineProvider, (previous, next) {
    if (previous?.value == false && next.value == true) {
      ref.read(catalogSyncProvider).refresh();
    }
  });
});
