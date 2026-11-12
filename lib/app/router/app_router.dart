import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'app_routes.dart';

/// Builds the app router with the auth redirect guard.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authStatusProvider);

  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    redirect: (context, state) => _redirect(authStatus, state.matchedLocation),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: AppRoutes.phone,
        builder: (_, _) => const PlaceholderScreen(title: 'Phone number'),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, _) => const PlaceholderScreen(title: 'Verify number'),
      ),
      GoRoute(
        path: AppRoutes.name,
        builder: (_, _) => const PlaceholderScreen(title: 'Name'),
      ),
      GoRoute(
        path: AppRoutes.dob,
        builder: (_, _) => const PlaceholderScreen(title: 'Date of birth'),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const PlaceholderScreen(title: 'Welcome'),
      ),
      GoRoute(
        path: AppRoutes.productDetailPattern,
        builder: (_, state) => PlaceholderScreen(
          title: 'Product ${state.pathParameters['id']}',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          _branch(AppRoutes.home, 'Home'),
          _branch(AppRoutes.rewards, 'Rewards'),
          _branch(AppRoutes.scan, 'Scan'),
          _branch(AppRoutes.orders, 'Orders'),
          _branch(AppRoutes.settings, 'Settings'),
        ],
      ),
    ],
  );
});

StatefulShellBranch _branch(String path, String title) {
  return StatefulShellBranch(
    routes: [
      GoRoute(path: path, builder: (_, _) => PlaceholderScreen(title: title)),
    ],
  );
}

/// Signed-out users stay in the auth flow; signed-in users skip it.
String? _redirect(AuthStatus status, String location) {
  final inAuthFlow = AppRoutes.authFlow.contains(location);
  switch (status) {
    case AuthStatus.unknown:
      return null;
    case AuthStatus.signedOut:
      return inAuthFlow ? null : AppRoutes.onboarding;
    case AuthStatus.signedIn:
      return inAuthFlow ? AppRoutes.home : null;
  }
}
