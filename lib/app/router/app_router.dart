import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/screens/dob_screen.dart';
import '../../features/auth/presentation/screens/name_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/phone_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'app_routes.dart';
import 'auth_redirect.dart';

/// The app router, created once. Auth changes reach it through a listenable
/// so redirects re-run without rebuilding the router or losing navigation
/// state.
final appRouterProvider = Provider<GoRouter>((ref) {
  final status = ValueNotifier<AuthStatus>(ref.read(authStatusProvider));
  ref.listen(authStatusProvider, (_, next) => status.value = next);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: status,
    redirect: (context, state) =>
        authRedirect(status.value, state.matchedLocation),
    routes: _routes,
  );
  ref.onDispose(() {
    router.dispose();
    status.dispose();
  });
  return router;
});

final List<RouteBase> _routes = [
  _page(AppRoutes.splash, (_) => const SplashScreen()),
  _page(AppRoutes.onboarding, (_) => const OnboardingScreen()),
  _page(AppRoutes.phone, (_) => const PhoneScreen()),
  _page(AppRoutes.otp, (_) => const OtpScreen()),
  _page(AppRoutes.name, (_) => const NameScreen()),
  _page(AppRoutes.dob, (_) => const DobScreen()),
  _page(AppRoutes.welcome, (_) => const WelcomeScreen()),
  GoRoute(
    path: AppRoutes.productDetailPattern,
    builder: (_, state) =>
        ProductDetailScreen(productId: state.pathParameters['id']!),
  ),
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => AppShell(navigationShell: shell),
    branches: [
      _branch(AppRoutes.home, (_) => const HomeScreen()),
      _branch(
        AppRoutes.rewards,
        (_) => const PlaceholderScreen(title: 'Rewards'),
      ),
      _branch(
        AppRoutes.scan,
        (c) => PlaceholderScreen(title: AppLocalizations.of(c)!.scanTab),
      ),
      _branch(
        AppRoutes.orders,
        (c) => PlaceholderScreen(title: AppLocalizations.of(c)!.ordersTab),
      ),
      _branch(AppRoutes.settings, (_) => const SettingsScreen()),
    ],
  ),
];

GoRoute _page(String path, WidgetBuilder builder) =>
    GoRoute(path: path, builder: (context, _) => builder(context));

StatefulShellBranch _branch(String path, WidgetBuilder builder) {
  return StatefulShellBranch(routes: [_page(path, builder)]);
}
