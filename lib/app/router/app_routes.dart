/// Route path constants. One place to change, no string literals in widgets.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String phone = '/phone';
  static const String otp = '/otp';
  static const String name = '/name';
  static const String dob = '/dob';
  static const String welcome = '/welcome';

  static const String home = '/home';
  static const String rewards = '/rewards';
  static const String donuts = '/donuts';
  static const String orders = '/orders';
  static const String settings = '/settings';

  /// Nested under Home so the detail page lives in the same navigator as
  /// the Home tiles: Hero flights only connect heroes in one navigator.
  static const String productDetailPattern = 'product/:id';

  static String productDetail(String id) => '$home/product/$id';

  static bool isProductDetail(String location) =>
      location.startsWith('$home/product/');

  /// Screens a signed-out user may visit. `welcome` is included because the
  /// session is only published when the user taps LET'S EXPLORE.
  static const Set<String> authFlow = {
    onboarding,
    phone,
    otp,
    name,
    dob,
    welcome,
  };
}
