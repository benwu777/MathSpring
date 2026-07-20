# Branded Bilingual Home Screen Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first branded MathSpring home screen with a minimalist visual direction, adaptive layout, and Traditional Chinese / English support.

**Architecture:** Keep the app in a single Flutter entry file for this first slice, but replace the demo counter app with a small presentation layer made of reusable widgets. Add lightweight app localization support for `zh-Hant` and `en`, resolve the initial language from system locale, and expose a manual language switcher in the UI.

**Tech Stack:** Flutter, Material 3, widget tests, `flutter_localizations`

---

### Task 1: Replace demo test with product-facing widget tests

**Files:**
- Modify: `MathSpring/test/widget_test.dart`

**Step 1: Write the failing test**

Add tests that assert:

- English system locale shows `MathSpring`, `Train elegant mathematical thinking.`
- Traditional Chinese system locale shows `MathSpring`, `用更清楚的方式練習奧數思維`
- Tapping the language switch changes the UI language

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because the current app is still the demo counter.

**Step 3: Write minimal implementation**

Replace the demo app with a localized branded home screen and language switcher.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS

### Task 2: Implement the minimalist branded home screen

**Files:**
- Modify: `MathSpring/lib/main.dart`

**Step 1: Write the failing test**

Covered by Task 1 tests.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL until branded UI is implemented.

**Step 3: Write minimal implementation**

Implement:

- Deep-blue MathSpring theme
- Adaptive scaffold and content width handling
- Brand hero section with bilingual copy
- Learner profile cards
- Progress and question bank preview cards
- Language switch button for `繁中` and `EN`

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS

### Task 3: Update product docs

**Files:**
- Modify: `MathSpring/docs/initial-product-outline.md`
- Modify: `MathSpring/README.md`

**Step 1: Write the failing test**

No automated test needed; verify by direct file review.

**Step 2: Run verification**

Run: `sed -n '1,260p' docs/initial-product-outline.md`
Expected: visual direction and multilingual content strategy are documented.

**Step 3: Write minimal implementation**

Document:

- Minimalist visual direction
- Primary brand color
- Initial language policy
- Question content multilingual structure

**Step 4: Run verification**

Run: `sed -n '1,260p' docs/initial-product-outline.md`
Expected: updated content is present and coherent.
