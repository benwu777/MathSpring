# Solution Steps Auto-Scroll Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** When a learner reveals solution steps, smoothly scroll the first step into view in practice, quiz results, and session history.

**Architecture:** Keep the current in-place solution UI and entitlement rules. Extend the shared `_SolutionStepsGate` so it owns a stable anchor for its first visible solution step and, after a successful reveal, asks the nearest scrollable ancestor to bring that anchor into view over 300 ms. Because all three user journeys use this gate, behavior stays consistent without changing page navigation.

**Tech Stack:** Flutter/Dart, `Scrollable.ensureVisible`, `flutter_test` widget tests.

### Task 1: Add a failing reveal-and-scroll regression test

**Files:**
- Modify: `test/widget_test.dart`
- Modify: `lib/src/settings_tab.dart`

**Step 1: Write the failing test**

Add a practice-review widget test adjacent to `free practice review can spend a daily free solution`. Give the test a constrained phone-height surface, answer a question, scroll so the reveal button is visible but the future first solution step is below the viewport, tap `use_free_solution`, pump 300 ms, then assert the first solution-step finder is visible in the viewport.

**Step 2: Verify RED**

Run:

```sh
flutter test test/widget_test.dart --plain-name 'free practice reveal scrolls the first solution step into view'
```

Expected: failure because the step expands below the current viewport and no scroll command occurs.

**Step 3: Implement the minimum shared behavior**

In `_SolutionStepsGateState`, wrap `widget.steps` in a keyed anchor. After `unlockFreeSolution` completes and state refreshes, schedule `Scrollable.ensureVisible` for that anchor using `duration: Duration(milliseconds: 300)` and an appropriate alignment that places the first step near the top of the viewport. Do not scroll for an entitlement that already displays steps on first build.

**Step 4: Verify GREEN**

Run the command from Step 2. Expected: PASS.

**Step 5: Commit**

```sh
git add lib/src/settings_tab.dart test/widget_test.dart
git commit -m "feat: 捲動至剛展開的詳解"
```

### Task 2: Verify all shared surfaces

**Files:**
- Test: `test/widget_test.dart`

**Step 1: Add coverage for quiz and history**

Add focused tests that put the same shared gate inside `QuizResultPage` and `SessionDetailPage`, tap the free-solution button, and assert the first solution-step anchor is brought into the active `ContentScrollView` or `ListView` viewport.

**Step 2: Verify RED/GREEN for each surface**

Run the new focused tests before implementation only if a surface-specific adjustment is necessary. Keep the implementation inside the shared gate unless tests demonstrate a different scroll container needs an explicit controller.

**Step 3: Run focused verification**

```sh
flutter test test/widget_test.dart
flutter analyze
```

Expected: all widget tests pass and analyzer reports 0 issues.

**Step 4: Commit**

```sh
git add test/widget_test.dart lib/src/settings_tab.dart
git commit -m "test: 覆蓋詳解展開捲動流程"
```

### Task 3: Full release verification

**Files:**
- No production-file changes expected.

**Step 1: Run full checks**

```sh
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

**Step 2: Inspect the final diff**

```sh
git diff --check origin/develop...HEAD
git status --short
```

Expected: no whitespace errors and only the intended source/test/plan changes.

**Step 3: Push after verification**

Push the isolated branch and merge only after the verified result is reviewed.
