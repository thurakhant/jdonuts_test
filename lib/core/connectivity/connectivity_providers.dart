import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_service.dart';
import 'reachability_checker.dart';

final reachabilityCheckerProvider = Provider<ReachabilityChecker>(
  (ref) => const SocketReachabilityChecker(),
);

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(
    connectivity: Connectivity(),
    reachability: ref.watch(reachabilityCheckerProvider),
  ),
);

/// true = online. Tests override this with a plain `Stream<bool>`.
final onlineProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).online$,
);
