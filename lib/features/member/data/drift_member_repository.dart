import '../../../core/db/app_database.dart';
import '../domain/member.dart';
import '../domain/member_repository.dart';

class DriftMemberRepository implements MemberRepository {
  DriftMemberRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Member?> watchMember() {
    return (_db.select(_db.members)..limit(1)).watchSingleOrNull().map(
      (row) => row == null
          ? null
          : Member(
              id: row.id,
              name: row.name,
              avatarAsset: row.avatarAsset,
              tier: row.tier,
              totalPoints: row.totalPoints,
              pointsToNextTier: row.pointsToNextTier,
              nextTier: row.nextTier,
              notificationCount: row.notificationCount,
              tierProgress: row.tierProgress,
            ),
    );
  }
}
