import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/home_repository.dart';
import '../domain/promo_banner.dart';
import '../domain/shop.dart';

class DriftHomeRepository implements HomeRepository {
  DriftHomeRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<PromoBanner>> watchBanners() {
    final query = _db.select(_db.banners)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          PromoBanner(
            id: r.id,
            title: r.title,
            imageUrl: r.imageUrl,
            badge: r.badge,
          ),
      ],
    );
  }

  @override
  Stream<List<Shop>> watchShops() {
    final query = _db.select(_db.shops)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          Shop(
            id: r.id,
            name: r.name,
            address: r.address,
            imageUrl: r.imageUrl,
          ),
      ],
    );
  }
}
