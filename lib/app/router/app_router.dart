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
import '../../features/product/domain/product.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/rewards/presentation/screens/rewards_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import '../motion/shared_axis_page.dart';
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
  _stepPage(AppRoutes.phone, (_) => const PhoneScreen()),
  _stepPage(AppRoutes.otp, (_) => const OtpScreen()),
  _stepPage(AppRoutes.name, (_) => const NameScreen()),
  _stepPage(AppRoutes.dob, (_) => const DobScreen()),
  _stepPage(AppRoutes.welcome, (_) => const WelcomeScreen()),
  StatefulShellRoute.indexedStack(
    builder: (_, state, shell) => AppShell(
      navigationShell: shell,
      showNavBar: !AppRoutes.isProductDetail(state.uri.path),
    ),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, _) => const HomeScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.productDetailPattern,
                builder: (_, state) => ProductDetailScreen(
                  productId: state.pathParameters['id']!,
                  initial: state.extra as Product?,
                ),
              ),
            ],
          ),
        ],
      ),
      _branch(AppRoutes.rewards, (_) => const RewardsScreen()),
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

/// Auth steps move with a shared-axis transition.
GoRoute _stepPage(String path, WidgetBuilder builder) => GoRoute(
  path: path,
  pageBuilder: (context, state) =>
      sharedAxisPage(context: context, state: state, child: builder(context)),
);

GoRoute _page(String path, WidgetBuilder builder) =>
    GoRoute(path: path, builder: (context, _) => builder(context));

StatefulShellBranch _branch(String path, WidgetBuilder builder) {
  return StatefulShellBranch(routes: [_page(path, builder)]);
}
