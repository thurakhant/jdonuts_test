import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/connectivity/connectivity_service.dart';
import 'package:jdonuts_test/core/connectivity/reachability_checker.dart';

class _FakeConnectivity implements Connectivity {
  List<ConnectivityResult> links = [ConnectivityResult.wifi];
  final changes = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => links;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => changes.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeReachability implements ReachabilityChecker {
  bool reachable = true;

  @override
  Future<bool> isReachable() async => reachable;
}

void main() {
  late _FakeConnectivity link;
  late _FakeReachability probe;
  late ConnectivityService service;

  setUp(() {
    link = _FakeConnectivity();
    probe = _FakeReachability();
    service = ConnectivityService(connectivity: link, reachability: probe);
  });

  test('online needs a link AND a successful probe', () async {
    final seen = <bool>[];
    final sub = service.online$.listen(seen.add);
    await pumpEventQueue();
    expect(seen, [true]);

    probe.reachable = false; // wifi but no internet (captive portal)
    link.changes.add([ConnectivityResult.wifi]);
    await pumpEventQueue();
    expect(seen, [true, false]);

    probe.reachable = true;
    link.changes.add([ConnectivityResult.wifi]);
    await pumpEventQueue();
    expect(seen, [true, false, true]);

    link.links = [ConnectivityResult.none];
    link.changes.add([ConnectivityResult.none]);
    await pumpEventQueue();
    expect(seen.last, isFalse);
    await sub.cancel();
  });

  test('only emits when the value changes', () async {
    final seen = <bool>[];
    final sub = service.online$.listen(seen.add);
    await pumpEventQueue();
    link.changes.add([ConnectivityResult.wifi]);
    link.changes.add([ConnectivityResult.mobile]);
    await pumpEventQueue();
    expect(seen, [true]);
    await sub.cancel();
  });
}
