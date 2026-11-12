# J'Donuts — Senior Flutter Code Test

A working slice of the J'Donuts customer app: fake login/registration with real
validation, an offline-first Home and Product detail, and an animated Rewards
screen.

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

Tests and analysis:

```bash
fvm flutter analyze    # clean, flutter_lints
fvm flutter test       # unit + widget + integration
```

**Fake OTP: `123456`** (every other code fails; 3 wrong codes lock entry until
Resend).

## Architecture

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
    db/                   # Drift database (versioned migrations)
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
  interfaces. The domain layer has no Flutter imports.
- **State management & DI: Riverpod** (alone). One tool covers both state and
  dependency injection; provider overrides make the fake `AuthRepository` and
  the in-memory database trivial to swap in tests; `StreamProvider` watches
  Drift queries naturally for offline-first UI; wiring is compile-time with no
  context lookups. BLoC remains a fine choice where event traceability matters
  — not needed at this size.

## Offline strategy

The UI reads **only the local Drift (SQLite) database** — the single source of
truth. The bundled seed (`assets/seed/catalog.json`, a versioned
`{version, data}` envelope) acts as the fake remote:

1. **First launch:** the seed is imported into Drift and its version recorded.
2. **Refresh** (pull-to-refresh, and automatically when connectivity returns):
   re-reads the source, upserts when the version is newer-or-equal, deletes
   rows the source dropped. A real HTTP source only needs to implement
   `CatalogSource` — nothing above the data layer changes.
3. **Connectivity** = `connectivity_plus` *and* a real reachability probe
   (socket to 1.1.1.1:53, 3 s timeout) behind an interface; Home shows an
   offline banner while offline.
4. **Images** are bundled as assets for all seed data (shown instantly in
   airplane mode); network URLs go through `cached_network_image` with a disk
   cache, placeholder and error state.
5. One **member record** is shared app-wide: Home's header and Rewards read
   the same Drift row (the design mock-ups disagree — Bronze/1,290 on Home,
   Silver/500 on Rewards — so both screens intentionally show the same stored
   record: Silver, 680,000 points, 500 to Gold).

## Validation (Task 1)

Pure-Dart validators in the domain layer, one unit test per rule:

- **Phone:** after `+95`, spaces/dashes and one leading `0` are stripped; the
  result must be `9` + 7–9 digits (`09254135592` → `+959254135592`).
- **OTP:** 6 digits; only `123456` verifies; 3 wrong codes lock until Resend
  (countdown from 5:00, Resend restarts it).
- **Names:** first required, last optional (many Myanmar names have no family
  name); 1–50 chars after trimming; letters and spaces incl. Myanmar script;
  digits rejected (Myanmar digits too).
- **DOB:** real calendar date (no 31 April; 29 Feb only in leap years), not in
  the future, age ≥ 13 (`kMinimumAgeYears`).
- Every Continue shows a loading state for the ~1 s fake call; a double tap
  sends one request.

Sessions persist in `flutter_secure_storage`; relaunch while logged in opens
Home, logged out opens Onboarding; Log out lives in the Settings tab.

## Animations

All durations and curves are named constants in `lib/app/motion/app_motion.dart`.
`MediaQuery.disableAnimations` (Reduce Motion) shortens or skips decorative
motion throughout.

- Registration: progress ring animates 25→50→75→100 % and morphs into a check;
  shared-axis step transitions; OTP boxes shake and clear on a wrong code;
  buttons scale on press and Continue morphs into its loading state.
- Home: skeleton shimmer (no spinners), staggered section entrance, auto-playing
  banner carousel.
- Product: hero flight on the product image; the quantity/total animate on
  change.
- Rewards: points ring sweeps while the total counts up to 680,000
  (CustomPainter), tier ladder staggers in with a filling progress line, tabs
  switch with a moving indicator, challenge cards enter staggered with
  quarter-donut and coffee-arc progress painters, badge pops in, and the bottom
  nav pill slides between Home and Reward.

## Known gaps / notes

- The design's exact typeface isn't specified; the system font with heavy
  weights approximates it.
- "Letters and spaces" is enforced literally, so hyphenated names
  (`Aung-Kyaw`) are rejected — a product question I'd raise.
- The fake backend can't verify an OTP before an account exists, so register
  mode checks the fake code in the flow controller with identical
  attempt/lockout semantics, then registers + verifies at the DOB step.
- Add to cart is visual feedback only (persistent cart listed as a bonus).
- The other three bottom-nav tabs are placeholders, as allowed.

## Time spent

~2 days part-time alongside planning notes. <!-- TODO(CoTe): replace with your real number before submitting -->
