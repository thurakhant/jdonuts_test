import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/theme/app_spacing.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';
import 'package:material_ui/material_ui.dart';

import '../auth/presentation/test_app.dart';

/// The whole main flow on in-memory stores and the real seed file:
/// Register -> Home -> Product detail (with the hero flight).
List<double> _imageWidths(WidgetTester tester) => [
  for (final e in find.byType(Image).evaluate())
    if ((e.widget as Image).image case final AssetImage a
        when a.assetName.contains('mistletoe'))
      (e.renderObject! as RenderBox).size.width,
];

void main() {
  testWidgets('register, land on Home, open a product', (tester) async {
    await pumpApp(tester, userRegistered: false);

    // Onboarding -> phone -> OTP (fake code 123456).
    await startFlow(tester, login: false);
    await tapButton(tester, 'CONTINUE');
    await tester.enterText(find.byKey(const ValueKey('otp-box-0')), '123456');
    await tester.pumpAndSettle();

    // Name.
    await tester.enterText(find.byKey(const ValueKey('first-name')), 'Aung');
    await tester.pump();
    await tapButton(tester, 'CONTINUE');

    // Date of birth.
    await tester.tap(find.byKey(const ValueKey('dob-month')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('May'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('dob-day')), '1');
    await tester.enterText(find.byKey(const ValueKey('dob-year')), '1990');
    await tester.pump();
    await tapButton(tester, 'CONTINUE');

    // Welcome -> Home with seeded data.
    await tapButton(tester, "LET'S EXPLORE");
    expect(find.byType(PillNavBar), findsOneWidget);
    expect(find.text('Hania'), findsOneWidget);
    expect(find.text('Seasonal specials'), findsOneWidget);

    // Tap a product: its image flies to the detail screen.
    await tester.tap(find.text('Mistletoe Romance box'));
    await tester.pump();
    final midFlight = <double>[];
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 40));
      midFlight.addAll(_imageWidths(tester));
    }
    await tester.pumpAndSettle();
    final settled = _imageWidths(tester);

    // Mid-flight the shared image is between its Home size and its final
    // detail size: the Hero flight still runs after the motion changes.
    final tile = AppSpacing.productTileSize;
    final detail = settled.reduce((a, b) => a > b ? a : b);
    expect(detail, greaterThan(tile));
    expect(midFlight.any((w) => w > tile && w < detail), isTrue);

    expect(find.text('JD022118'), findsOneWidget);
    expect(find.text('Mistletoe Romance box'), findsOneWidget);
    expect(find.textContaining('MMK'), findsWidgets);
  });
}
