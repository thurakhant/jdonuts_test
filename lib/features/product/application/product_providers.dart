import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_providers.dart';
import '../data/drift_product_repository.dart';
import '../domain/product.dart';
import '../domain/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => DriftProductRepository(ref.watch(appDatabaseProvider)),
);

final productsBySectionProvider =
    StreamProvider.family<List<Product>, ProductSection>((ref, section) async* {
      await ref.watch(catalogReadyProvider.future);
      yield* ref.watch(productRepositoryProvider).watchSection(section);
    });

/// Emits null when the id is unknown (the detail screen shows "not found").
final productByIdProvider = StreamProvider.family<Product?, String>((
  ref,
  id,
) async* {
  await ref.watch(catalogReadyProvider.future);
  yield* ref.watch(productRepositoryProvider).watchById(id);
});
