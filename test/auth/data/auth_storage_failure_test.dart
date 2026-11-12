import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';
import 'package:jdonuts_test/features/auth/data/secure_stores.dart';
import 'package:jdonuts_test/features/auth/domain/auth_user.dart';

const phone = '+959254135592';

/// A user store whose reads or writes fail, like a broken keychain.
class _BrokenUserStore extends InMemoryUserStore {
  _BrokenUserStore({this.failRead = false, this.failWrite = false});

  final bool failRead;
  final bool failWrite;

  @override
  Future<List<AuthUser>> readAll() => failRead
      ? Future.error(const FormatException('corrupt'))
      : super.readAll();

  @override
  Future<void> writeAll(List<AuthUser> users) =>
      failWrite ? Future.error(Exception('disk full')) : super.writeAll(users);
}

FakeAuthRepository _repo(InMemoryUserStore users) => FakeAuthRepository(
  sessionStore: InMemorySessionStore(),
  userStore: users,
  delay: Duration.zero,
);

Future<Object?> _register(FakeAuthRepository repo) async =>
    (await repo.register(
      phone: phone,
      firstName: 'Aung',
      lastName: '',
      dateOfBirth: DateTime(1995, 5, 20),
    )).failureOrNull;

void main() {
  group('FakeAuthRepository storage failures', () {
    test(
      'a failed save returns StorageFailure and keeps no phantom user',
      () async {
        final repo = _repo(_BrokenUserStore(failWrite: true));

        expect(await _register(repo), isA<StorageFailure>());
        expect(
          (await repo.requestOtp(phone)).failureOrNull,
          isA<UnknownNumber>(),
        );
      },
    );

    test(
      'unreadable saved users return StorageFailure, not "unknown"',
      () async {
        final repo = _repo(_BrokenUserStore(failRead: true));

        expect(
          (await repo.requestOtp(phone)).failureOrNull,
          isA<StorageFailure>(),
        );
        expect(await _register(repo), isA<StorageFailure>());
      },
    );
  });

  group('Secure stores with damaged data', () {
    test('corrupt users throw instead of reading as "no users"', () async {
      FlutterSecureStorage.setMockInitialValues({'auth.users': 'not json'});

      expect(SecureUserStore().readAll(), throwsFormatException);
    });

    test('a corrupt session reads as signed out and is removed', () async {
      FlutterSecureStorage.setMockInitialValues({'auth.session': 'not json'});
      const storage = FlutterSecureStorage();

      expect(await SecureSessionStore(storage).read(), isNull);
      expect(await storage.read(key: 'auth.session'), isNull);
    });
  });
}
