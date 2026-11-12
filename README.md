# J'Donuts — Flutter Code Test

A two-day implementation of the J'Donuts brief: registration and login,
an offline-first catalog, and an animated Rewards screen. It runs on Android
and the iOS Simulator. No backend setup or API keys are needed.

## Run the app

| Tool | Version |
| --- | --- |
| Flutter | 3.50.0 stable |
| Dart | 3.14.0 |

Flutter is pinned in `.fvmrc`. The app uses `material_ui` for Material widgets.

```bash
fvm install
fvm flutter pub get
fvm flutter run
```

Without FVM, use Flutter 3.50.0 and run `flutter pub get` followed by
`flutter run`. Android needs the Android SDK and an emulator or phone;
iOS needs macOS, Xcode and an installed Simulator runtime.

Generated Drift, freezed/json_serializable and localization files are
committed, so no code generation step is needed to run the project.

### Try the main flow

1. Choose **Let's get started**, enter a Myanmar mobile number, and use OTP
   **`123456`**. Complete Name and Date of birth, then open Home.
2. Open a product and change its quantity. Visit Reward to try the animations
   and Gift tab.
3. Log out from Settings, then log in with the same number and OTP. A returning
   user goes straight to Home; the session survives relaunch.
4. Turn on airplane mode and relaunch. Home, Product and Rewards should still
   render, including images. Reconnect to trigger a background refresh, or
   pull down on Home to refresh manually.

Any other six-digit OTP fails. Three wrong attempts lock that number until
**Resend**, available after the five-minute countdown. Going back does not
clear the lock. The fake repository waits about one second per request;
buttons show loading feedback and block repeated submissions.

Phone, OTP, name and date-of-birth validation are pure domain functions.
Names support Myanmar letters; last name is optional. Date of birth must be
a real date, not in the future, with a minimum age of 13.

To reset an Android installation, clear its app data. On iOS, log out first:
the session is stored in the Keychain and can survive reinstalling the app.

## Structure and state management

```text
lib/
  app/          Router, theme tokens, motion constants and shared widgets
  core/         Result/Failure, Drift database, catalog sync and connectivity
  features/
    auth/
    home/
    product/
    member/
    rewards/
    settings/
  l10n/         English ARB strings and generated localizations
```

Features use `presentation`, `application`, `domain` and `data` folders where
needed. Settings only needs presentation. Domain contains entities,
validators and repository interfaces, with no Flutter imports. Entities are
immutable `freezed` classes, with `json_serializable` for the ones read from
JSON. Data implements those interfaces; application providers connect them to
the UI.

I chose **Riverpod** for state management and dependency injection. The same
providers that supply repositories to screens can be overridden in tests.
Drift query streams feed `StreamProvider`, so database changes reach the UI
without keeping a second copy of the catalog in widget state.

Auth sits behind `AuthRepository`, including asynchronous sign-up code checks,
lockout, login and session restoration. The fake implementation persists users
and sessions through `flutter_secure_storage`. Auth and catalog operations
return typed `Result` values; database streams map failures to `StorageFailure`.
Data screens show loading, error/retry and empty states.

Navigation uses `go_router` with a session-based redirect guard. The short
`/product/:id` route forwards to `/home/product/:id`, keeping the product Hero
transition inside the Home navigator.

## Offline data

**Drift is the source of truth for Home, Product and Rewards.** On first launch,
`assets/seed/catalog.json` is imported into SQLite. The bundled catalog is the
fake remote source; there is no separate mock server.

- The source has a `{version, data}` envelope. Refresh applies newer or equal
  versions in a transaction, updates rows and removes entries the source
  dropped. An HTTP source can implement the same `CatalogSource` interface.
- Database migrations are incremental, from schema v1 to v4. A test opens a
  v3 database and checks the upgrade and preservation of member data.
- Seed images are bundled, so even a first launch without internet can show
  them. Network image URLs use `cached_network_image` with disk caching,
  placeholders and error states.
- Connectivity combines `connectivity_plus` with a reachability probe. Home
  shows an offline banner; reconnecting starts a background refresh.
- Home and Rewards read the same member record. The supplied designs disagree
  on the tier and points, so both screens use Silver, 680,000 points and
  500 points to Gold.

## Motion

Durations and curves live in `lib/app/motion/app_motion.dart`. Decorative
motion is shortened or skipped when Reduce Motion is enabled.

