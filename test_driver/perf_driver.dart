import 'package:integration_test/integration_test_driver.dart';

/// Host side of `flutter drive`: saves the device's report data (frame
/// timings) to `build/performance.json`.
Future<void> main() => integrationDriver();
