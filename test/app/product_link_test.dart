import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts_test/app/app.dart';
import 'package:jdonuts_test/app/router/app_router.dart';
import 'package:jdonuts_test/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:jdonuts_test/features/product/presentation/screens/product_detail_screen.dart';

import '../auth/presentation/test_app.dart';

GoRouter _router(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.byType(JDonutsApp)),
).read(appRouterProvider);

void main() {
  testWidgets('/product/:id opens that product when signed in', (tester) async {
    await pumpApp(tester, signedIn: true);
    _router(tester).go('/product/p-mistletoe');
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailScreen), findsOneWidget);
    expect(
      _router(tester).routeInformationProvider.value.uri.path,
      '/home/product/p-mistletoe',
    );
  });

  testWidgets('/product/:id sends a signed-out user to onboarding', (
    tester,
  ) async {
    await pumpApp(tester);
    _router(tester).go('/product/p-mistletoe');
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(ProductDetailScreen), findsNothing);
  });
}
