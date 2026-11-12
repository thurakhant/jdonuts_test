import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

Future<void> _openOtp(
  WidgetTester tester, {
  bool login = true,
  Duration latency = Duration.zero,
}) async {
  await pumpApp(tester, userRegistered: login, latency: latency);
  await startFlow(tester, login: login);
  await tapButton(tester, 'CONTINUE');
}

Future<void> _enterCode(WidgetTester tester, String code) async {
  await tester.enterText(find.byKey(const ValueKey('otp-box-0')), code);
  await tester.pumpAndSettle();
}

String _digits(WidgetTester tester) => [
  for (var i = 0; i < 6; i++)
    tester
        .widget<TextField>(find.byKey(ValueKey('otp-box-$i')))
        .controller!
        .text,
].join();

void main() {
  testWidgets('shows the normalized number and the countdown', (tester) async {
    await _openOtp(tester);
    expect(
      find.text("We've sent 6 digit OTP to +959254135592"),
      findsOneWidget,
    );
    expect(find.text('resend in 5:00 min'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('resend in 4:58 min'), findsOneWidget);
  });

  testWidgets('wrong code shows an error and clears the boxes', (tester) async {
    await _openOtp(tester);
    await _enterCode(tester, '111111');
    expect(find.text('That code is wrong. 2 tries left.'), findsOneWidget);
    expect(_digits(tester), isEmpty);
  });

  testWidgets('three wrong codes lock entry until Resend', (tester) async {
    await _openOtp(tester);
    await _enterCode(tester, '111111');
    await _enterCode(tester, '222222');
    await _enterCode(tester, '333333');
    expect(
      find.text('Too many wrong codes. Tap Resend to get a new one.'),
      findsOneWidget,
    );
    final box = tester.widget<TextField>(
      find.byKey(const ValueKey('otp-box-0')),
    );
    expect(box.enabled, isFalse);

    await tester.pump(const Duration(minutes: 5));
    await tester.tap(find.text('Resend'));
    await tester.pumpAndSettle();
    expect(find.text('resend in 5:00 min'), findsOneWidget);
    final unlocked = tester.widget<TextField>(
      find.byKey(const ValueKey('otp-box-0')),
    );
    expect(unlocked.enabled, isTrue);
  });

  testWidgets('correct code in login mode signs in to Home', (tester) async {
    await _openOtp(tester);
    await _enterCode(tester, '123456');
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Verify your number'), findsNothing);
  });

  testWidgets('correct code in register mode goes to the Name step', (
    tester,
  ) async {
    await _openOtp(tester, login: false);
    await _enterCode(tester, '123456');
    expect(find.text("What's your name?"), findsOneWidget);
  });

  testWidgets('a second completed code while verifying is ignored', (
    tester,
  ) async {
    await _openOtp(tester, latency: const Duration(milliseconds: 500));
    final first = find.byKey(const ValueKey('otp-box-0'));
    await tester.enterText(first, '111111');
    await tester.enterText(first, '222222');
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    // Only one wrong attempt was counted, so two tries remain.
    expect(find.text('That code is wrong. 2 tries left.'), findsOneWidget);
    expect(find.textContaining('1 try left'), findsNothing);
  });

  testWidgets('boxes stay disabled after Back and return while locked', (
    tester,
  ) async {
    await _openOtp(tester);
    await _enterCode(tester, '111111');
    await _enterCode(tester, '222222');
    await _enterCode(tester, '333333');
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tapButton(tester, 'CONTINUE');
    final box = tester.widget<TextField>(
      find.byKey(const ValueKey('otp-box-0')),
    );
    expect(box.enabled, isFalse);
    expect(
      find.text('Too many wrong codes. Tap Resend to get a new one.'),
      findsOneWidget,
    );
  });
}
