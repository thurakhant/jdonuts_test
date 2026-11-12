import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/auth_user.dart';
import '../domain/session_store.dart';

const String _sessionKey = 'auth.session';
const String _usersKey = 'auth.users';

/// Session persisted in the platform keychain / keystore.
class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    try {
      return AuthSession.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on Object {
      // Corrupt data: treat as signed out.
      return null;
    }
  }

  @override
  Future<void> write(AuthSession session) =>
      _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _sessionKey);
}

/// Registered users persisted as JSON in secure storage.
class SecureUserStore implements UserStore {
  SecureUserStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<List<AuthUser>> readAll() async {
    final raw = await _storage.read(key: _usersKey);
    if (raw == null) return [];
    try {
      return [
        for (final item in jsonDecode(raw) as List<Object?>)
          AuthUser.fromJson((item! as Map).cast<String, Object?>()),
      ];
    } on Object {
      return [];
    }
  }

  @override
  Future<void> writeAll(List<AuthUser> users) => _storage.write(
    key: _usersKey,
    value: jsonEncode([for (final u in users) u.toJson()]),
  );
}
