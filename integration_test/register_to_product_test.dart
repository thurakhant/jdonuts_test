import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'flow_helpers.dart';

/// Runs on a device or emulator against the real app: real secure storage,
/// the real Drift database file and the fake backend's real ~1 s delays.
///
/// Run: `fvm flutter test integration_test/register_to_product_test.dart -d DEVICE_ID`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('register, land on Home, open a product (on device)', (
    tester,
  ) async {
    await registerNewUser(tester);
    expect(await sessionStorage.read(key: 'auth.session'), isNotNull);

    await openProduct(tester);
    expect(find.textContaining('MMK'), findsWidgets);
  });
}
