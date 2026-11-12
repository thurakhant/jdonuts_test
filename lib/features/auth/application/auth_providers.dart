import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/failure.dart';
import '../../../core/result.dart';
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
  Future<AuthSession?> build() => _read(ref.watch(authRepositoryProvider));

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => _read(ref.read(authRepositoryProvider)),
    );
  }

  /// An unreadable session is an [AsyncError]; the router treats it as
  /// signed out, so the user simply signs in again.
  Future<AuthSession?> _read(AuthRepository repo) async {
    final result = await repo.currentSession();
    return switch (result) {
      Success(:final value) => value,
      FailureResult(:final failure) => throw failure,
    };
  }

  /// Signs out, or returns the failure and keeps the session.
  Future<Failure?> signOut() async {
    final result = await ref.read(authRepositoryProvider).signOut();
    if (result.isSuccess) state = const AsyncData(null);
    return result.failureOrNull;
  }
}

final currentSessionProvider =
    AsyncNotifierProvider<CurrentSessionNotifier, AuthSession?>(
      CurrentSessionNotifier.new,
    );
