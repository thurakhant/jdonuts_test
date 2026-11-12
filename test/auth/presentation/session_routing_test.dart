import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';

import 'test_app.dart';

void main() {
  testWidgets('relaunch with a stored session opens Home', (tester) async {
    await pumpApp(tester, signedIn: true);
    expect(find.byType(PillNavBar), findsOneWidget);
    expect(find.text('Round food for\nevery mood'), findsNothing);
  });

  testWidgets('relaunch signed out opens Onboarding', (tester) async {
    await pumpApp(tester);
    expect(find.text('Round food for\nevery mood'), findsOneWidget);
    expect(find.byType(PillNavBar), findsNothing);
  });

  testWidgets('Log out in Settings returns to Onboarding', (tester) async {
    final sessions = await pumpApp(tester, signedIn: true);
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    expect(find.text('Round food for\nevery mood'), findsOneWidget);
    expect(await sessions.read(), isNull);
  });

  testWidgets('placeholder sheet opens from a social button', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.apple));
    await tester.pumpAndSettle();
    expect(find.textContaining('No real integration'), findsOneWidget);
  });
}
