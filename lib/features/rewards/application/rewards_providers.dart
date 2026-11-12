import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_providers.dart';
import '../data/drift_rewards_repository.dart';
import '../domain/challenge.dart';
import '../domain/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => DriftRewardsRepository(ref.watch(appDatabaseProvider)),
);

/// Challenges from the same local database as Home.
final challengesProvider = StreamProvider<List<Challenge>>((ref) async* {
  await ref.watch(catalogReadyProvider.future);
  yield* ref.watch(rewardsRepositoryProvider).watchChallenges();
}, retry: noRetry);

/// Ids of challenges whose reward was claimed this session. Kept outside
/// the cards so switching tabs never resets it.
final claimedChallengesProvider =
    NotifierProvider<ClaimedChallengesNotifier, Set<String>>(
      ClaimedChallengesNotifier.new,
    );

class ClaimedChallengesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Claims once; a repeat tap on the same challenge does nothing.
  void claim(String id) {
    if (state.contains(id)) return;
    state = {...state, id};
  }
}
