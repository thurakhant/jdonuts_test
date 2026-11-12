import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_auth_repository.dart';
import '../data/secure_stores.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';
import '../domain/session_store.dart';

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SecureSessionStore(),
);

final userStoreProvider = Provider<UserStore>((ref) => SecureUserStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(
    sessionStore: ref.watch(sessionStoreProvider),
    userStore: ref.watch(userStoreProvider),
  ),
);

/// The signed-in session; null when signed out. Slice 3 wires restore on
/// launch and the router to this.
class CurrentSessionNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() =>
      ref.watch(authRepositoryProvider).currentSession();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).currentSession(),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}

final currentSessionProvider =
    AsyncNotifierProvider<CurrentSessionNotifier, AuthSession?>(
      CurrentSessionNotifier.new,
    );
