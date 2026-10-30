# Cute Otter UI Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make MathSpring's practice, answer feedback, and learning review flows feel more polished and friendly with a consistent static otter companion.

**Architecture:** Keep the application’s existing Material 3 theme and introduce a small code-native `OtterCompanion` widget in `lib/widgets`. It uses Flutter `CustomPainter` primitives rather than bitmap assets so it stays sharp at all sizes and can expose named poses. Wire it into the existing hero, practice review, and review header components, while refining shared visual tokens and navigation states.

**Tech Stack:** Flutter, Material 3, `flutter_test`.

### Task 1: Add the reusable otter companion

**Files:**
- Create: `lib/widgets/otter_companion.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add a widget test that pumps `OtterCompanion(pose: OtterPose.celebrating)` and expects the stable `otter_companion_celebrating` key and a `CustomPaint` descendant.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name 'otter companion'`
Expected: FAIL because the widget does not exist.

**Step 3: Write minimal implementation**

Create an enum with `welcoming`, `thinking`, `celebrating`, and `reflecting` poses. Implement a semantic wrapper, `SizedBox`, and a `CustomPaint` that draws a round brown otter, pale muzzle, eyes, paws, and pose-specific small prop/accent.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name 'otter companion'`
Expected: PASS.

### Task 2: Polish shared surfaces and main navigation

**Files:**
- Modify: `lib/main.dart:38-390`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Assert the new warm accent and positive-feedback tokens are stable, and that the practice navigation destination has a selected icon with the expected companion-friendly visual treatment.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name 'visual tokens'`
Expected: FAIL for the new token assertions.

**Step 3: Implement the shared visual treatment**

Add warm oat and peach accents to `AppVisualTokens`; gently increase card and button rounding; make selected navigation icons filled variants while preserving labels and all existing keys.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name 'visual tokens'`
Expected: PASS.

### Task 3: Apply companion states to the three learning flows

**Files:**
- Modify: `lib/main.dart:974-1130, 1841-2140, 3523-3900, 6800-6860`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing tests**

Add tests that assert: the home hero exposes `otter_companion_welcoming`; review exposes `otter_companion_reflecting`; and a correct submitted practice answer exposes `otter_companion_celebrating`.

**Step 2: Run tests to verify they fail**

Run: `flutter test test/widget_test.dart --plain-name 'otter'`
Expected: FAIL because the page integrations do not exist.

**Step 3: Implement integrations**

Place the welcoming pose in the hero panel; add a compact reflecting pose to the review banner; include a celebrating or thinking pose in `_PracticeReviewCard` according to answer correctness. Update compact banner layout to tolerate an optional trailing visual on compact and wide widths.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/widget_test.dart --plain-name 'otter'`
Expected: PASS.

### Task 4: Format and verify responsive behavior

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/widgets/otter_companion.dart`
- Modify: `test/widget_test.dart`

**Step 1: Format**

Run: `dart format lib/main.dart lib/widgets/otter_companion.dart test/widget_test.dart`

**Step 2: Verify focused UI tests**

Run: `flutter test test/widget_test.dart test/responsive_layout_test.dart`
Expected: PASS, except the documented pre-existing avatar-layering failures are outside this command.

**Step 3: Verify full suite for regression visibility**

Run: `flutter test`
Expected: existing failures remain limited to `test/avatar_layering_test.dart`; no newly introduced failure.
