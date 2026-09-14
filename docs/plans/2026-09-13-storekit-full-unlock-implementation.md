# StoreKit Full Unlock Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add the one-time `com.benwu.mathspring.full_unlock` purchase, local StoreKit testing, purchase restoration, and immediate full-version entitlements.

**Architecture:** Keep the UI dependent on a testable entitlement service rather than StoreKit types. Provide an `in_app_purchase` adapter that observes and completes transactions, refreshes entitlement on startup, and exposes product/loading/error state. A local `Products.storekit` mirrors the production product ID so Xcode can perform zero-cost purchases on an attached device before App Store Connect is configured.

**Tech Stack:** Flutter/Dart, `in_app_purchase`, StoreKit 2 via the Flutter iOS platform adapter, Xcode StoreKit configuration, Flutter unit/widget tests.

### Task 1: Define product and entitlement domain API

**Files:**
- Modify: `lib/services/monetization_service.dart`
- Create: `test/monetization_service_test.dart`

**Step 1: Write failing tests**

Test the fixed product ID, initial loading/unavailable/purchasable states, the four entitlement benefits, and an in-memory service whose successful purchase and restore change entitlement without persisting a fake receipt.

**Step 2: Verify RED**

Run: `flutter test test/monetization_service_test.dart`

Expected: FAIL because product state, benefits and purchase operations do not exist.

**Step 3: Implement the minimal domain contract**

Add immutable `MonetizationState`, product metadata, error state, `purchaseFullUnlock`, `restorePurchases`, and a `ValueListenable`/listener mechanism. Preserve `NoopMonetizationService` as unavailable so no production UI can accidentally claim a purchase works.

**Step 4: Verify GREEN**

Run: `flutter test test/monetization_service_test.dart`

Expected: PASS.

### Task 2: Implement the StoreKit purchase adapter

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/services/monetization_service.dart`
- Create: `lib/services/storekit_monetization_service.dart`
- Create: `test/storekit_monetization_service_test.dart`

**Step 1: Write failing adapter tests**

Inject a narrow StoreKit gateway fake. Test loading only the declared product, verified purchase success, pending state, user cancellation, error propagation, transaction completion, restore success, and reloading an existing entitlement at launch.

**Step 2: Verify RED**

Run: `flutter test test/storekit_monetization_service_test.dart`

Expected: FAIL because adapter and gateway do not exist.

**Step 3: Add dependency and implementation**

Add `in_app_purchase`, implement a production gateway around `InAppPurchase.instance`, subscribe before requesting products, validate the expected product ID, complete pending completed transactions, and derive entitlement only from purchased/restored transactions. Wire service initialization into `MathSpringApp` startup with a safe unavailable fallback.

**Step 4: Verify GREEN**

Run: `flutter test test/monetization_service_test.dart test/storekit_monetization_service_test.dart`

Expected: PASS.

### Task 3: Gate learner count, avatar options, solutions and banner space

**Files:**
- Modify: `lib/data/local/app_services.dart`
- Modify: `lib/widgets/avatar_editor.dart`
- Modify: `lib/main.dart`
- Modify: `test/local_database_test.dart`
- Modify: `test/avatar_editor_test.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing tests**

Assert free accounts cannot create a second learner while full accounts can create up to five; premium-only avatar choices display a lock and route to paywall; solution steps route to paywall when not entitled; and the ad-host slot is absent when entitlement is true or during formal exams.

**Step 2: Verify RED**

Run: `flutter test test/local_database_test.dart test/avatar_editor_test.dart test/widget_test.dart`

Expected: FAIL because feature gates and paywall are absent.

**Step 3: Implement minimal gates and UI**

Pass entitlement state through the app shell. Add a localized paywall with product price, benefit list, purchase button, restore button, loading/pending/error states, and no button when StoreKit is unavailable. Gate the specified existing views without blocking questions, correctness, answers, exams, review, or free avatar defaults. Reserve banner layout through a single host abstraction only when a future real banner adapter is configured; this milestone does not show a placeholder ad.

**Step 4: Verify GREEN**

Run: `flutter test test/local_database_test.dart test/avatar_editor_test.dart test/widget_test.dart`

Expected: PASS.

### Task 4: Add local StoreKit product and testing handoff

**Files:**
- Create: `ios/Runner/Products.storekit`
- Modify: `ios/Runner.xcodeproj/project.pbxproj`
- Modify: `docs/monetization-handoff.md`
- Modify: `docs/site/privacy/index.html`
- Modify: `docs/app-store-metadata-zh-Hant.md`

**Step 1: Add local product configuration**

Create one non-consumable product, reference name `MathSpring Full Unlock`, identifier `com.benwu.mathspring.full_unlock`, and a local test price corresponding to US$1.99. Add it to the Runner project without making production privacy claims inaccurate.

**Step 2: Document exact local procedure**

Document opening `ios/Runner.xcworkspace`, selecting the Runner scheme’s StoreKit configuration, attaching an unlocked Developer Mode iPhone, and testing purchase, cancellation, repeated purchase, restore, and reset using Xcode’s StoreKit transaction manager. Separately document the App Store Connect sandbox prerequisites.

**Step 3: Verify configuration exists**

Run: `plutil -lint ios/Runner/Products.storekit`

Expected: valid property list / configuration content readable by Xcode.

### Task 5: Full verification and iPhone test build

**Files:** All above

**Step 1: Format and analyze**

Run: `dart format lib/services lib/data/local/app_services.dart lib/widgets/avatar_editor.dart lib/main.dart test && flutter analyze`

Expected: formatter makes no remaining changes and analyzer has no errors.

**Step 2: Run complete regression suite**

Run: `flutter test`

Expected: all tests pass.

**Step 3: Build and run local StoreKit verification**

Open `ios/Runner.xcworkspace` in Xcode, select `Products.storekit` in Runner > Run > Options, select the attached iPhone, and run the development build. Complete one test purchase and one restore; capture the entitlement state before and after each action.

**Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock ios lib test docs
git commit -m "feat: add StoreKit full unlock"
```
