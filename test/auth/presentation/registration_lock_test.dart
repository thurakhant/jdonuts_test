import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/application/auth_providers.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';
import 'package:jdonuts_test/features/auth/presentation/providers/registration_flow_provider.dart';
import 'package:jdonuts_test/features/auth/presentation/providers/registration_flow_state.dart';

void main() {
  late ProviderContainer container;
  RegistrationFlowNotifier flow() =>
      container.read(registrationFlowProvider.notifier);

  setUp(() {
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(
            sessionStore: InMemorySessionStore(),
            userStore: InMemoryUserStore(),
            delay: Duration.zero,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> lockSignUpFor(String phone) async {
    flow()
      ..start(AuthMode.register)
      ..setPhoneInput(phone);
    expect(await flow().submitPhone(), isNull);
    for (var i = 0; i < 3; i++) {
      await flow().verifyOtp('000000');
    }
    expect(container.read(registrationFlowProvider).otpLocked, isTrue);
  }

  test('Back and the same number stay locked until Resend', () async {
    await lockSignUpFor('09254135592');

    // Back to the phone step, edit, end on the same number.
    flow()
      ..setPhoneInput('0925413559')
      ..setPhoneInput('09 254 135 592');
    await flow().submitPhone();
    expect(await flow().verifyOtp('123456'), isA<OtpLocked>());

    await flow().resendOtp();
    expect(await flow().verifyOtp('123456'), isNull);
  });

  test('a different number starts with a fresh set of attempts', () async {
    await lockSignUpFor('09254135592');

    flow().setPhoneInput('09254135593');
    await flow().submitPhone();
    expect(container.read(registrationFlowProvider).otpLocked, isFalse);
    expect(await flow().verifyOtp('123456'), isNull);
  });
}
