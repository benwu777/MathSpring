# Quiz Result Summary Layout Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Keep quiz-result information readable on a 390×700 phone viewport without a vertical layout overflow.

**Architecture:** Replace the two equal-weight statistic cards in `QuizResultPage` with a result-focused summary: one prominent correct-count or score, its label, and elapsed time as a compact secondary line. Let the complete result page use its natural scroll height: the existing full-height `Expanded` layout can compress the summary below its own header when a small phone also has a result record.

**Tech Stack:** Flutter, Material widgets, `flutter_test`.

### Task 1: Capture the small-phone overflow as a regression test

**Files:**
- Modify: `test/widget_test.dart` near the existing `QuizResultPage` tests
- Test: `test/widget_test.dart`

**Step 1: Write the failing test**

Add a widget test that sets the test surface to `Size(390, 700)`, pumps an English `QuizResultPage` with one answer record and a non-zero elapsed duration, and asserts that the prominent score, the elapsed label/value, and no framework exception are present.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name "quiz result summary fits on a phone"`

Expected: FAIL because the current two-card stat row overflows vertically at this viewport.

### Task 2: Make the summary hierarchy compact and result-focused

**Files:**
- Modify: `lib/src/quiz_session.dart:673-725`
- Test: `test/widget_test.dart`

**Step 1: Write minimal implementation**

Replace `_StatRow` only in `QuizResultPage` with a local column containing:

```dart
Text(resultValue, style: prominent score style)
Text(resultLabel)
const SizedBox(height: 12)
Text('${strings.elapsedLabel}: ${_formatElapsed(result.elapsed)}')
```

Use the existing visual tokens and responsive text scaling; remove the result page's `ContentScrollView(fill: true)` / `Expanded` combination so the summary card receives its natural height. Do not change `_StatRow`, which is private to learner profiles and used by other pages.

**Step 2: Run the regression test to verify it passes**

Run: `flutter test test/widget_test.dart --plain-name "quiz result summary fits on a phone"`

Expected: PASS with no `RenderFlex overflowed` exception.

### Task 3: Verify the affected UI suite and static analysis

**Files:**
- Verify only: `test/widget_test.dart`, `lib/src/quiz_session.dart`

**Step 1: Run widget tests**

Run: `flutter test test/widget_test.dart`

Expected: all widget tests pass.

**Step 2: Run static analysis**

Run: `flutter analyze`

Expected: no diagnostics.

### Task 4: Commit and integrate

**Files:**
- Modify: `docs/plans/2026-10-28-quiz-result-summary-layout.md`
- Modify: `lib/src/quiz_session.dart`
- Modify: `test/widget_test.dart`

**Step 1: Review the focused diff**

Run: `git diff --check` and `git diff -- lib/src/quiz_session.dart test/widget_test.dart docs/plans/2026-10-28-quiz-result-summary-layout.md`

Expected: only the compact quiz summary, its regression coverage, and this plan.

**Step 2: Commit the verified change**

Run:

```bash
git add lib/src/quiz_session.dart test/widget_test.dart docs/plans/2026-10-28-quiz-result-summary-layout.md
git commit -m "fix: avoid quiz result summary overflow"
```

**Step 3: Push the verified commit to `develop`**

After confirming `origin/develop` has not advanced, fast-forward `develop` and push it. If it has advanced, stop and rebase or ask before resolving conflicts.
