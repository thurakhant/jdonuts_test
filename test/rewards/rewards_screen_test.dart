import 'dart:ui' show AccessibilityFeatures;

import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/challenge_painters.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/earn_button.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/points_ring.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/tier_ladder.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

const _heading = "J' Donuts Rewards";

/// The member's tier progress in the bundled seed.
const _seedProgress = 0.78;

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
    expect(_ringFraction(tester), closeTo(_seedProgress, 0.0001));
  });

  testWidgets('points count up from zero to 680,000', (tester) async {
    await _pumpUntilShown(tester);
    expect(find.text('680,000'), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('680,000'), findsNothing);
    expect(_ringFraction(tester), lessThan(_seedProgress));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('680,000'), findsOneWidget);
    expect(_ringFraction(tester), closeTo(_seedProgress, 0.0001));
  });

  testWidgets('the line to the next tier fills to the member progress', (
    tester,
  ) async {
    double fill() {
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byKey(const ValueKey('tier-line-silver')),
          matching: find.byType(CustomPaint),
        ),
      );
      return (paint.painter! as TierLinePainter).fill;
    }

    await _pumpUntilShown(tester);
    await tester.pump(const Duration(milliseconds: 100));
    expect(fill(), 0); // rows enter first
    await _settle(tester);
    expect(fill(), closeTo(_seedProgress, 0.0001));
  });

  testWidgets('donut progress clips the image and coffee uses its arc', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    final clippers = tester
        .widgetList<ClipPath>(find.byType(ClipPath))
        .map((c) => c.clipper.runtimeType);
    expect(clippers, contains(SectorClipper));
    final painters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((p) => p.painter.runtimeType);
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

  testWidgets('switching to Gift slides the pill and swaps the list', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    final indicator = find.byKey(const ValueKey('tab-indicator'));
    final start = tester.getCenter(indicator).dx;
    final target = tester.getCenter(find.text('Gift')).dx;

    await tester.tap(find.text('Gift'));
    await tester.pump(); // starts the slide
    await tester.pump(const Duration(milliseconds: 120));
    final midway = tester.getCenter(indicator).dx;
    expect(midway, greaterThan(start));
    expect(midway, lessThan(target - 1));

    await _settle(tester);
    expect(tester.getCenter(indicator).dx, closeTo(target, 1));
    expect(find.text('Eat 4 Coco donuts'), findsNothing);
    expect(find.text('Gifts you receive will show up here.'), findsOneWidget);

    await tester.tap(find.text('Eat more earn more'));
    await _settle(tester);
    expect(find.text('Eat 4 Coco donuts'), findsNWidgets(2));
  });

  testWidgets('claiming once marks the card claimed and survives tab switch', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);

    await tester.tap(find.text('EARN').first);
    await _settle(tester);
    expect(find.text('CLAIMED'), findsOneWidget);
    expect(find.text('EARN'), findsNWidgets(2));
    final claimed = tester.widget<EarnButton>(find.byType(EarnButton).first);
    expect(claimed.enabled, isFalse);

    // A second tap on the claimed button does nothing.
    await tester.tap(find.text('CLAIMED'));
    await _settle(tester);
    expect(find.text('CLAIMED'), findsOneWidget);

    await tester.tap(find.text('Gift'));
    await _settle(tester);
    await tester.tap(find.text('Eat more earn more'));
    await _settle(tester);
    expect(find.text('CLAIMED'), findsOneWidget);
    expect(
      tester
          .widgetList<EarnButton>(find.byType(EarnButton))
          .map((b) => b.enabled),
      [false, false, false],
    );
  });

  testWidgets('a finished donut is fully coloured on the first frame back', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await _settle(tester);
    await tester.tap(find.text('Gift'));
    await _settle(tester);
    await tester.tap(find.text('Eat more earn more'));
    await tester.pump(); // first frame of the rebuilt list

    final sweeps = tester
        .widgetList<ClipPath>(find.byType(ClipPath))
        .map((c) => c.clipper)
        .whereType<SectorClipper>()
        .map((c) => c.sweep)
        .toList();
    // 4/4 is a full circle at once; 1/4 still animates in from empty.
    expect(sweeps.first, closeTo(2 * 3.141592653589793, 0.0001));
  });

  testWidgets('fits a 4.7-inch phone at text scale 1.3 without overflow', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpUntilShown(tester);
    tester.view.physicalSize = const Size(360, 640) * 2;
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('EARN'), findsNWidgets(3));
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
    expect(_ringFraction(tester), closeTo(_seedProgress, 0.0001));
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
