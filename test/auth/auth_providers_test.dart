import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/auth/application/auth_providers.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';

void main() {
  test('current session is null when nothing is stored', () async {
    final container = ProviderContainer(
      overrides: [
        sessionStoreProvider.overrideWithValue(InMemorySessionStore()),
        userStoreProvider.overrideWithValue(InMemoryUserStore()),
      ],
    );
    addTearDown(container.dispose);
    expect(await container.read(currentSessionProvider.future), isNull);
    expect(container.read(authRepositoryProvider), isA<FakeAuthRepository>());
  });
}
