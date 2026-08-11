# Learner Grade Range And Typography Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace learner competition-profile selection with a 1-12 dual-slider grade range and tighten the app's typography/layout rhythm so profile cards and major content blocks read cleanly without awkward wrapping.

**Architecture:** Extend `LearnerProfile` from a single representative grade to a persisted min/max grade range, then make session pack selection filter by that range. Update settings and learner forms to edit the range directly, and consolidate sizing/spacing tokens in `main.dart` so cards, labels, values, inputs, and buttons use a consistent medium-density layout.

**Tech Stack:** Flutter, Dart, sqflite, widget tests

### Task 1: Capture the new learner range behavior in tests

**Files:**
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add widget tests that assert:
- settings/profile UI shows grade range text instead of competition profile text
- create/edit learner flow shows a `RangeSlider`
- moving the slider updates the displayed range summary

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because current UI still shows competition profile labels and has no range slider.

**Step 3: Write minimal implementation**

Implement only enough learner UI/model wiring to surface the range selector and range summary.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS for the new learner range expectations.

### Task 2: Capture launch filtering behavior in tests

**Files:**
- Modify: `test/widget_test.dart`
- Test: `lib/services/session_launch_plan_builder.dart`

**Step 1: Write the failing test**

Add tests that assert:
- learner range `grade3` to `grade6` can select packs from grades 3, 4, 5, 6
- grades outside the learner range are excluded
- launch pack summary reflects the active range cleanly

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because launch filtering still uses the old grouped competition-profile logic.

**Step 3: Write minimal implementation**

Replace grouped-profile filtering with inclusive range filtering.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS for the launch filtering cases.

### Task 3: Capture typography/layout cleanup in tests

**Files:**
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add widget assertions for the settings/profile area that verify:
- label text uses a smaller style than value text
- learner cards reserve enough horizontal space to avoid short-value wrapping in standard phone width
- key buttons/inputs use consistent height constraints

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because current card layout and text styles do not enforce the new rhythm.

**Step 3: Write minimal implementation**

Introduce shared style constants and update the affected cards/forms.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS for the typography/layout expectations.

### Task 4: Persist the learner range safely

**Files:**
- Modify: `lib/models/learner_profile.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Modify: `lib/data/local/app_services.dart`
- Modify: `lib/data/local/learner_profile_repository.dart`

**Step 1: Write the failing test**

Extend tests so learner profiles round-trip min/max grade values.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because the model/database schema do not store a range yet.

**Step 3: Write minimal implementation**

Add `minLevelStage` / `maxLevelStage` storage, compatibility fallback for older rows, and seed data updates.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS with persisted learner ranges.

### Task 5: Verify the whole app behavior

**Files:**
- Modify: `lib/main.dart`
- Modify: any touched tests/docs as needed

**Step 1: Run focused tests**

Run: `flutter test test/widget_test.dart`
Expected: PASS

**Step 2: Run analyzer**

Run: `flutter analyze`
Expected: PASS with no new issues

**Step 3: Commit**

```bash
git add docs/plans/2026-08-02-learner-grade-range-and-typography.md test/widget_test.dart lib/models/learner_profile.dart lib/data/local/mathspring_database.dart lib/data/local/app_services.dart lib/data/local/learner_profile_repository.dart lib/services/session_launch_plan_builder.dart lib/main.dart
git commit -m "feat: add learner grade range settings"
```
