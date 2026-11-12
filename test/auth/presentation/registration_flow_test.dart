import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

ElevatedButton _continue(WidgetTester t) =>
    t.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'CONTINUE'));

Future<void> _toNameStep(WidgetTester tester) async {
  await pumpApp(tester, userRegistered: false);
  await startFlow(tester, login: false);
  await tapButton(tester, 'CONTINUE');
  await tester.enterText(find.byKey(const ValueKey('otp-box-0')), '123456');
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('already registered number in register mode links to log in', (
    tester,
  ) async {
    await pumpApp(tester);
    await startFlow(tester, login: false);
    await tapButton(tester, 'CONTINUE');
    expect(
      find.textContaining('already registered', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('name step: first name required, last name optional', (
    tester,
  ) async {
    await _toNameStep(tester);
    expect(_continue(tester).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('first-name')), 'Mya 2');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(
      find.text('Names can only contain letters and spaces.'),
      findsOneWidget,
    );
    expect(_continue(tester).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('first-name')), 'Mya');
    await tester.pump();
    expect(_continue(tester).onPressed, isNotNull);
  });

  testWidgets('full registration ends on Welcome, then Home', (tester) async {
    await _toNameStep(tester);
    await tester.enterText(find.byKey(const ValueKey('first-name')), 'Aung');
    await tester.enterText(find.byKey(const ValueKey('last-name')), 'Min');
    await tester.pump();
    await tapButton(tester, 'CONTINUE');

    expect(find.text("What's your date of birth?"), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('dob-month')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('May'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('dob-day')), '1');
    await tester.enterText(find.byKey(const ValueKey('dob-year')), '2030');
    await tester.pump();
    expect(find.text("Date of birth can't be in the future."), findsOneWidget);
    expect(_continue(tester).onPressed, isNull);

    await tester.enterText(find.byKey(const ValueKey('dob-year')), '1980');
    await tester.pump();
    await tapButton(tester, 'CONTINUE');
    expect(find.text("LET'S EXPLORE"), findsOneWidget);

    await tapButton(tester, "LET'S EXPLORE");
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
