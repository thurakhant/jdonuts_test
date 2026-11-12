import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';

const phone = '+959254135592';

void main() {
  late InMemorySessionStore sessions;
  late InMemoryUserStore users;

  FakeAuthRepository make() => FakeAuthRepository(
    sessionStore: sessions,
    userStore: users,
    delay: Duration.zero,
  );

  Future<FakeAuthRepository> registered() async {
    final repo = make();
    await repo.register(
      phone: phone,
      firstName: 'Aung',
      lastName: '',
      dateOfBirth: DateTime(1995, 5, 20),
    );
    return repo;
  }

  setUp(() {
    sessions = InMemorySessionStore();
    users = InMemoryUserStore();
  });

  test('register then login with 123456 signs the user in', () async {
    final repo = await registered();
    expect((await repo.requestOtp(phone)).isSuccess, isTrue);
    final result = await repo.verifyOtp(phone: phone, code: '123456');
    expect(result.valueOrNull?.firstName, 'Aung');
    expect(((await repo.currentSession()).valueOrNull)?.phone, phone);
  });

  test('registering the same number twice fails', () async {
    final repo = await registered();
    final again = await repo.register(
      phone: phone,
      firstName: 'Other',
      lastName: '',
      dateOfBirth: DateTime(1990, 1, 1),
    );
    expect(again.failureOrNull, isA<PhoneAlreadyRegistered>());
  });

  test('login with an unknown number fails with unknownNumber', () async {
    final repo = make();
    expect((await repo.requestOtp(phone)).failureOrNull, isA<UnknownNumber>());
  });

  test('a wrong code reports the attempts left', () async {
    final repo = await registered();
    final f = (await repo.verifyOtp(
      phone: phone,
      code: '000000',
    )).failureOrNull;
    expect((f! as WrongOtp).attemptsLeft, 2);
  });

  test(
    'a malformed code is invalid and does not count as an attempt',
    () async {
      final repo = await registered();
      final r = await repo.verifyOtp(phone: phone, code: '12');
      expect(r.failureOrNull, isA<InvalidOtp>());
      final next = await repo.verifyOtp(phone: phone, code: '000000');
      expect((next.failureOrNull! as WrongOtp).attemptsLeft, 2);
    },
  );

  test('three wrong codes lock the number even for the right code', () async {
    final repo = await registered();
    await repo.verifyOtp(phone: phone, code: '000001');
    await repo.verifyOtp(phone: phone, code: '000002');
    final third = await repo.verifyOtp(phone: phone, code: '000003');
    expect(third.failureOrNull, isA<OtpLocked>());
    final right = await repo.verifyOtp(phone: phone, code: '123456');
    expect(right.failureOrNull, isA<OtpLocked>());
    expect((await repo.currentSession()).valueOrNull, isNull);
  });

  test('resending the code unlocks and resets the attempts', () async {
    final repo = await registered();
    for (final c in ['000001', '000002', '000003']) {
      await repo.verifyOtp(phone: phone, code: c);
    }
    await repo.resendOtp(phone);
    final right = await repo.verifyOtp(phone: phone, code: '123456');
    expect(right.isSuccess, isTrue);
  });

  test('a correct code clears earlier wrong attempts', () async {
    final repo = await registered();
    await repo.verifyOtp(phone: phone, code: '000001');
    await repo.verifyOtp(phone: phone, code: '123456');
    final next = await repo.verifyOtp(phone: phone, code: '000002');
    expect((next.failureOrNull! as WrongOtp).attemptsLeft, 2);
  });

  test('session persists through the store across a new repository', () async {
    final repo = await registered();
    await repo.verifyOtp(phone: phone, code: '123456');
    final session = (await make().currentSession()).valueOrNull;
    expect(session?.userId, 'user-959254135592');
    expect(session?.firstName, 'Aung');
  });

  test('registered users survive a relaunch so login still works', () async {
    await registered();
    final relaunched = make();
    expect((await relaunched.requestOtp(phone)).isSuccess, isTrue);
    final r = await relaunched.verifyOtp(phone: phone, code: '123456');
    expect(r.valueOrNull?.dateOfBirth, DateTime(1995, 5, 20));
  });

  test('sign out clears the session', () async {
    final repo = await registered();
    await repo.verifyOtp(phone: phone, code: '123456');
    await repo.signOut();
    expect((await repo.currentSession()).valueOrNull, isNull);
  });

  test('default delay is about one second', () {
    final repo = FakeAuthRepository(sessionStore: sessions, userStore: users);
    expect(repo.delay, const Duration(seconds: 1));
  });

  group('sign-up code', () {
    test('a registered number cannot request a sign-up code', () async {
      final repo = await registered();
      expect(
        (await repo.requestSignUpCode(phone)).failureOrNull,
        isA<PhoneAlreadyRegistered>(),
      );
    });

    test('accepts only the fake code, without signing in', () async {
      final repo = make();
      await repo.requestSignUpCode(phone);

      final wrong = await repo.verifySignUpCode(phone: phone, code: '000000');
      expect(wrong.failureOrNull, isA<WrongOtp>());
      final right = await repo.verifySignUpCode(phone: phone, code: '123456');
      expect(right.isSuccess, isTrue);
      expect(await sessions.read(), isNull);
    });

    test('three wrong codes lock it until a resend', () async {
      final repo = make();
      await repo.requestSignUpCode(phone);
      for (var i = 0; i < 3; i++) {
        await repo.verifySignUpCode(phone: phone, code: '000000');
      }
      final locked = await repo.verifySignUpCode(phone: phone, code: '123456');
      expect(locked.failureOrNull, isA<OtpLocked>());

      expect((await repo.resendOtp(phone)).isSuccess, isTrue);
      final after = await repo.verifySignUpCode(phone: phone, code: '123456');
      expect(after.isSuccess, isTrue);
    });

    test('a code for a number that never asked for one is rejected', () async {
      final result = await make().verifySignUpCode(
        phone: phone,
        code: '123456',
      );
      expect(result.failureOrNull, isA<UnknownNumber>());
    });
  });
}
