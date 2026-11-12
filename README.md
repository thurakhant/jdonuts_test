# J'Donuts — Senior Flutter Code Test

A working slice of the J'Donuts customer app: fake login/registration with real
validation, an offline-first Home and Product detail, and an animated Rewards
screen.

## Deliverables

| Item | Where |
| ---- | ----- |
| Android release build | `app-release.apk` (attached to the submission email) |
| iOS Simulator build | `Runner.app.zip` (attached to the submission email) |
| Screen recording | Linked in the submission email: register, log out, log in, Home, Product detail, Rewards, then the same flow in airplane mode |

## Versions

| Tool    | Version                      |
| ------- | ---------------------------- |
| Flutter | 3.50.0 (stable, via **fvm**) |
| Dart    | 3.14.0                       |

> Flutter 3.50 deprecates `package:flutter/material.dart`; this project uses
> the official replacement `package:material_ui/material_ui.dart` throughout.

## Run it

```bash
fvm install            # picks up .fvmrc (3.50.0) — or use any Flutter 3.50.0
fvm flutter pub get
fvm flutter run        # on an iOS Simulator or Android emulator
```

Without fvm, plain `flutter pub get` / `flutter run` on Flutter 3.50.0 works
the same. No code generation step is needed — the Drift and l10n outputs are
committed. First launch imports `assets/seed/catalog.json` into the local
database; clear the app's data (or reinstall) to reset it.

Analysis and tests:

```bash
fvm flutter analyze    # clean, flutter_lints
fvm flutter test       # unit + widget + integration
```

Builds:

```bash
fvm flutter build apk --release
# -> build/app/outputs/flutter-apk/app-release.apk   (adb install app-release.apk)

fvm flutter build ios --simulator
cd build/ios/iphonesimulator && zip -r Runner.app.zip Runner.app
# unzip, then: xcrun simctl install booted Runner.app
```

## Fake OTP

**`123456`** is the only code that verifies; any other 6-digit code fails.
Three wrong codes lock entry until **Resend** (a 5:00 countdown, which Resend
restarts). Going back and re-entering the same number stays locked; only a
different number starts fresh.

## Architecture and folder map

Feature-first clean architecture, three layers per feature:

```
lib/
  app/                    # composition root
    router/               # go_router, auth redirect guard, /product/:id
    theme/                # ALL design tokens (colors, spacing, type)
    motion/app_motion.dart # ALL durations & curves as named constants
    widgets/              # shared widgets (LoadingButton, JdImage, skeletons…)
  core/                   # cross-feature plumbing
    result.dart, failure.dart   # typed Result / sealed Failures
    db/                   # Drift database (versioned migrations, schema v4)
    catalog/              # seed import + refresh pipeline (fake remote)
    connectivity/         # connectivity_plus + real reachability probe
    format/mmk.dart       # MMK thousands formatting
  features/
    auth | home | product | member | rewards | settings
      presentation/       # screens, widgets, Riverpod notifiers
      domain/             # pure Dart: entities, validators, repo interfaces
      data/               # repo implementations (fake auth, drift, storage)
  l10n/                   # ARB strings via gen-l10n
```

- **Presentation** depends on **domain**; **data** implements domain
  interfaces. The domain layer has no Flutter imports, and a test
  (`test/architecture/domain_purity_test.dart`) keeps it that way.
- Errors are typed `Failure`s returned in a `Result`; every screen and Home
  section has its own loading (skeleton), error (with Retry) and empty state.
- No services are created inside widgets: everything comes from Riverpod
  providers.

## State management: Riverpod

Riverpod alone covers both state and dependency injection. Provider overrides
make the fake `AuthRepository` and an in-memory database trivial to swap in
tests; `StreamProvider` watches Drift queries naturally for an offline-first
UI; wiring is compile-time with no context lookups. BLoC remains a fine choice
where event traceability matters — not needed at this size.

## Offline strategy

The UI reads **only the local Drift (SQLite) database** — the single source of
truth. The bundled seed (`assets/seed/catalog.json`, a versioned
`{version, data}` envelope) acts as the fake remote; there is no mock server.

1. **First launch:** the seed is imported into Drift and its version recorded.
2. **Refresh** (pull-to-refresh on Home, and automatically when connectivity
   returns): re-reads the source, upserts when the version is newer-or-equal,
   deletes rows the source dropped. A real HTTP source only needs to implement
   `CatalogSource` — nothing above the data layer changes.
3. **Migrations** are versioned and step-by-step (v1 → v4); a test opens a real
   v3 database and checks the upgrade.
4. **Connectivity** = `connectivity_plus` *and* a real reachability probe
   (socket to 1.1.1.1:53, 3 s timeout) behind an interface; Home shows an
   offline banner while offline. To try it: turn on airplane mode, relaunch
   the app — everything still renders from the database — then turn it off
   and watch the banner clear and a background refresh run.
5. **Images** are bundled as assets for all seed data (shown instantly in
   airplane mode); network URLs go through `cached_network_image` with a disk
   cache, placeholder and error state.
