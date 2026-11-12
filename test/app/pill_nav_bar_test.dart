import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';
import 'package:material_ui/material_ui.dart';

Widget _bar(int selected, ValueChanged<int> onSelected, {bool reduce = false}) {
  final app = MaterialApp(
    home: Scaffold(
      bottomNavigationBar: PillNavBar(
        selectedIndex: selected,
        onSelected: onSelected,
        items: const [
          PillNavItem(icon: Icons.home, label: 'A'),
          PillNavItem(icon: Icons.star, label: 'B'),
          PillNavItem(icon: Icons.add, label: 'C'),
        ],
      ),
    ),
  );
  return reduce
      ? MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: app,
        )
      : app;
}

final _pill = find.byKey(const ValueKey('nav-pill'));

void main() {
  testWidgets('only the selected tab shows its label', (tester) async {
    await tester.pumpWidget(_bar(1, (_) {}));
    await tester.pumpAndSettle();
    expect(find.text('B'), findsOneWidget);
    expect(find.text('A'), findsNothing);
    expect(find.text('C'), findsNothing);
  });

  testWidgets('tapping a tab reports its index', (tester) async {
    int? tapped;
    await tester.pumpWidget(_bar(0, (i) => tapped = i));
    await tester.tap(find.byIcon(Icons.add));
    expect(tapped, 2);
  });

  testWidgets('the pink pill slides to the selected tab', (tester) async {
    await tester.pumpWidget(_bar(0, (_) {}));
    await tester.pumpAndSettle();
    final before = tester.getTopLeft(_pill).dx;
    await tester.pumpWidget(_bar(2, (_) {}));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final mid = tester.getTopLeft(_pill).dx;
    await tester.pumpAndSettle();
    final after = tester.getTopLeft(_pill).dx;
    expect(mid, greaterThan(before));
    expect(after, greaterThan(before));
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('Reduce Motion moves the pill instantly', (tester) async {
    await tester.pumpWidget(_bar(0, (_) {}, reduce: true));
    await tester.pumpWidget(_bar(2, (_) {}, reduce: true));
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);
  });
}
