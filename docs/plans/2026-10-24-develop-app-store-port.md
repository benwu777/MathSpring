# Develop App Store Readiness Port Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Port only the App Store readiness work that remains valid into the current modular `develop` architecture, without restoring the obsolete monolithic app shell or replacing newer question-bank data.

**Architecture:** Start from clean `develop` in an isolated integration branch. Apply documentation and StoreKit changes directly; locate equivalent user-visible purchase copy in the modular source before changing it. Keep `develop`’s question packs, manifest counts, and UI modules authoritative.

**Tech Stack:** Flutter/Dart, `flutter_test`, StoreKit local configuration, GitHub Pages, App Store Connect documentation.

### Task 1: Port documentation only

**Files:**
- Create: `docs/app-store-privacy-manifest-verification.md`
- Modify: `docs/app-store-release-checklist.md`
- Create: `docs/plans/2026-10-24-app-store-release-blockers.md` only if it does not duplicate newer develop planning

**Step 1: Compare release documentation**

Run: `git diff develop..question-bank-expansion-2026-09 -- docs/`

Expected: identify Pages verification, privacy-manifest evidence, and unfulfilled external App Store gates without importing stale product assumptions.

**Step 2: Apply the current facts**

Retain develop’s current monetization policy, add the manifest verification record, and mark only verified items as complete: public support/privacy URLs, `flutter analyze`, and the full test suite.

**Step 3: Verify Markdown and links**

Run: `rg -n '<<<<<<<|=======|>>>>>>>' docs/` and `curl -sSIL` for public support/privacy URLs.

Expected: no conflict markers; both URLs return HTTP 200.

### Task 2: Align the local StoreKit product

**Files:**
- Modify: `ios/Runner/Products.storekit`
- Test: existing StoreKit monetization tests

**Step 1: Write a failing copy regression test**

Extend the release-copy test so the local StoreKit product cannot claim `ad-free`, `無廣告`, `移除廣告`, or equivalent advertising removal unless an actual advertising feature exists.

**Step 2: Run the focused test**

Run: `flutter test test/public_links_test.dart test/storekit_monetization_service_test.dart`

Expected: FAIL if the current local product copy retains an inaccurate advertising-removal benefit.

**Step 3: Update StoreKit descriptions**

List only the real one-time unlock benefits present in develop’s app: full solutions, full avatar styles, and up to five learner profiles, subject to source inspection.

**Step 4: Re-run focused tests**

Run the command from Step 2. Expected: PASS.

### Task 3: Align modular UI purchase copy

**Files:**
- Modify: exact module(s) located by `rg -n -i 'ad-free|無廣告|移除廣告|full unlock' lib/`
- Test: affected widget and release-copy tests

**Step 1: Locate current purchase surfaces**

Run: `rg -n -i 'ad-free|無廣告|移除廣告|full unlock' lib/`.

**Step 2: Add or extend a failing widget test**

Assert that the modular settings/purchase surface describes only actual unlock benefits and that free hair-colour choices remain available.

**Step 3: Implement the smallest copy-only change**

Do not move UI architecture or change entitlement behavior.

**Step 4: Verify**

Run the focused widget test plus `flutter analyze`.

### Task 4: Release verification and integration

**Files:**
- Modify: `docs/app-store-release-checklist.md` only for freshly verified results

**Step 1: Run full verification**

Run: `flutter analyze && flutter test && flutter build ios --release --no-codesign`.

Expected: analyzer clean, all tests pass, and release artifact is generated.

**Step 2: Inspect privacy manifests**

Run: `find build/ios/iphoneos/Runner.app -name PrivacyInfo.xcprivacy -print` and inspect each plist. Update the verification record only with observed facts.

**Step 3: Commit and push integration branch**

Commit each coherent task separately, then merge or push the verified integration branch to `develop` after confirming the target worktree’s existing local edits are not overwritten.
