import 'package:flutter_riverpod/flutter_riverpod.dart';

/// High-level session state the router guard redirects on.
enum AuthStatus {
  /// Session is still being restored from secure storage.
  unknown,
  signedOut,
  signedIn,
}

/// Slice-1 stub: starts signed out, so the app boots to Onboarding.
/// Slice 2 replaces this with real session restoration from secure storage.
class AuthStatusNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.signedOut;

  void set(AuthStatus value) => state = value;
}

final authStatusProvider = NotifierProvider<AuthStatusNotifier, AuthStatus>(
  AuthStatusNotifier.new,
);
