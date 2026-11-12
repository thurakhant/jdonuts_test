/// Route path constants. One place to change, no string literals in widgets.
abstract final class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String phone = '/phone';
  static const String otp = '/otp';
  static const String name = '/name';
  static const String dob = '/dob';
  static const String welcome = '/welcome';

  static const String home = '/home';
  static const String rewards = '/rewards';
  static const String scan = '/scan';
  static const String orders = '/orders';
  static const String settings = '/settings';

  static const String productDetailPattern = '/product/:id';

  static String productDetail(String id) => '/product/$id';

  /// Screens a signed-out user may visit.
  static const Set<String> authFlow = {onboarding, phone, otp, name, dob};
}
