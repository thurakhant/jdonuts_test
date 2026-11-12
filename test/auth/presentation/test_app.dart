import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/app/app.dart';
import 'package:jdonuts_test/features/auth/application/auth_providers.dart';
import 'package:jdonuts_test/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts_test/features/auth/data/in_memory_stores.dart';
import 'package:jdonuts_test/features/auth/domain/auth_user.dart';

final testUser = AuthUser(
  id: 'user-959254135592',
  phone: '+959254135592',
  firstName: 'Mya',
  lastName: 'Aye',
  dateOfBirth: DateTime(1990, 5, 1),
);

/// Boots the whole app on in-memory stores with a zero-latency fake backend.
Future<InMemorySessionStore> pumpApp(
  WidgetTester tester, {
  bool signedIn = false,
  bool userRegistered = true,
}) async {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  final sessions = InMemorySessionStore();
  final users = InMemoryUserStore();
  if (userRegistered) await users.writeAll([testUser]);
  if (signedIn) await sessions.write(AuthSession.fromUser(testUser));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionStoreProvider.overrideWithValue(sessions),
        userStoreProvider.overrideWithValue(users),
        authRepositoryProvider.overrideWith(
          (ref) => FakeAuthRepository(
            sessionStore: sessions,
            userStore: users,
            delay: Duration.zero,
          ),
        ),
      ],
      child: const JDonutsApp(),
    ),
  );
  await tester.pumpAndSettle();
  return sessions;
}

Future<void> tapLink(WidgetTester tester, String text) async {
  await tester.tapOnText(find.textRange.ofSubstring(text));
  await tester.pumpAndSettle();
}

Future<void> tapButton(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(ElevatedButton, label));
  await tester.pumpAndSettle();
}

/// Onboarding -> phone screen with [phone] typed in.
Future<void> startFlow(
  WidgetTester tester, {
  required bool login,
  String phone = '9254135592',
}) async {
  if (login) {
    await tapLink(tester, 'Log In');
  } else {
    await tapButton(tester, "LET'S GET STARTED");
  }
  await tester.enterText(find.byType(TextField), phone);
  await tester.pump();
}
