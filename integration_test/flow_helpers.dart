import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/app.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';
import 'package:material_ui/material_ui.dart';

/// Shared steps for the on-device tests. They drive the real app, so they
/// wait for each screen instead of settling (shimmer and the carousel never
/// stop) and close the real keyboard before tapping.

const sessionStorage = FlutterSecureStorage();
const _otpBox = ValueKey('otp-box-0');
const _dobMonth = ValueKey('dob-month');

/// Starts the app signed out and registers a new number, ending on Home with
/// its data shown. Saved users are kept; a fresh number avoids them.
Future<void> registerNewUser(WidgetTester tester) async {
  // Type through Flutter's test text input: some phone keyboards (seen on
  // an Infinix) reset text the test entered when they connect.
  tester.binding.testTextInput.register();
  await sessionStorage.delete(key: 'auth.session');
  final digits = DateTime.now().millisecondsSinceEpoch % 90000000 + 10000000;

  await tester.pumpWidget(const ProviderScope(child: JDonutsApp()));

  await tapButton(tester, "LET'S GET STARTED", next: find.byType(TextField));
  await tester.enterText(find.byType(TextField), '9$digits');
  await tapButton(tester, 'CONTINUE', next: find.byKey(_otpBox));

  await tester.enterText(find.byKey(_otpBox), '123456');
  await waitFor(tester, find.byKey(const ValueKey('first-name')));
  await tester.enterText(find.byKey(const ValueKey('first-name')), 'Aung');
  await tapButton(tester, 'CONTINUE', next: find.byKey(_dobMonth));

  await closeKeyboard(tester);
  await tester.tap(find.byKey(_dobMonth));
  final may = find.text('May').last;
  await waitFor(tester, may);
  // The month sheet can open with May below a short screen's edge.
  await tester.ensureVisible(may);
  await settleFor(tester, const Duration(milliseconds: 300));
  await tester.tap(may);
  await settleFor(tester, const Duration(milliseconds: 600));
  await tester.enterText(find.byKey(const ValueKey('dob-day')), '1');
  await tester.enterText(find.byKey(const ValueKey('dob-year')), '1990');
  await tapButton(tester, 'CONTINUE', next: button("LET'S EXPLORE"));

  await tapButton(tester, "LET'S EXPLORE", next: find.byType(PillNavBar));
  await waitFor(tester, find.text('Seasonal specials'));
}

/// From Home: lifts the Seasonal row fully on screen and opens a product.
Future<void> openProduct(WidgetTester tester) async {
  final product = find.text('Mistletoe Romance box');
  await tester.drag(find.text('Seasonal specials'), const Offset(0, -250));
  await waitFor(tester, product);
  await tester.ensureVisible(product);
  await settleFor(tester, const Duration(milliseconds: 300));
  await tester.tap(product);
  await waitFor(tester, find.text('JD022118'));
}

/// A bottom-nav tab, found by its accessibility label.
Finder navTab(String label) => find.byWidgetPredicate(
  (w) => w is Semantics && w.properties.label == label,
);

Finder button(String label) => find.widgetWithText(ElevatedButton, label);

/// Taps a button once it exists, then waits for [next].
Future<void> tapButton(
  WidgetTester tester,
  String label, {
  Finder? next,
}) async {
  await waitFor(tester, button(label));
  await closeKeyboard(tester);
  await tester.ensureVisible(button(label));
  await tester.pump();
  await tester.tap(button(label));
  if (next != null) await waitFor(tester, next);
}

/// Pumps frames until [finder] matches.
Future<void> waitFor(
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
Future<void> closeKeyboard(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await settleFor(tester, const Duration(milliseconds: 600));
}

/// Lets real time pass while frames keep being drawn.
Future<void> settleFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