- **Onboarding and Welcome:** staggered text, buttons and food artwork.
- **Registration:** shared-axis transitions, an animated progress ring that
  becomes a check, OTP shake feedback, and press/loading button states.
- **Home and Product:** skeleton shimmer, section entrances, an auto-playing
  banner carousel, product Hero transitions, and animated quantity/total changes.
- **Rewards:** a CustomPainter points ring and count-up, staggered tier ladder
  with a progress line, sliding tab indicator, transitioning cards, donut/coffee
  progress artwork, Earn pulse and a badge entrance.
- **Navigation:** the active bottom-bar pill slides between tabs.

## Tests and checks

The latest recorded check passed **149 tests across 29 files**. The separate
device flow test also passed on an Android 14 emulator, an iPhone 16 Pro with
iOS 18.1 Simulator, and an Infinix X6840 phone.

```bash
fvm flutter analyze
fvm flutter test
fvm flutter devices
fvm flutter test integration_test/register_to_product_test.dart -d <device-id>
```

The tests cover validator boundaries, OTP lockout and resend, session/storage
failures, registration and logout recovery, catalog refresh/deletion, migration,
connectivity, routing, product totals, and Home/Rewards states and animations.
Rewards also has a 360×640 layout check at text scale 1.3.

`test/integration/register_to_product_test.dart` checks Register → Home →
Product in memory, including the Hero flight. The separate `integration_test/`
flow uses real secure storage, the database file and the fake request delays.
Run it on a test device: it clears the app's current session and registers a
new local account.

### Performance

The profile test measures Home scrolling, Product Hero transitions, Rewards
entrance and tab switching. Recorded on an **Infinix X6840** (MediaTek MT6769,
4 GB RAM, Android 16), with about 600 frames per full-flow run:

| Run | Build p99 | Raster p99 | Frames above the 16.7 ms budget |
| --- | --- | --- | --- |
| 1 | 9.4 ms | 13.2 ms | 2 build, 3 raster |
| 2 | 9.3 ms | 12.5 ms | 1 build |
| 3 | 9.0 ms | 11.8 ms | 2 build, 1 raster |

The first Rewards build took about 19–26 ms in these runs. Most measured frames
were within the 60 fps budget, but the first entrance still has a frame hitch.
These measurements cover the scripted interactions, not every screen or device.

```bash
fvm flutter drive --profile --no-dds --driver=test_driver/perf_driver.dart \
  --target=integration_test/performance_test.dart -d <device-id>
```

The report is written to `build/integration_response_data.json`. This test
records timings; it does not assert that every frame meets the budget.

## Build for review

```bash
fvm flutter build apk --release
fvm flutter build ios --simulator
```

The APK is at `build/app/outputs/flutter-apk/app-release.apk`. Install it with:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

Package the Simulator app from the project root:

```bash
cd build/ios/iphonesimulator
zip -r Runner.app.zip Runner.app
```

After extracting the ZIP, install it into a booted iOS Simulator with
`xcrun simctl install booted Runner.app`. This is a Simulator build, not an IPA
for a physical iPhone.

The submission requires the repository, release APK, Simulator ZIP and a
2–4 minute recording of registration, logout, login, Home, Product and Rewards,
followed by the same flow in airplane mode. Build files and the recording are
kept outside the source history.

## Trade-offs and remaining gaps

- **Scope:** cart and Earn actions provide visual feedback. Claimed rewards
  stay in memory and reset on relaunch. J'Donuts and Orders are placeholders,
  as allowed by the brief. Social login and legal links open placeholders.
- **Design assets:** the exact font and original artwork were not supplied.
  The app uses a system-font approximation and bundled stand-in images.
- **Tier progress:** the designs do not define the start of Silver. The member
  record stores `tierProgress` separately; 0.78 was chosen to match the ring.
- **Catalog:** JSON shape and types are checked, but numeric ranges are not.
  An empty challenges table triggers a startup repair read, so a deliberately
  empty catalog would repeat that read on each launch.
- **Connectivity:** a TCP connection to `1.1.1.1:53` is used as the probe. It does
  not prove an HTTP service is reachable or detect every captive portal.
- **Validation and layout:** names allow letters and spaces, so hyphenated names
  are rejected. Very narrow 320-pixel auth layouts can overflow. Layout checks
  do not cover every phone/text-size combination.
- **Not included:** Burmese localization, a persistent cart and CI. The first
  Rewards entrance hitch remains as described in Performance.

## Time spent

2 days.
