import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_providers.dart';
import '../data/drift_member_repository.dart';
import '../domain/member.dart';
import '../domain/member_repository.dart';

final memberRepositoryProvider = Provider<MemberRepository>(
  (ref) => DriftMemberRepository(ref.watch(appDatabaseProvider)),
);

/// The shared member record. Home (and Rewards) watch this same stream, so
/// they can never disagree.
final memberProvider = StreamProvider<Member?>((ref) async* {
  await ref.watch(catalogReadyProvider.future);
  yield* ref.watch(memberRepositoryProvider).watchMember();
});
