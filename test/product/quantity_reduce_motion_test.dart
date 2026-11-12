import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/product/presentation/widgets/quantity_stepper.dart';
import 'package:jdonuts_test/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

Widget _stepper({required bool reduce}) {
  var quantity = 1;
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduce),
        child: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => QuantityStepper(
              quantity: quantity,
              onChanged: (q) => setState(() => quantity = q),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('quantity animates its change normally', (tester) async {
    await tester.pumpWidget(_stepper(reduce: false));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    // Old and new numbers overlap while the switch animates.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('with Reduce Motion the quantity changes at once', (
    tester,
  ) async {
    await tester.pumpWidget(_stepper(reduce: true));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });
}
