import 'package:drift/drift.dart' show OrderingTerm;

import '../../../core/db/app_database.dart';
import '../domain/challenge.dart';
import '../domain/rewards_repository.dart';
import '../../../core/db/storage_errors.dart';

class DriftRewardsRepository implements RewardsRepository {
  DriftRewardsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Challenge>> watchChallenges() {
    final query = _db.select(_db.challenges)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    return query.watch().withStorageFailures().map(
      (rows) => [
        for (final r in rows)
          if (ChallengeStyle.tryParse(r.style) case final style?)
            Challenge(
              id: r.id,
              title: r.title,
              imageAsset: r.imageAsset,
              style: style,
              goal: r.goal,
              progress: r.progress,
              rewardPoints: r.rewardPoints,
            ),
      ],
    );
  }
}
