import 'product.dart';

/// Read side of the product catalog. Streams re-emit when the local database
/// changes, so the UI never has to ask twice.
abstract interface class ProductRepository {
  Stream<List<Product>> watchSection(ProductSection section);

  /// Emits null when no product has [id].
  Stream<Product?> watchById(String id);
}
