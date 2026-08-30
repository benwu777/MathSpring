# GitHub Pages Support and Privacy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Publish accurate MathSpring support and privacy pages through GitHub Pages, and point the app and App Store metadata to their real URLs.

**Architecture:** Static pages remain under `docs/site`; a GitHub Actions Pages workflow uploads that directory on pushes to the project branch. The Flutter settings screen derives its URLs from named constants so the deployed endpoints are single-source and testable.

**Tech Stack:** Flutter/Dart tests, static HTML/CSS, GitHub Actions Pages.

### Task 1: Add a failing public-link regression test

**Files:**
- Create: `test/public_links_test.dart`
- Test: `test/public_links_test.dart`

**Step 1: Write the failing test**

Add tests that read the app, support page, privacy page, and App Store metadata files. Assert the real GitHub Pages URLs, support email, and the four listed interface languages are present; assert no placeholder username or support email remains.

**Step 2: Run the test to verify it fails**

Run: `flutter test test/public_links_test.dart`

Expected: FAIL because the project still contains placeholder URLs and `support@example.com`.

### Task 2: Replace public-facing placeholders

**Files:**
- Modify: `lib/main.dart:1144-1154`
- Modify: `docs/site/index.html`
- Modify: `docs/site/support/index.html`
- Modify: `docs/site/privacy/index.html`
- Modify: `docs/app-store-metadata-en.md`
- Modify: `docs/app-store-metadata-zh-Hant.md`

**Step 1: Implement the smallest production changes**

Define `appSupportUrl` and `appPrivacyPolicyUrl` as top-level Dart constants with the `benwu777/MathSpring` GitHub Pages URLs and use them in Settings. Replace all public placeholder emails and URLs with `hidesor@yahoo.com.tw` and the production Pages paths. Update the support instructions to enumerate Traditional Chinese, Simplified Chinese, English, and Japanese.

**Step 2: Run the regression test**

Run: `flutter test test/public_links_test.dart`

Expected: PASS.

### Task 3: Configure GitHub Pages deployment

**Files:**
- Create: `.github/workflows/deploy-pages.yml`
- Modify: `test/public_links_test.dart`

**Step 1: Extend the failing test**

Assert that the workflow uploads `docs/site` and uses the official configure, upload-artifact, and deploy Pages actions.

**Step 2: Run the test to verify it fails**

Run: `flutter test test/public_links_test.dart`

Expected: FAIL because no deployment workflow exists.

**Step 3: Add the workflow**

Create a least-privilege GitHub Actions workflow, triggered by pushes to the active project branch and manual dispatch, that deploys `docs/site` through GitHub Pages.

**Step 4: Re-run the regression test**

Run: `flutter test test/public_links_test.dart`

Expected: PASS.

### Task 4: Verify and integrate

**Files:**
- Verify: `test/public_links_test.dart`
- Verify: all Flutter tests and static analysis

**Step 1: Run focused and full verification**

Run: `flutter test`, then `flutter analyze`.

Expected: tests pass; analysis has no errors.

**Step 2: Review change set and commit**

Run: `git diff --check`, inspect `git diff`, then commit the focused change with a Chinese message.

**Step 3: Merge into the current branch**

Fast-forward merge the feature branch into `question-bank-expansion-2026-08`, preserving the user's untracked `scripts/build_question_preview.py`.