6. One **member record** is shared app-wide: Home's header and Rewards read
   the same Drift row (the design mock-ups disagree — Bronze/1,290 on Home,
   Silver/500 on Rewards — so both screens intentionally show the same stored
   record: Silver, 680,000 points, 500 to Gold).

## Validation (Task 1)

Pure-Dart validators in the domain layer, with unit tests for each rule:

- **Phone:** after `+95`, spaces/dashes and one leading `0` are stripped; the
  result must be `9` + 7–9 digits (`09254135592` → `+959254135592`).
- **OTP:** 6 digits; see [Fake OTP](#fake-otp).
- **Names:** first required, last optional (many Myanmar names have no family
  name); 1–50 chars after trimming; letters and spaces incl. Myanmar script;
  digits rejected (Myanmar digits too).
- **DOB:** real calendar date (no 31 April; 29 Feb only in leap years), not in
  the future, age ≥ 13 (`kMinimumAgeYears`).
- Every Continue shows a loading state for the ~1 s fake call; a double tap
  sends one request. Back returns to the previous step and keeps what was
  entered.

Sessions persist in `flutter_secure_storage`; relaunch while logged in opens
Home, logged out opens Onboarding; Log out lives in the Settings tab.

## Animations

All durations and curves are named constants in `lib/app/motion/app_motion.dart`.
`MediaQuery.disableAnimations` (Reduce Motion) shortens or skips decorative
motion throughout.

- **Registration:** the progress ring animates 25 → 50 → 75 → 100 % and morphs
  into a check; shared-axis step transitions; OTP boxes shake and clear on a
  wrong code; buttons scale on press and Continue morphs into its loading
  state.
- **Home:** skeleton shimmer (no spinners), staggered section entrance,
  auto-playing banner carousel.
- **Product:** Hero flight on the product image; quantity and total animate on
  change.
- **Rewards:**
  - the points ring (a CustomPainter frosting donut with sprinkles) sweeps from
    0 to the member's tier progress while the total counts up to 680,000;
  - Silver, Gold and Platinum appear in order, then the line to the next tier
    fills to the member's progress;
  - one blue pill slides between "Eat more earn more" and "Gift", and the card
    list changes with a slide-and-fade;
  - challenge cards enter staggered; the donut colours in by quarters
    (1/4, 4/4) and the coffee arc fills to 9/12;
  - EARN pulses when a challenge is complete (4/4), is grey otherwise, and
    shows press feedback; the "Rewards 3" badge pops in.
- **Navigation:** a floating bar whose pink pill slides between tabs;
  Onboarding and Welcome stagger their entrance.

## Tests

129 tests in 25 files, all passing, named after the behaviour they check:

- **Unit:** every validator rule, the fake auth repository (lockout, resend,
  sessions), catalog import/refresh, the v3 → v4 migration, connectivity,
  MMK formatting, and the domain-purity check.
- **Widget:** login and registration validation and flow, OTP boxes, session
  routing, Home states, Product detail, Rewards motion and states, including
  a 4.7-inch phone at text scale 1.3.
- **Integration:** `test/integration/register_to_product_test.dart` runs
  Register → Home → Product detail (with the Hero flight) through the real
  app, router and seed file.

## Known gaps and decisions

- **Integration test:** it runs with `flutter test` on in-memory stores, not
  on a device through `integration_test`, so the device run is shown in the
  recording instead.
- **Points ring progress:** the PDF says the ring sweeps to "the member's
  progress" but doesn't say where Silver starts, so progress can't be derived
  from 680,000 points and "500 to Gold". The member record stores
  `tierProgress` (0.78, chosen to match the design's ring); schema v4 adds the
  column.
- **Typeface:** the design's rounded display font isn't specified or
  provided; the system font with heavy weights approximates it.
- **Artwork:** original product, shop and badge art wasn't provided; the
  bundled images are stand-ins in the design's style.
- **Names:** "letters and spaces" is enforced literally, so hyphenated names
  (`Aung-Kyaw`) are rejected — a product question I'd raise.
- **Sign-up OTP:** the fake backend can't verify a code before the account
  exists, so register mode asks `AuthRepository.acceptsSignUpCode` with the
  same attempt/lockout rules, then registers and verifies at the DOB step.
- **Buttons with no logic:** Add to cart and Earn give visual feedback only.
  Earn also shows a CLAIMED state, kept in memory, so it resets on relaunch.
- **Placeholder tabs:** the J'Donuts tab (the middle doughnut icon; the PDF
  doesn't name it) and Orders are placeholder screens, as allowed.
- **Product route:** detail is nested under the Home tab
  (`/home/product/:id`) so the Hero flight stays inside one navigator; the
  PDF's `/product/:id` forwards there, and signed-out users still go to
  Onboarding.
- **Reachability:** the probe proves a socket to a public DNS server opens,
  not that a full HTTP request would succeed (e.g. behind a captive portal).
- **Screen sizes:** layouts are tested on 4.7- to 6.9-inch phones at text
  scale up to 1.3; smaller 4-inch screens can overflow on the auth steps.
- **Not done:** Burmese locale (bonus), persistent cart (bonus), CI.

## Time spent

TODO: about X hours over Y days.
