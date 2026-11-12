import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/core/result.dart';
import 'package:jdonuts_test/features/auth/application/auth_providers.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';
import 'package:jdonuts_test/features/auth/domain/auth_user.dart';
import 'package:jdonuts_test/features/auth/presentation/providers/registration_flow_provider.dart';
import 'package:jdonuts_test/features/auth/presentation/providers/registration_flow_state.dart';

import 'test_app.dart';

class FailingSessionStore extends InMemorySessionStore {
  bool failWrite = false;
  bool failClear = false;
  @override
  Future<void> write(AuthSession session) async {
    if (failWrite) throw Exception('write failed');
    await super.write(session);
  }

  @override
  Future<void> clear() async {
    if (failClear) throw Exception('delete failed');
    await super.clear();
  }
}

class FailingResendRepository extends FakeAuthRepository {
  FailingResendRepository(InMemoryUserStore users)
    : super(
        sessionStore: InMemorySessionStore(),
        userStore: users,
        delay: Duration.zero,
      );
  bool failResend = true;
  @override
  Future<Result<void>> resendOtp(String phone) async => failResend
      ? const FailureResult(StorageFailure())
      : super.resendOtp(phone);
}

void main() {
  test(
    'registration retries session save without creating the account twice',
    () async {
      final sessions = FailingSessionStore()..failWrite = true;
      final users = InMemoryUserStore();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(
              sessionStore: sessions,
              userStore: users,
              delay: Duration.zero,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final flow = container.read(registrationFlowProvider.notifier);
      flow
        ..start(AuthMode.register)
        ..setPhoneInput('09254135592');
      expect(await flow.submitPhone(), isNull);
      expect(await flow.verifyOtp('123456'), isNull);
      flow
        ..setName(first: 'Mya')
        ..setDob(month: 5, day: '1', year: '1990');
      expect(await flow.completeRegistration(), isA<StorageFailure>());
      expect((await users.readAll()).length, 1);
      flow
        ..setName(first: 'Changed')
        ..setDob(year: '1991');
      expect(container.read(registrationFlowProvider).firstName, 'Mya');
      expect(container.read(registrationFlowProvider).year, '1990');
      sessions.failWrite = false;
      expect(await flow.completeRegistration(), isNull);
      expect((await sessions.read())?.phone, testUser.phone);
      expect((await users.readAll()).length, 1);
      flow.setPhoneInput('09254135593');
      expect(await flow.submitPhone(), isNull);
      expect(await flow.verifyOtp('123456'), isNull);
      flow
        ..setName(first: 'Aung')
        ..setDob(month: 5, day: '1', year: '1990');
      expect(await flow.completeRegistration(), isNull);
      expect((await users.readAll()).length, 2);
      flow
        ..start(AuthMode.register)
        ..setPhoneInput('09254135593');
      expect(await flow.submitPhone(), isA<PhoneAlreadyRegistered>());
    },
  );

  testWidgets(
    'saved registration locks profile fields and explains sign-in retry',
    (tester) async {
      final sessions = FailingSessionStore()..failWrite = true;
      await pumpApp(tester, userRegistered: false, sessionStore: sessions);
      await startFlow(tester, login: false);
      await tapButton(tester, 'CONTINUE');
      await tester.enterText(find.byKey(const ValueKey('otp-box-0')), '123456');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('first-name')), 'Mya');
      await tester.pump();
      await tapButton(tester, 'CONTINUE');
      await tester.tap(find.byKey(const ValueKey('dob-month')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('May'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('dob-day')), '1');
      await tester.enterText(find.byKey(const ValueKey('dob-year')), '1990');
      await tester.pump();
      await tapButton(tester, 'CONTINUE');
      expect(
        find.text('Your account is saved. Continue to retry signing in.'),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('dob-year')), findsNothing);
      expect(find.byKey(const ValueKey('dob-month')), findsNothing);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('first-name')))
            .readOnly,
        isTrue,
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('last-name')))
            .readOnly,
        isTrue,
      );
      await tapButton(tester, 'CONTINUE');
      sessions.failWrite = false;
      await tapButton(tester, 'CONTINUE');
      expect(find.text("LET'S EXPLORE"), findsOneWidget);
      expect((await sessions.read())?.phone, testUser.phone);
    },
  );

  testWidgets('failed logout shows feedback and can be retried', (
    tester,
  ) async {
    final sessions = FailingSessionStore()..failClear = true;
    await pumpApp(tester, signedIn: true, sessionStore: sessions);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(await sessions.read(), isNotNull);
    expect(find.byType(SnackBar), findsOneWidget);
    sessions.failClear = false;
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(await sessions.read(), isNull);
    expect(find.text("LET'S GET STARTED"), findsOneWidget);
  });

  testWidgets(
    'failed resend allows immediate retry; success restarts countdown',
    (tester) async {
      final users = InMemoryUserStore();
      await users.writeAll([testUser]);
      final repo = FailingResendRepository(users);
      await pumpApp(tester, repository: repo);
      await startFlow(tester, login: true);
      await tapButton(tester, 'CONTINUE');
      final box = find.byKey(const ValueKey('otp-box-0'));
      for (var attempt = 0; attempt < 3; attempt++) {
        await tester.enterText(box, '111111');
        await tester.pumpAndSettle();
      }
      expect(tester.widget<TextField>(box).enabled, isFalse);
      await tester.pump(const Duration(minutes: 5));
      await tester.tap(find.text('Resend'));
      await tester.pumpAndSettle();
      expect(find.text('Resend'), findsOneWidget);
      expect(find.text('resend in 5:00 min'), findsNothing);
      expect(tester.widget<TextField>(box).enabled, isFalse);
      repo.failResend = false;
      await tester.tap(find.text('Resend'));
      await tester.pumpAndSettle();
      expect(find.text('resend in 5:00 min'), findsOneWidget);
      expect(tester.widget<TextField>(box).enabled, isTrue);
    },
  );
}
