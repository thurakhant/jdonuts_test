import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_rewards_repository.dart';
import '../domain/challenge.dart';
import '../domain/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => const SampleRewardsRepository(),
);

/// The challenge list, with claiming handled in memory.
class ChallengesNotifier extends AsyncNotifier<List<Challenge>> {
  @override
  Future<List<Challenge>> build() =>
      ref.watch(rewardsRepositoryProvider).challenges();

  /// Marks a finished challenge as claimed. Ignored if not claimable.
  void claim(String id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final c in current)
        if (c.id == id && c.canClaim) c.copyWith(claimed: true) else c,
    ]);
  }
}

final challengesProvider =
    AsyncNotifierProvider<ChallengesNotifier, List<Challenge>>(
      ChallengesNotifier.new,
    );

final historyProvider = FutureProvider<List<HistoryEntry>>(
  (ref) => ref.watch(rewardsRepositoryProvider).history(),
);
