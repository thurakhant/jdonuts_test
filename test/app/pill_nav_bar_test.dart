import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/widgets/pill_nav_bar.dart';
import 'package:material_ui/material_ui.dart';

Widget _bar(int selected, ValueChanged<int> onSelected) => MaterialApp(
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

void main() {
  testWidgets('tapping a tab reports its index', (tester) async {
    int? tapped;
    await tester.pumpWidget(_bar(0, (i) => tapped = i));
    await tester.tap(find.text('C'));
    expect(tapped, 2);
  });

  testWidgets('the pill slides to the selected tab', (tester) async {
    await tester.pumpWidget(_bar(0, (_) {}));
    final pill = find.byKey(const ValueKey('nav-pill'));
    final before = tester
        .getTopLeft(
          find.descendant(of: pill, matching: find.byType(DecoratedBox)).first,
        )
        .dx;
    await tester.pumpWidget(_bar(2, (_) {}));
    await tester.pump(const Duration(milliseconds: 100));
    final mid = tester
        .getTopLeft(
          find.descendant(of: pill, matching: find.byType(DecoratedBox)).first,
        )
        .dx;
    await tester.pumpAndSettle();
    final after = tester
        .getTopLeft(
          find.descendant(of: pill, matching: find.byType(DecoratedBox)).first,
        )
        .dx;
    expect(mid, greaterThan(before));
    expect(mid, lessThan(after));
  });

  testWidgets('Reduce Motion moves the pill instantly', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _bar(0, (_) {}),
      ),
    );
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _bar(2, (_) {}),
      ),
    );
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);
  });
}
