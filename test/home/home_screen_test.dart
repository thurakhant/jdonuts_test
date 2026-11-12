import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:jdonuts_test/app/widgets/skeleton.dart';
import 'package:jdonuts_test/core/catalog/asset_catalog_source.dart';
import 'package:jdonuts_test/features/home/presentation/screens/home_screen.dart';

import '../support/data_overrides.dart';
import '../support/test_app.dart';

const _offline = "You're offline — showing saved data";

void main() {
  testWidgets('renders member header, sections and shops from the DB', (
    tester,
  ) async {
    await pumpScreen(tester, const HomeScreen());
    await tester.pumpAndSettle();

    expect(find.text('Hania'), findsOneWidget);
    expect(find.text('Silver member'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('500 points left to become Gold Member'), findsOneWidget);
    expect(find.text('Seasonal specials'), findsOneWidget);
    expect(find.text('Popular 🔥'), findsOneWidget);
    expect(find.text('Order again'), findsOneWidget);
    expect(find.text('Mistletoe Romance box'), findsOneWidget);
    expect(find.text('Coconut Donut'), findsOneWidget);
    expect(find.text('Iced Americano'), findsOneWidget);
    // Once on the Hot deals banner badge, once on the discounted product.
    expect(find.text('50% off'), findsNWidgets(2));
    expect(find.text('20% off'), findsOneWidget);
    expect(find.text("There are 4 J'Donut shops near you. 😋"), findsOneWidget);
    expect(find.text("Myaynigone J'Donut"), findsOneWidget);
    expect(find.text(_offline), findsNothing);
  });

  testWidgets('shows skeletons (not spinners) while loading', (tester) async {
    final gate = Completer<String>();
    await pumpScreen(
      tester,
      const HomeScreen(),
      source: AssetCatalogSource(load: () => gate.future),
    );
    await tester.pump();

    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    gate.complete(seedFileText());
    await tester.pumpAndSettle();
    expect(find.byType(SkeletonBox), findsNothing);
    expect(find.text('Hania'), findsOneWidget);
  });

  testWidgets('offline banner appears when connectivity says offline', (
    tester,
  ) async {
    await pumpScreen(tester, const HomeScreen(), online: Stream.value(false));
    await tester.pumpAndSettle();

    expect(find.text(_offline), findsOneWidget);
    expect(
      find.text('Coconut Donut'),
      findsOneWidget,
    ); // saved data still shown
  });

  testWidgets('reconnecting triggers a background refresh', (tester) async {
    final online = StreamController<bool>();
    final source = CountingSource(seedFileSource());
    await pumpScreen(
      tester,
      const HomeScreen(),
      online: online.stream,
      source: source,
    );
    online.add(false);
    await tester.pumpAndSettle();
    expect(source.fetches, 1); // first-launch seed only

    online.add(true);
    await tester.pumpAndSettle();
    expect(source.fetches, 2);
    expect(find.text(_offline), findsNothing);
    await online.close();
  });

  testWidgets('a broken seed shows a friendly error with Retry', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      const HomeScreen(),
      source: AssetCatalogSource(load: () async => 'not json'),
    );
    // No pumpAndSettle: any skeleton left on screen shimmers forever.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Retry'), findsWidgets);
    expect(
      find.textContaining('The saved menu data looks broken'),
      findsWidgets,
    );
  });
}
