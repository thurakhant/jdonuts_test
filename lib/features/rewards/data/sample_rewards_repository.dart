import '../domain/challenge.dart';
import '../domain/rewards_repository.dart';

/// Demo challenges and history. The test brief has no rewards backend and
/// the catalog seed carries no challenge data, so this fake stands behind
/// the same interface a real repository would.
class SampleRewardsRepository implements RewardsRepository {
  const SampleRewardsRepository();

  @override
  Future<List<Challenge>> challenges() async => const [
    Challenge(
      id: 'c-dozen',
      title: 'Donut dozen',
      style: ChallengeStyle.quarterDonut,
      goal: 12,
      progress: 8,
      rewardPoints: 300,
    ),
    Challenge(
      id: 'c-coffee-break',
      title: 'Coffee break',
      style: ChallengeStyle.coffeeCup,
      goal: 5,
      progress: 5,
      rewardPoints: 150,
    ),
    Challenge(
      id: 'c-weekend',
      title: 'Weekend treat',
      style: ChallengeStyle.quarterDonut,
      goal: 2,
      progress: 2,
      rewardPoints: 100,
      claimed: true,
    ),
    Challenge(
      id: 'c-morning',
      title: 'Morning brew',
      style: ChallengeStyle.coffeeCup,
      goal: 6,
      progress: 2,
      rewardPoints: 250,
    ),
  ];

  @override
  Future<List<HistoryEntry>> history() async => const [
    HistoryEntry(
      id: 'h-1',
      title: 'Mistletoe Romance box',
      points: 180,
      daysAgo: 1,
    ),
    HistoryEntry(id: 'h-2', title: 'Weekend treat', points: 100, daysAgo: 3),
    HistoryEntry(id: 'h-3', title: 'Classic Glazed x6', points: 90, daysAgo: 6),
    HistoryEntry(id: 'h-4', title: 'Americano x2', points: 40, daysAgo: 9),
  ];
}
