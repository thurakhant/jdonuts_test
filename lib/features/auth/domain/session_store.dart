import 'auth_user.dart';

/// Remembers who is signed in across app launches.
abstract interface class SessionStore {
  Future<AuthSession?> read();
  Future<void> write(AuthSession session);
  Future<void> clear();
}

/// Remembers registered users across app launches (fake backend data).
abstract interface class UserStore {
  Future<List<AuthUser>> readAll();
  Future<void> writeAll(List<AuthUser> users);
}
