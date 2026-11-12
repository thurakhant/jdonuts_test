import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jdonuts_test/app/app.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';
import 'package:material_ui/material_ui.dart';

/// Runs on a device or emulator against the real app: real secure storage,
/// the real Drift database file and the fake backend's real ~1 s delays.
///
/// Run: `fvm flutter test integration_test -d emulator-5554`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register, land on Home, open a product (on device)', (
    tester,
  ) async {
    // Start signed out. Saved users are kept; a new number avoids them.
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth.session');
    final digits = DateTime.now().millisecondsSinceEpoch % 90000000 + 10000000;
    final phone = '9$digits';

    await tester.pumpWidget(const ProviderScope(child: JDonutsApp()));

    await _tapButton(tester, "LET'S GET STARTED", next: find.byType(TextField));
    await tester.enterText(find.byType(TextField), phone);
    await _tapButton(tester, 'CONTINUE', next: find.byKey(_otpBox));

    await tester.enterText(find.byKey(_otpBox), '123456');
    await _waitFor(tester, find.byKey(const ValueKey('first-name')));
    await tester.enterText(find.byKey(const ValueKey('first-name')), 'Aung');
    await _tapButton(tester, 'CONTINUE', next: find.byKey(_dobMonth));

    await _closeKeyboard(tester);
    await tester.tap(find.byKey(_dobMonth));
    final may = find.text('May').last;
    await _waitFor(tester, may);
    // The month sheet can open with May below a short screen's edge.
    await tester.ensureVisible(may);
    await _settleFor(tester, const Duration(milliseconds: 300));
    await tester.tap(may);
    await _settleFor(tester, const Duration(milliseconds: 600));
    await tester.enterText(find.byKey(const ValueKey('dob-day')), '1');
    await tester.enterText(find.byKey(const ValueKey('dob-year')), '1990');
    await _tapButton(tester, 'CONTINUE', next: _button("LET'S EXPLORE"));

    await _tapButton(tester, "LET'S EXPLORE", next: find.byType(PillNavBar));
    await _waitFor(tester, find.text('Seasonal specials'));
    expect(await storage.read(key: 'auth.session'), isNotNull);

    final product = find.text('Mistletoe Romance box');
    // Lift Home so the Seasonal row is fully on screen, then open a product.
    await tester.drag(find.text('Seasonal specials'), const Offset(0, -250));
    await _waitFor(tester, product);
    await tester.ensureVisible(product);
    await _settleFor(tester, const Duration(milliseconds: 300));
    await tester.tap(product);
    await _waitFor(tester, find.text('JD022118'));
    expect(find.textContaining('MMK'), findsWidgets);
  });
}

const _otpBox = ValueKey('otp-box-0');
const _dobMonth = ValueKey('dob-month');

Finder _button(String label) => find.widgetWithText(ElevatedButton, label);

/// Taps a button, then waits for [next] (or for the button to be enabled
/// first, since the app's real calls take about a second).
Future<void> _tapButton(
  WidgetTester tester,
  String label, {
  Finder? next,
}) async {
  await _waitFor(tester, _button(label));
  await _closeKeyboard(tester);
  await tester.ensureVisible(_button(label));
  await tester.pump();
  await tester.tap(_button(label));
  if (next != null) await _waitFor(tester, next);
}

/// Pumps frames until [finder] matches. The app never fully settles (shimmer,
/// carousel), so pumpAndSettle can't be used here.
Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for $finder');
}

/// A real keyboard can cover buttons; close it and let the layout grow back.
Future<void> _closeKeyboard(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await _settleFor(tester, const Duration(milliseconds: 600));
}

Future<void> _settleFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
