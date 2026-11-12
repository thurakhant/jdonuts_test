import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../failure.dart';
import '../result.dart';
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

  Future<void> _write(CatalogSnapshot s) async {
    final challenges = s.challenges ?? const <Challenge>[];
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.products, [
        for (final p in s.products)
          ProductsCompanion.insert(
            id: p.id,
            code: p.code,
            name: p.name,
            priceMmk: p.priceMmk,
            isNew: Value(p.isNew),
            discountPercent: Value(p.discountPercent),
            imageUrl: p.imageUrl,
            description: p.description,
            section: p.section.name,
            sortOrder: Value(p.sortOrder),
          ),
      ]);
      b.insertAllOnConflictUpdate(_db.banners, [
        for (var i = 0; i < s.banners.length; i++)
          BannersCompanion.insert(
            id: s.banners[i].id,
            title: s.banners[i].title,
            imageUrl: s.banners[i].imageUrl,
            badge: Value(s.banners[i].badge),
            sortOrder: Value(i),
          ),
      ]);
      b.insertAllOnConflictUpdate(_db.shops, [
        for (var i = 0; i < s.shops.length; i++)
          ShopsCompanion.insert(
            id: s.shops[i].id,
            name: s.shops[i].name,
            address: s.shops[i].address,
            imageUrl: s.shops[i].imageUrl,
            sortOrder: Value(i),
          ),
      ]);
      final m = s.member;
      b.insertAllOnConflictUpdate(_db.members, [
        MembersCompanion.insert(
          id: m.id,
          name: m.name,
          avatarAsset: m.avatarAsset,
          tier: m.tier,
          totalPoints: m.totalPoints,
          pointsToNextTier: m.pointsToNextTier,
          nextTier: m.nextTier,
          notificationCount: Value(m.notificationCount),
          tierProgress: Value(m.tierProgress),
        ),
      ]);
      b.insertAllOnConflictUpdate(_db.challenges, [
        for (var i = 0; i < challenges.length; i++)
          ChallengesCompanion.insert(
            id: challenges[i].id,
            title: challenges[i].title,
            imageAsset: challenges[i].imageAsset,
            style: challenges[i].style.name,
            goal: challenges[i].goal,
            progress: challenges[i].progress,
            rewardPoints: challenges[i].rewardPoints,
            sortOrder: Value(i),
          ),
      ]);
      b.insertAllOnConflictUpdate(_db.keyValues, [
        KeyValuesCompanion.insert(
          key: kCatalogVersionKey,
          value: '${s.version}',
        ),
      ]);
    });
    await _deleteMissing(s);
  }

  /// Rows the source no longer lists are removed so the DB mirrors it.
  Future<void> _deleteMissing(CatalogSnapshot s) async {
    await (_db.delete(
      _db.products,
    )..where((t) => t.id.isNotIn(s.products.map((p) => p.id)))).go();
    await (_db.delete(
      _db.banners,
    )..where((t) => t.id.isNotIn(s.banners.map((b) => b.id)))).go();
    await (_db.delete(
      _db.shops,
    )..where((t) => t.id.isNotIn(s.shops.map((x) => x.id)))).go();
    // No challenges section (older payload): keep the saved rows.
    if (s.challenges case final challenges?) {
      await (_db.delete(
        _db.challenges,
      )..where((t) => t.id.isNotIn(challenges.map((x) => x.id)))).go();
    }
    await (_db.delete(
      _db.members,
    )..where((t) => t.id.equals(s.member.id).not())).go();
  }
}
