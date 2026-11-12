import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

ElevatedButton _continue(WidgetTester t) =>
    t.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'CONTINUE'));

void main() {
  testWidgets('Continue stays disabled until the number is valid', (
    tester,
  ) async {
    await pumpApp(tester);
    await startFlow(tester, login: true, phone: '12');
    expect(_continue(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '9254135592');
    await tester.pump();
    expect(_continue(tester).onPressed, isNotNull);
  });

  testWidgets('invalid number shows an error once the field loses focus', (
    tester,
  ) async {
    await pumpApp(tester);
    await startFlow(tester, login: true, phone: '12');
    expect(find.text('Enter a valid Myanmar mobile number.'), findsNothing);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(find.text('Enter a valid Myanmar mobile number.'), findsOneWidget);
  });

  testWidgets('unregistered login number offers a link to register', (
    tester,
  ) async {
    await pumpApp(tester);
    await startFlow(tester, login: true, phone: '9123456789');
    await tapButton(tester, 'CONTINUE');
    expect(
      find.textContaining("hasn't registered", findRichText: true),
      findsOneWidget,
    );

    await tapLink(tester, 'register?');
    expect(
      find.textContaining("hasn't registered", findRichText: true),
      findsNothing,
    );
  });

  testWidgets('back keeps the typed number', (tester) async {
    await pumpApp(tester);
    await startFlow(tester, login: true);
    await tapButton(tester, 'CONTINUE');
    expect(find.text('Verify your number'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('9254135592'), findsOneWidget);
  });
}
