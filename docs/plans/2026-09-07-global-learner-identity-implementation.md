# Global Learner Identity Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Show the current learner's avatar, name, and configured grade range in the top-right of every primary screen and answer session.

**Architecture:** Create one non-interactive `_CurrentLearnerIdentity` widget in `main.dart`, backed by the current `LearnerProfile` and existing `AvatarPreview`. Pass the learner into the shared home shell and the already learner-aware practice/quiz launch pages; leave dialogs and full-screen figure previews unchanged.

**Tech Stack:** Flutter/Dart, existing `LearnerProfile`, `AvatarPreview`, Flutter widget tests.

### Task 1: Add a reusable current-learner identity widget

**Files:**
- Modify: `lib/main.dart:482-550, 1295-1360`
- Test: `test/widget_test.dart`

**Step 1: Write a failing widget test**

Add a focused test that pumps a primary home surface with a learner and expects a stable identity key, avatar preview, learner name, and localized grade-range label. Add a narrow viewport assertion that the identity text remains bounded.

**Step 2: Run it to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name "primary screens show current learner identity"`

Expected: FAIL because the identity widget/key does not exist.

**Step 3: Write minimal implementation**

Add a private non-clickable identity widget using `AvatarPreview` at 34px, one ellipsized name line, and one ellipsized grade-range line. Extend `_TopBar` and `_HomeShellFrame` to accept an optional learner and render the widget at the right without overflowing narrow screens.

**Step 4: Run it to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name "primary screens show current learner identity"`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "功能：顯示目前帳號識別"
```

### Task 2: Apply the identity to all answer sessions

**Files:**
- Modify: `lib/main.dart:3040-3120, 3644-3745, session launch call sites`
- Test: `test/widget_test.dart`

**Step 1: Write failing tests**

Add tests that launch a learner's general practice and quiz/formal-exam session and expect the identity key, avatar, name, and grade range in each AppBar. Ensure anonymous fallback sessions do not render it.

**Step 2: Run tests to verify they fail**

Run: `flutter test test/widget_test.dart --plain-name "answer sessions show current learner identity"`

Expected: FAIL because session pages do not receive/render a learner.

**Step 3: Write minimal implementation**

Add an optional learner parameter to `PracticeSessionPage` and `QuizSessionPage`. Thread the existing launch learner through `_openFirstEligiblePack` and use the shared identity widget in AppBar actions. Preserve all existing page actions, time controls, and session behavior.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/widget_test.dart --plain-name "answer sessions show current learner identity"`

Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "功能：答題頁顯示目前帳號"
```

### Task 3: Verify responsive coverage and document design

**Files:**
- Add: `docs/plans/2026-09-07-global-learner-identity-design.md`
- Add: `docs/plans/2026-09-07-global-learner-identity-implementation.md`
- Verify: `test/widget_test.dart`, `test/responsive_layout_test.dart`, full suite

**Step 1: Run focused coverage**

Run: `flutter test test/widget_test.dart test/responsive_layout_test.dart`

Expected: PASS.

**Step 2: Run full verification**

Run: `flutter test && flutter analyze && git diff --check`

Expected: tests pass; analyzer may retain only documented pre-existing informational warnings.

**Step 3: Commit documentation**

```bash
git add docs/plans/2026-09-07-global-learner-identity-design.md docs/plans/2026-09-07-global-learner-identity-implementation.md
git commit -m "文件：記錄全頁帳號識別設計"
```
