import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import 'flow_helpers.dart';

/// Records frame timings while the main animations run on a real phone:
/// Home scroll, the product Hero there and back, the Rewards entrance (ring
/// sweep, count-up, tier ladder) and the Rewards tab switch.
///
/// Run in profile mode on a physical Android phone:
/// `fvm flutter drive --profile --driver=test_driver/perf_driver.dart
///  --target=integration_test/performance_test.dart -d DEVICE_ID`
/// The summary is written to `build/performance.json`.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('main animations stay within the 60 fps frame budget', (
    tester,
  ) async {
    await registerNewUser(tester);
    // Let Home's entrance and image decoding finish before measuring.
    await settleFor(tester, const Duration(seconds: 2));
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    await binding.watchPerformance(() async {
      final home = find.byType(Scrollable).first;
      await tester.fling(home, const Offset(0, -500), 1500);
      await settleFor(tester, const Duration(seconds: 1));
      await tester.fling(home, const Offset(0, 500), 1500);
      await settleFor(tester, const Duration(seconds: 1));

      await openProduct(tester);
      await settleFor(tester, const Duration(seconds: 1));
      await tester.tap(find.byIcon(Icons.arrow_back));
      await settleFor(tester, const Duration(seconds: 1));

      await tester.tap(navTab('Reward'));
      await settleFor(tester, const Duration(seconds: 3));
      await tester.tap(find.text('Gift'));
      await settleFor(tester, const Duration(seconds: 1));
      await tester.tap(find.text('Eat more earn more'));
      await settleFor(tester, const Duration(seconds: 1));
      await tester.tap(navTab('Home'));
      await settleFor(tester, const Duration(seconds: 1));
    }, reportKey: 'performance');
  });
}
