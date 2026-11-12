import 'dart:ui' show AccessibilityFeatures;

import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/challenge_painters.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/earn_button.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/points_ring.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

const _heading = "J' Donuts Rewards";

/// Pumps small steps until the member record has loaded and the screen
/// shows, so animation checks start from the first frames.
Future<void> _pumpUntilShown(WidgetTester tester) async {
  await pumpScreen(tester, const RewardsScreen());
  for (var i = 0; i < 100 && find.text(_heading).evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
}

/// The EARN pulse never stops, so settle with a bounded pump instead of
/// pumpAndSettle.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump(); // starts any animation a rebuild just scheduled
  await tester.pump(const Duration(seconds: 3));
}

double _ringFraction(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is PointsRingPainter,
    ),
  );
  return (paint.painter! as PointsRingPainter).fraction;
}

void main() {
  testWidgets('renders heading, ladder, ring, tabs and the three cards', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);

    expect(find.text(_heading), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // pill badge
    expect(find.text('Silver'), findsOneWidget);
    expect(find.text("You're here now"), findsOneWidget);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.text('500 pts Remaining to become Gold'), findsOneWidget);
    expect(find.text('Platinum'), findsOneWidget);
    expect(find.text("You'll be here soon"), findsOneWidget);
    expect(find.text('Bronze'), findsNothing);
    expect(find.text('Total points'), findsOneWidget);
    expect(find.text('680,000'), findsOneWidget);
    expect(find.text('Eat more earn more'), findsOneWidget);
    expect(find.text('Gift'), findsOneWidget);
    expect(find.text('Eat 4 Coco donuts'), findsNWidgets(2));
    expect(find.text('Drink 12 cups americano'), findsOneWidget);
    for (final progress in ['4/4', '1/4', '9/12']) {
      expect(find.text(progress), findsOneWidget);
    }
    expect(find.text('100 pts'), findsNWidgets(3));
    expect(find.text('EARN'), findsNWidgets(3));
    expect(_ringFraction(tester), closeTo(680000 / 680500, 0.0001));
  });

  testWidgets('points count up from zero to 680,000', (tester) async {
    await _pumpUntilShown(tester);
    expect(find.text('680,000'), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('680,000'), findsNothing);
    expect(_ringFraction(tester), lessThan(680000 / 680500));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('680,000'), findsOneWidget);
    expect(_ringFraction(tester), closeTo(680000 / 680500, 0.0001));
  });

  testWidgets('donut and coffee painters are both used', (tester) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    final painters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((p) => p.painter.runtimeType);
    expect(painters, contains(QuarterDonutPainter));
    expect(painters, contains(CoffeeCupPainter));
  });

  testWidgets('only the finished challenge has an active EARN button', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    final buttons = tester
        .widgetList<EarnButton>(find.byType(EarnButton))
        .map((b) => b.enabled)
        .toList();
    expect(buttons, [true, false, false]);
  });

  testWidgets('switching to Gift swaps the list and moves the pill', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    final indicator = find.descendant(
      of: find.byKey(const ValueKey('tab-indicator')),
      matching: find.byType(DecoratedBox),
    );
    final before = tester.getCenter(indicator.first).dx;

    await tester.tap(find.text('Gift'));
    await _settle(tester);

    expect(tester.getCenter(indicator.first).dx, greaterThan(before));
    expect(find.text('Eat 4 Coco donuts'), findsNothing);
    expect(find.text('Gifts you receive will show up here.'), findsOneWidget);

    await tester.tap(find.text('Eat more earn more'));
    await _settle(tester);
    expect(find.text('Eat 4 Coco donuts'), findsNWidgets(2));
  });

  testWidgets('Reduce Motion shows the final state at once, no timers', (
    tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const _ReduceMotion();
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await _pumpUntilShown(tester);
    await tester.pump();

    expect(find.text('680,000'), findsOneWidget);
    expect(_ringFraction(tester), closeTo(680000 / 680500, 0.0001));
    expect(find.text('Eat 4 Coco donuts'), findsNWidgets(2));
    // No looping EARN pulse and no running tweens.
    expect(tester.hasRunningAnimations, isFalse);
  });
}

class _ReduceMotion implements AccessibilityFeatures {
  const _ReduceMotion();

  @override
  bool get disableAnimations => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => false;
}
