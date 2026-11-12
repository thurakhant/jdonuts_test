import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../failure.dart';
import '../result.dart';
import '../../features/home/domain/promo_banner.dart';
import '../../features/home/domain/shop.dart';
import '../../features/member/domain/member.dart';
import '../../features/product/domain/product.dart';
import '../../features/rewards/domain/challenge.dart';
import 'catalog_snapshot.dart';
import 'catalog_source.dart';

/// Keeps the local database filled from a [CatalogSource].
///
/// - [seedIfNeeded]: first launch only; imports and records the version.
/// - [refresh]: pull-to-refresh / back-online. Re-fetches and upserts when the
///   source version is newer or equal (idempotent); ignores older ones.
class CatalogSync {
  CatalogSync({required this.database, required this.source});

  final AppDatabase database;
  final CatalogSource source;

  AppDatabase get _db => database;

  Future<Result<void>> seedIfNeeded() async {
    if (await _storedVersion() == null) return _pull(onlyIfNotOlder: false);
    // A database seeded before schema v2 has a version but no challenge
    // rows; one equal-version pull fills them without waiting for a manual
    // refresh.
    if (await _hasChallenges()) return const Success(null);
    return _pull(onlyIfNotOlder: true);
  }

  Future<Result<void>> refresh() => _pull(onlyIfNotOlder: true);

  Future<Result<void>> _pull({required bool onlyIfNotOlder}) async {
    final fetched = await source.fetch();
    final snapshot = fetched.valueOrNull;
    if (snapshot == null) return FailureResult(fetched.failureOrNull!);
    try {
      final stored = await _storedVersion();
      if (onlyIfNotOlder && stored != null && snapshot.version < stored) {
        return const Success(null);
      }
      await _db.transaction(() => _write(snapshot));
      return const Success(null);
    } on Object {
      return const FailureResult(StorageFailure());
    }
  }

  Future<bool> _hasChallenges() async =>
      await (_db.select(_db.challenges)..limit(1)).getSingleOrNull() != null;

  Future<int?> _storedVersion() async {
    final row = await (_db.select(
      _db.keyValues,
    )..where((t) => t.key.equals(kCatalogVersionKey))).getSingleOrNull();
    return int.tryParse(row?.value ?? '');
  }

  /// Upserts every table and the version, then removes dropped rows. Runs
  /// inside one transaction (see [_pull]).
  Future<void> _write(CatalogSnapshot snapshot) async {
    await _db.batch((batch) {
      batch
        ..insertAllOnConflictUpdate(_db.products, [
          for (final product in snapshot.products) _productRow(product),
        ])
        ..insertAllOnConflictUpdate(_db.banners, [
          for (final (i, banner) in snapshot.banners.indexed)
            _bannerRow(banner, i),
        ])
        ..insertAllOnConflictUpdate(_db.shops, [
          for (final (i, shop) in snapshot.shops.indexed) _shopRow(shop, i),
        ])
        ..insertAllOnConflictUpdate(_db.members, [_memberRow(snapshot.member)])
        ..insertAllOnConflictUpdate(_db.challenges, [
          for (final (i, challenge) in (snapshot.challenges ?? []).indexed)
            _challengeRow(challenge, i),
        ])
        ..insertAllOnConflictUpdate(_db.keyValues, [
          KeyValuesCompanion.insert(
            key: kCatalogVersionKey,
            value: '${snapshot.version}',
          ),
        ]);
    });
    await _deleteMissing(snapshot);
  }

  /// Rows the source no longer lists are removed so the DB mirrors it.
  Future<void> _deleteMissing(CatalogSnapshot snapshot) async {
    await (_db.delete(
      _db.products,
    )..where((t) => t.id.isNotIn(snapshot.products.map((p) => p.id)))).go();
    await (_db.delete(
      _db.banners,
    )..where((t) => t.id.isNotIn(snapshot.banners.map((b) => b.id)))).go();
    await (_db.delete(
      _db.shops,
    )..where((t) => t.id.isNotIn(snapshot.shops.map((x) => x.id)))).go();
    // No challenges section (older payload): keep the saved rows.
    if (snapshot.challenges case final challenges?) {
      await (_db.delete(
        _db.challenges,
      )..where((t) => t.id.isNotIn(challenges.map((x) => x.id)))).go();
    }
    await (_db.delete(
      _db.members,
    )..where((t) => t.id.equals(snapshot.member.id).not())).go();
  }
}

ProductsCompanion _productRow(Product product) => ProductsCompanion.insert(
  id: product.id,
  code: product.code,
  name: product.name,
  priceMmk: product.priceMmk,
  isNew: Value(product.isNew),
  discountPercent: Value(product.discountPercent),
  imageUrl: product.imageUrl,
  description: product.description,
  section: product.section.name,
  sortOrder: Value(product.sortOrder),
);

BannersCompanion _bannerRow(PromoBanner banner, int order) =>
    BannersCompanion.insert(
      id: banner.id,
      title: banner.title,
      imageUrl: banner.imageUrl,
      badge: Value(banner.badge),
      sortOrder: Value(order),
    );

ShopsCompanion _shopRow(Shop shop, int order) => ShopsCompanion.insert(
  id: shop.id,
  name: shop.name,
  address: shop.address,
  imageUrl: shop.imageUrl,
  sortOrder: Value(order),
);

MembersCompanion _memberRow(Member member) => MembersCompanion.insert(
  id: member.id,
  name: member.name,
  avatarAsset: member.avatarAsset,
  tier: member.tier,
  totalPoints: member.totalPoints,
  pointsToNextTier: member.pointsToNextTier,
  nextTier: member.nextTier,
  notificationCount: Value(member.notificationCount),
  tierProgress: Value(member.tierProgress),
);

ChallengesCompanion _challengeRow(Challenge challenge, int order) =>
    ChallengesCompanion.insert(
      id: challenge.id,
      title: challenge.title,
      imageAsset: challenge.imageAsset,
      style: challenge.style.name,
      goal: challenge.goal,
      progress: challenge.progress,
      rewardPoints: challenge.rewardPoints,
      sortOrder: Value(order),
    );
