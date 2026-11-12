import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/product.dart';
import '../domain/product_repository.dart';

class DriftProductRepository implements ProductRepository {
  DriftProductRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Product>> watchSection(ProductSection section) {
    final query = _db.select(_db.products)
      ..where((t) => t.section.equals(section.name))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().map((rows) => rows.map(_toProduct).toList());
  }

  @override
  Stream<Product?> watchById(String id) {
    final query = _db.select(_db.products)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toProduct(row),
    );
  }

  Product _toProduct(ProductRow row) => Product(
    id: row.id,
    code: row.code,
    name: row.name,
    priceMmk: row.priceMmk,
    isNew: row.isNew,
    discountPercent: row.discountPercent,
    imageUrl: row.imageUrl,
    description: row.description,
    section: ProductSection.tryParse(row.section) ?? ProductSection.popular,
    sortOrder: row.sortOrder,
  );
}
