import 'dart:ui' show AccessibilityFeatures;

import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/challenge_painters.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/points_ring.dart';
import 'package:material_ui/material_ui.dart';

import '../support/test_app.dart';

/// Pumps small steps until the member record has loaded and the screen
/// shows, so animation checks start from the first frames.
Future<void> _pumpUntilShown(WidgetTester tester) async {
  await pumpScreen(tester, const RewardsScreen());
  for (var i = 0; i < 100 && find.text('Rewards').evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
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
  testWidgets('renders ring, tier ladder, tabs and challenge cards', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await tester.pumpAndSettle();

    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // bell badge
    expect(find.text('680,000'), findsOneWidget);
    expect(find.text('500 points to Gold'), findsOneWidget);
    for (final tier in ['Bronze', 'Silver', 'Gold', 'Platinum']) {
      expect(find.text(tier), findsOneWidget);
    }
    expect(find.text('Challenges'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Donut dozen'), findsOneWidget);
    expect(find.text('Coffee break'), findsOneWidget);
    expect(find.text('8 / 12'), findsOneWidget);
    expect(find.text('+300 pts'), findsOneWidget);
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

  testWidgets('both progress painters are used by the challenge cards', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await tester.pumpAndSettle();
    final painters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((p) => p.painter.runtimeType);
    expect(painters, contains(QuarterDonutPainter));
    expect(painters, contains(CoffeeCupPainter));
  });

  testWidgets('switching to History swaps the list and moves the indicator', (
    tester,
  ) async {
    await _pumpUntilShown(tester);
    await tester.pumpAndSettle();
    final indicator = find.descendant(
      of: find.byKey(const ValueKey('tab-indicator')),
      matching: find.byType(Container),
    );
    final before = tester.getCenter(indicator).dx;

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(tester.getCenter(indicator).dx, greaterThan(before));
    expect(find.text('Donut dozen'), findsNothing);
    expect(find.text('Classic Glazed x6'), findsOneWidget);
    expect(find.text('3 days ago'), findsOneWidget);
    expect(find.text('1 day ago'), findsOneWidget);

    await tester.tap(find.text('Challenges'));
    await tester.pumpAndSettle();
    expect(find.text('Donut dozen'), findsOneWidget);
  });

  testWidgets('Earn claims a finished challenge', (tester) async {
    await _pumpUntilShown(tester);
    await tester.pumpAndSettle();
    expect(find.text('Claimed'), findsOneWidget);
    expect(find.text('Earn'), findsOneWidget);

    await tester.tap(find.text('Earn'));
    await tester.pumpAndSettle();
    expect(find.text('Earn'), findsNothing);
    expect(find.text('Claimed'), findsNWidgets(2));
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
    expect(find.text('Donut dozen'), findsOneWidget);
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
