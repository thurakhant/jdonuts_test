import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'reachability_checker.dart';

/// Online = the OS reports a network link AND the reachability probe
/// succeeds. [online$] emits the current value first, then only changes.
class ConnectivityService {
  ConnectivityService({
    required this.connectivity,
    required this.reachability,
    this.recheckEvery = const Duration(seconds: 20),
  });

  final Connectivity connectivity;
  final ReachabilityChecker reachability;

  /// Re-probes on this interval so a link that comes back without an OS event
  /// is still noticed.
  final Duration recheckEvery;

  Stream<bool> get online$ {
    late final StreamController<bool> controller;
    StreamSubscription<List<ConnectivityResult>>? linkSub;
    Timer? timer;
    bool? last;

    Future<void> check() async {
      final online = await _isOnline();
      if (controller.isClosed || online == last) return;
      last = online;
      controller.add(online);
    }

    controller = StreamController<bool>(
      onListen: () {
        check();
        linkSub = connectivity.onConnectivityChanged.listen(
          (_) => check(),
          onError: (_) {},
        );
        timer = Timer.periodic(recheckEvery, (_) => check());
      },
      onCancel: () {
        timer?.cancel();
        return linkSub?.cancel();
      },
    );
    return controller.stream;
  }

  Future<bool> _isOnline() async {
    try {
      final links = await connectivity.checkConnectivity();
      if (links.every((l) => l == ConnectivityResult.none)) return false;
    } on Object {
      // Plugin unavailable (tests, unsupported platform): let the probe decide.
    }
    return reachability.isReachable();
  }
}
