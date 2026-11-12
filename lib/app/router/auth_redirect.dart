import '../../features/auth/presentation/providers/auth_state_provider.dart';
import 'app_routes.dart';

/// Pure redirect rule for the auth guard.
///
/// `unknown` holds everything on the splash; once the session is known the
/// splash resolves to Home or Onboarding.
String? authRedirect(AuthStatus status, String location) {
  final inAuthFlow = AppRoutes.authFlow.contains(location);
  final onSplash = location == AppRoutes.splash;
  switch (status) {
    case AuthStatus.unknown:
      return onSplash ? null : AppRoutes.splash;
    case AuthStatus.signedOut:
      return inAuthFlow ? null : AppRoutes.onboarding;
    case AuthStatus.signedIn:
      return inAuthFlow || onSplash ? AppRoutes.home : null;
  }
}
