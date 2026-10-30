# App Store Release Blockers Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove the repository-controlled blockers to MathSpring’s first App Store submission and publish its support and privacy pages.

**Architecture:** Keep the app offline-first. Deploy only `docs/site` through the existing GitHub Pages workflow; keep public claims consistent across the in-app purchase sheet, product-page drafts, and privacy policy. Treat App Store Connect, contracts, rights clearance, Sandbox, TestFlight, and physical-device checks as explicit manual gates with recorded evidence.

**Tech Stack:** Flutter/Dart, `flutter_test`, GitHub Actions Pages, StoreKit 2 via `in_app_purchase`, App Store Connect.

### Task 1: Enable Pages deployment for the release branch

**Files:**
- Modify: `.github/workflows/deploy-pages.yml:4-7`
- Test: GitHub Actions workflow run and public HTTP response

**Step 1: Extend the push branch allow-list**

Add `question-bank-expansion-2026-09` beside the existing release branches:

```yaml
branches:
  - main
  - question-bank-expansion-2026-08
  - question-bank-expansion-2026-09
```

**Step 2: Validate workflow syntax**

Run: `ruby -e 'require "yaml"; YAML.load_file(".github/workflows/deploy-pages.yml")'`

Expected: exit code 0.

**Step 3: Commit and push this branch**

Run: `git add .github/workflows/deploy-pages.yml && git commit -m "ci: deploy pages from release branch" && git push origin question-bank-expansion-2026-09`

Expected: a successful `Deploy GitHub Pages` workflow.

**Step 4: Verify public pages unauthenticated**

Run: `curl -sSIL https://benwu777.github.io/MathSpring/support/` and the corresponding privacy URL.

Expected: HTTP 200 for both.

### Task 2: Remove inaccurate advertising-removal claims

**Files:**
- Modify: `lib/main.dart:5277-5296`
- Modify: `ios/Runner/Products.storekit`
- Test: `test/public_links_test.dart` (extend) or a new focused copy test

**Step 1: Write a failing regression test**

Assert that user-visible unlock copy does not contain `無廣告`, `ad-free`, `移除廣告`, or `remove ads`, and retains the three real benefits: full solutions, avatar styles, and up to five learners.

**Step 2: Run the focused test**

Run: `flutter test test/public_links_test.dart`

Expected: FAIL because current localized strings contain the advertising claim.

**Step 3: Make the minimal copy-only change**

Change all localized unlock subtitle/description strings to the three genuine benefits. Remove the `hasAdFreeEntitlement` / `shouldShowBanner` abstraction only if it has no callers beyond its own file; retain no behavior that would imply a paid ad-removal feature.

**Step 4: Align StoreKit localization**

Change the local StoreKit product descriptions to match the same three benefits. This remains local test data; the equivalent information must later be entered in App Store Connect.

**Step 5: Verify**

Run: `flutter test test/public_links_test.dart test/storekit_monetization_service_test.dart`.

Expected: PASS.

### Task 3: Update release documentation and metadata drafts

**Files:**
- Modify: `docs/app-store-metadata-zh-Hant.md`
- Modify: `docs/app-store-metadata-en.md`
- Modify: `docs/app-store-release-checklist.md`
- Modify: `docs/site/privacy/index.html` only if copy no longer matches

**Step 1: Check all public release surfaces**

Run: `rg -n -i 'ad-free|無廣告|remove ads|移除廣告' docs/site docs/app-store-metadata-*.md lib ios/Runner/Products.storekit`

Expected: no product-benefit claim that advertising removal is included; the privacy policy may accurately state that the current release contains no ads.

**Step 2: Correct mismatched drafts**

Keep the metadata limited to offline practice, local records, no account, and the three IAP benefits. Do not claim a price in App Store copy because storefront price can differ by region.

**Step 3: Verify links and copy**

Run: `flutter test test/public_links_test.dart` plus the search in Step 1.

Expected: tests pass and no contradictory user-facing claim remains.

### Task 4: Verify and record build privacy requirements

**Files:**
- Create: `docs/app-store-privacy-manifest-verification.md`
- Inspect: generated iOS release archive and bundled `PrivacyInfo.xcprivacy` files

**Step 1: Build the unsigned release artifact**

Run: `flutter build ios --release --no-codesign`.

Expected: build succeeds.

**Step 2: Inspect privacy manifests**

List `PrivacyInfo.xcprivacy` in `build/ios/iphoneos/Runner.app` and its plug-in bundles, then inspect their XML/plist contents for collected data, tracking domains, and required-reason API declarations.

**Step 3: Record the results**

Document each bundle, its privacy manifest status, and any required action. If the app target itself uses Required Reason APIs, add `ios/Runner/PrivacyInfo.xcprivacy` with only Apple-approved, accurate reasons.

**Step 4: Verify**

Run the release build again after any manifest change. Expected: build succeeds.

### Task 5: Complete external App Store gates in order

**External systems:** Apple Developer portal, App Store Connect, TestFlight, Sandbox, physical devices

**Step 1: Legal and account gates**

Enroll in Apple Developer Program; accept Paid Apps Agreement; complete Tax and Banking; independently clear all question-bank and artwork distribution rights.

**Step 2: Store configuration**

Register `com.benwu.mathspring`, create the app record and `com.benwu.mathspring.full_unlock` non-consumable IAP, enter accurate metadata, privacy declaration, age rating, territories, and review contact.

**Step 3: Distribution verification**

Create a signed archive, answer Export Compliance, test Sandbox IAP and restore on a physical device, run TestFlight internal testing, and capture final iPhone/iPad screenshots.

**Step 4: Submit**

Attach the IAP to the version, select the processed build, provide review notes, and submit only when every checkbox in `docs/app-store-release-checklist.md` is evidenced.

