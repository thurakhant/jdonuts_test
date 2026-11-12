import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jdonuts_test/app/app.dart';

void main() {
  testWidgets('app boots to the Onboarding screen when signed out', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: JDonutsApp()));
    await tester.pumpAndSettle();

    expect(find.text('Onboarding'), findsWidgets);
  });
}
