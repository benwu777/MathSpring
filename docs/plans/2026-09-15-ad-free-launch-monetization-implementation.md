# Ad-Free Launch Monetization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make MathSpring's first-release monetization consistently ad-free across the app, public pages, metadata, and release documentation.

**Architecture:** Preserve the existing one-time non-consumable StoreKit product and its restore flow. Change only release copy and release-gate documentation; do not add an ad SDK, tracking, analytics, or a new backend. A focused file-content regression test prevents ad-removal promises from returning to user-facing surfaces.

**Tech Stack:** Flutter/Dart, flutter_test, StoreKit via `in_app_purchase`, static GitHub Pages documents.

### Task 1: Lock the public offer with a failing regression test

**Files:**
- Modify: `test/public_links_test.dart`
- Test: `test/public_links_test.dart`

**Step 1: Write the failing test**

Add a test that reads `lib/main.dart`, both App Store metadata files, the support and privacy pages, and asserts that public launch copy does not contain `無廣告`, `移除廣告`, `ad-free`, or `remove ads`. It must also require the three paid benefits: full solutions, avatar styles, and five learner profiles.

**Step 2: Run test to verify it fails**

Run: `flutter test test/public_links_test.dart`

Expected: FAIL because the full-unlock UI currently promises ad-free learning.

**Step 3: Keep the test focused**

Do not test the StoreKit implementation here; `test/storekit_monetization_service_test.dart` already covers purchase and restore behavior.

### Task 2: Remove the ad-removal claim from shipped copy

**Files:**
- Modify: `lib/main.dart:4972-5010`
- Modify: `docs/app-store-metadata-en.md`
- Modify: `docs/app-store-metadata-zh-Hant.md`
- Modify: `docs/site/privacy/index.html`
- Test: `test/public_links_test.dart`

**Step 1: Update application localization**

Replace every localized full-unlock sentence that lists ad-free learning with a list of the remaining paid benefits. Retain the existing purchase and restore controls.

**Step 2: Update store and privacy copy**

Describe the one-time non-consumable product as full solutions, full avatar styles, and up to five learners. Keep the accurate statement that the current app contains no advertising, but do not frame ad absence as a purchase benefit.

**Step 3: Run focused regression test**

Run: `flutter test test/public_links_test.dart`

Expected: PASS.

### Task 3: Align internal launch records

**Files:**
- Modify: `docs/app-store-release-checklist.md`
- Modify: `docs/monetization-handoff.md`
- Modify: `docs/plans/2026-09-10-freemium-monetization-design.md`

**Step 1: Update the release model**

Remove advertising and ad-removal from the first-release entitlement. State that later advertising, if ever introduced, requires a separate product and privacy review rather than being implied by the launch IAP.

**Step 2: Preserve external gates**

Keep explicit unchecked gates for App Store Connect IAP creation, paid-app agreement and payment setup, Sandbox/TestFlight purchase tests, device QA, icon/screenshots, and public URL checks.

### Task 4: Verify release-copy and StoreKit regression coverage

**Files:**
- Test: `test/public_links_test.dart`
- Test: `test/storekit_monetization_service_test.dart`

**Step 1: Run focused tests**

Run: `flutter test test/public_links_test.dart test/storekit_monetization_service_test.dart`

Expected: PASS with no test failures.

**Step 2: Run analysis**

Run: `flutter analyze`

Expected: no issues.

**Step 3: Review changed files**

Run: `git diff --check && git diff -- lib/main.dart docs test/public_links_test.dart`

Expected: no whitespace errors and no remaining public ad-removal promises.
