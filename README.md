# PoolVibe — v1

> Know exactly what to add, what to buy, and when your pool service is getting it wrong.

## What this is

PoolVibe is a pool-owner decision engine. It combines your pool profile, test values, maintenance reports, and symptom context to produce:

- exact chemical dosing guidance
- order of operations
- affiliate-linked product recommendations
- maintenance report oversight (catches underdosing and mismatch)

## v1 Scope (locked)

| Feature | Status |
|---------|--------|
| Pool profile setup (photos + guided questions) | 🔨 In progress |
| Gallon estimation with confidence note | 🔨 In progress |
| Test strip / report / symptom intake | 🔨 In progress |
| Exact action plan output | 🔨 In progress |
| Affiliate-linked product recommendations | 🔨 In progress |
| Maintenance report comparison | 🔨 In progress |
| Saved history log | 🔜 Next |

**Out of scope for v1:** community, social feed, messaging, contractor marketplace, payments, dashboards, financing, insurance. Do not add these without explicit approval.

---

## Tech Stack

| Layer | Choice | Reason |
|-------|--------|--------|
| Framework | Flutter 3.x | Cross-platform, fast iteration |
| State | Riverpod 2 | Scalable, testable |
| Navigation | go_router | Declarative, deep-link ready |
| Local storage | Hive + SharedPrefs | Offline-first pool profiles |
| HTTP | Dio | Future backend calls |
| Images | image_picker + cached_network_image | Photo upload + display |

---

## Project Structure

```
lib/
  main.dart                  # Entry point
  app.dart                   # App root, theme, router
  theme/
    app_theme.dart           # Colors, typography, spacing
  models/
    pool_profile.dart        # Pool data model
    pool_reading.dart        # Test strip values model
    maintenance_report.dart  # Report model
    recommendation.dart      # Action plan model
    affiliate_product.dart   # Product recommendation model
  screens/
    onboarding/              # Welcome + first-time setup
    profile/                 # Pool profile setup screens
    estimation/              # Gallon estimation flow
    intake/                  # Strip / report / symptom input
    recommendation/          # Action plan output
    affiliate/               # Product recommendations
    maintenance/             # Report comparison
    history/                 # Saved sessions
  services/
    gallon_estimator.dart    # Estimation logic
    recommendation_engine.dart # Dosing calculation logic
    affiliate_service.dart   # Product matching
    maintenance_checker.dart # Report comparison logic
  widgets/
    photo_upload_card.dart   # Reusable photo upload widget
    confidence_badge.dart    # Confidence level display
    chemical_card.dart       # Individual chemical recommendation
    step_progress.dart       # Onboarding step indicator
  utils/
    pool_math.dart           # Pool volume formulas
    chemical_math.dart       # Dosing calculations
    validators.dart
```

---

## Setup Instructions

### Prerequisites

- Flutter 3.32+ — [install](https://docs.flutter.dev/get-started/install)
- Dart 3.0+
- Android Studio or VS Code with Flutter plugin
- An Android device or emulator (iOS also supported)

### First-time setup

```bash
# 1. Clone the repo
git clone https://github.com/angel31700/poolvibe-v1.git
cd poolvibe-v1

# 2. Install dependencies
flutter pub get

# 3. Run on device/emulator
flutter run

# 4. Run tests
flutter test
```

### If you don't have Flutter installed

```bash
# macOS / Linux
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor

# Windows: download from https://docs.flutter.dev/get-started/install/windows
```

---

## Development Rules

1. Every PR must map to a GitHub issue in the v1 milestone
2. No feature outside the approved v1 scope gets merged without explicit approval
3. Branch naming: `feature/screen-name`, `fix/issue-number`, `chore/description`
4. Commit messages: `feat:`, `fix:`, `chore:`, `docs:`
5. Screenshots or short video required for any UI change PR

---

## Contacts

- Product owner: Angela
- GitHub: `angel31700/poolvibe-v1`
