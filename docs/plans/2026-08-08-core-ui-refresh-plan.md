# Core UI Refresh Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refresh the home, question, and settings surfaces so MathSpring feels closer to a modern learning app: lighter, sharper, calmer, and more premium.

**Architecture:** Centralize the new visual direction in shared theme tokens and shared surface widgets, then apply those tokens consistently to the home tabs, settings/profile surfaces, and practice/quiz question cards. Keep navigation and flows unchanged while tightening hierarchy, spacing, and card treatment.

**Tech Stack:** Flutter, Material 3, widget tests

### Task 1: Add regression coverage for refreshed visual tokens

**Files:**
- Modify: `test/widget_test.dart`
- Modify: `lib/main.dart`

**Step 1: Write the failing test**

Add widget assertions for:
- updated scaffold/background tone
- updated navigation bar/card styling tokens
- refreshed section/header card typography scale

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name 'core surfaces use refreshed visual tokens'`

Expected: FAIL on old colors/spacing/typography values.

**Step 3: Write minimal implementation**

Update shared theme and shared card/surface components in `lib/main.dart`.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name 'core surfaces use refreshed visual tokens'`

Expected: PASS

### Task 2: Refresh home and settings shell surfaces

**Files:**
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart`

**Step 1: Write the failing test**

Add coverage that the home shell still renders but now exposes the refreshed presentation primitives:
- top bar
- learner banner
- section card
- profile tile

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name 'home shell applies refreshed cards and profile styling'`

Expected: FAIL because old containers/styles remain.

**Step 3: Write minimal implementation**

Apply the new direction to:
- `_HomeShellFrame`
- `_TopBar`
- `_SectionCard`
- `_LearnerSummaryBanner`
- `_LearnerProfilesSection`
- `_ProfileTile`
- `_LocaleSettingsSection`
- `_ProgressSection`

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name 'home shell applies refreshed cards and profile styling'`

Expected: PASS

### Task 3: Refresh practice and quiz question pages

**Files:**
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart`

**Step 1: Write the failing test**

Add coverage that practice/quiz question pages render the refreshed question chrome:
- compact header row
- elevated white question card
- clearer answer/review separation

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name 'question pages use refreshed study card styling'`

Expected: FAIL because old card/surface structure remains.

**Step 3: Write minimal implementation**

Apply the new direction to:
- practice page outer spacing/header
- quiz page outer spacing/header
- question/review cards and info blocks

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name 'question pages use refreshed study card styling'`

Expected: PASS

### Task 4: Run full widget verification

**Files:**
- None

**Step 1: Run verification**

Run: `flutter test test/widget_test.dart`

Expected: PASS
