import '../domain/auth_user.dart';
import '../domain/session_store.dart';

/// Non-persistent stores for tests and previews.
class InMemorySessionStore implements SessionStore {
  AuthSession? _session;

  @override
  Future<AuthSession?> read() async => _session;

  @override
  Future<void> write(AuthSession session) async => _session = session;

  @override
  Future<void> clear() async => _session = null;
}

class InMemoryUserStore implements UserStore {
  List<AuthUser> _users = [];

  @override
  Future<List<AuthUser>> readAll() async => List.of(_users);

  @override
  Future<void> writeAll(List<AuthUser> users) async => _users = List.of(users);
}
