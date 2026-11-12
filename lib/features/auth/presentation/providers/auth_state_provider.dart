import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_providers.dart';

/// High-level session state the router guard redirects on.
enum AuthStatus {
  /// Session is still being restored from secure storage.
  unknown,
  signedOut,
  signedIn,
}

/// Derived from the restored session: loading is `unknown`, a stored
/// session is `signedIn`, anything else (including a read error) is
/// `signedOut`.
final authStatusProvider = Provider<AuthStatus>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session.isLoading && !session.hasValue) return AuthStatus.unknown;
  return session.value == null ? AuthStatus.signedOut : AuthStatus.signedIn;
});
