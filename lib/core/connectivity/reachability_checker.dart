import 'dart:io';

/// Answers "can this device actually reach the internet right now?".
/// Being on Wi-Fi is not enough (captive portals, dead routers), so the
/// connectivity service asks this too. Abstract so tests can fake it.
abstract interface class ReachabilityChecker {
  Future<bool> isReachable();
}

/// Opens a short-lived TCP connection to a well-known DNS server.
class SocketReachabilityChecker implements ReachabilityChecker {
  const SocketReachabilityChecker({
    this.host = '1.1.1.1',
    this.port = 53,
    this.timeout = const Duration(seconds: 3),
  });

  final String host;
  final int port;
  final Duration timeout;

  @override
  Future<bool> isReachable() async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      socket.destroy();
      return true;
    } on Object {
      return false;
    }
  }
}
