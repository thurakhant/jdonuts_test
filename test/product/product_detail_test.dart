import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/product/presentation/screens/product_detail_screen.dart';

import '../support/test_app.dart';

Future<void> _open(WidgetTester tester, String id) async {
  await pumpScreen(tester, ProductDetailScreen(productId: id));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows code, name, price, New badge and description', (
    tester,
  ) async {
    await _open(tester, 'p-coconut');

    expect(find.text('JD022123'), findsOneWidget);
    expect(find.text('Coconut Donut'), findsOneWidget);
    // Card price and button total both read 3,200 MMK at quantity 1.
    expect(find.text('3,200 MMK'), findsNWidgets(2));
    expect(find.text('New'), findsOneWidget);
    expect(find.text("What's this?"), findsOneWidget);
    expect(find.textContaining('Enjoy our scrumptious donuts'), findsOneWidget);
    expect(find.text('ADD TO CART'), findsOneWidget);
  });

  testWidgets('New badge is hidden for products that are not new', (
    tester,
  ) async {
    await _open(tester, 'p-classic-glazed');
    expect(find.text('New'), findsNothing);
  });

  testWidgets('stepper updates the total live and stops at 1', (tester) async {
    await _open(tester, 'p-coconut');
    final plus = find.byTooltip('Increase quantity');
    final minus = find.byTooltip('Decrease quantity');

    await tester.tap(plus);
    await tester.pumpAndSettle();
    expect(find.text('6,400 MMK'), findsOneWidget);

    await tester.tap(plus);
    await tester.pumpAndSettle();
    expect(find.text('9,600 MMK'), findsOneWidget);

    await tester.tap(minus);
    await tester.pump();
    await tester.tap(minus);
    await tester.pumpAndSettle();
    expect(find.text('3,200 MMK'), findsNWidgets(2));

    await tester.tap(minus); // already at 1: no change
    await tester.pumpAndSettle();
    expect(find.text('3,200 MMK'), findsNWidgets(2));
  });

  testWidgets('Add to cart gives feedback only', (tester) async {
    await _open(tester, 'p-coconut');
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD TO CART'));
    await tester.pump();
    expect(find.text('Added 2 x Coconut Donut to your cart'), findsOneWidget);
  });

  testWidgets('an unknown id shows a not-found message', (tester) async {
    await _open(tester, 'nope');
    expect(find.text("We couldn't find that product."), findsOneWidget);
    expect(find.textContaining('ADD TO CART'), findsNothing);
  });
}
