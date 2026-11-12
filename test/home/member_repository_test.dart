import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/catalog/catalog_sync.dart';
import 'package:jdonuts_test/features/member/data/drift_member_repository.dart';

import '../support/data_overrides.dart';

void main() {
  test('returns the single seeded member record', () async {
    final db = memoryDatabase();
    addTearDown(db.close);
    final repo = DriftMemberRepository(db);
    expect(await repo.watchMember().first, isNull);

    await CatalogSync(database: db, source: seedFileSource()).seedIfNeeded();
    await CatalogSync(database: db, source: seedFileSource()).refresh();

    final member = (await repo.watchMember().first)!;
    expect(member.name, 'Hania');
    expect(member.tier, 'Silver');
    expect(member.totalPoints, 680000);
    expect(member.pointsToNextTier, 500);
    expect(member.nextTier, 'Gold');
    expect(member.notificationCount, 2);
    expect(member.tierProgress, 0.78);
    expect((await db.select(db.members).get()).length, 1);
  });
}
