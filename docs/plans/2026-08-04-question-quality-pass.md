# Question Quality Pass Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Improve visible question quality first by standardizing math expression rendering, tightening figure/layout presentation, and strengthening review/duplicate tooling before further source pedigree cleanup.

**Architecture:** Keep bundled question JSON as the source of truth, but add a render-time math text formatter so existing content improves immediately without a bulk rewrite. Pair that with figure painter/layout fixes in the Flutter UI and a stricter audit pass for review docs/tooling so only reviewed content keeps moving forward.

**Tech Stack:** Flutter, Dart, Flutter widget tests, existing bundled JSON packs, existing duplicate audit service.

### Task 1: Lock math-style rendering with tests

**Files:**
- Create: `test/math_text_formatter_test.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing unit tests**

- Add tests for `x^2`, `(7.2)^x`, `3^15`, `a^2r`, and `<=` / `>=` normalization.
- Add a widget test proving a practice question renders `x²` instead of `x^2`.

**Step 2: Run targeted tests to verify failure**

Run: `flutter test test/math_text_formatter_test.dart test/widget_test.dart`

Expected: formatter tests fail because no formatter exists yet and widget output still contains caret notation.

### Task 2: Implement render-time math normalization

**Files:**
- Create: `lib/services/math_text_formatter.dart`
- Modify: `lib/main.dart`
- Test: `test/math_text_formatter_test.dart`

**Step 1: Write minimal formatter**

- Add a small formatter that converts programmer-style math text into student-facing text:
  - superscripts for common exponent notation
  - `<=` → `≤`
  - `>=` → `≥`
  - preserve already-correct Unicode math

**Step 2: Wire formatter into question text widgets**

- Update prompt/body/option widgets to render normalized text consistently.

**Step 3: Re-run targeted tests**

Run: `flutter test test/math_text_formatter_test.dart test/widget_test.dart`

Expected: new formatter tests pass and widget text no longer shows raw caret notation.

### Task 3: Tighten figure and answer-review presentation

**Files:**
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart`
- Test: `test/geometry_scene_test.dart`

**Step 1: Write failing widget coverage**

- Add/extend tests for:
  - practice review card still showing figure + answer + solution after submit
  - geometry labels staying visible inside the figure frame
  - long question panels remaining scroll-friendly

**Step 2: Implement minimal UI/painter fixes**

- Clamp geometry labels away from figure edges.
- Slightly improve question/figure spacing and figure container behavior.
- Keep review content readable and visually ordered after submission.

**Step 3: Re-run targeted tests**

Run: `flutter test test/widget_test.dart test/geometry_scene_test.dart`

Expected: all figure/layout tests pass.

### Task 4: Update review rules and audit tooling

**Files:**
- Modify: `docs/question-bank-expansion-guidelines.md`
- Modify: `docs/AGENT_PROMPT_question_bank.md`
- Modify: `docs/question-bank-handoff-2026-08-02.md`
- Modify: `lib/services/question_bank_duplicate_audit.dart`
- Modify: `test/question_bank_test.dart`

**Step 1: Update rules docs**

- Remove “official-first” from the highest-priority rejection rule.
- Keep the ban on low-quality originals, template weak variants, bad math notation, bad figures, and unreviewed questions.

**Step 2: Strengthen duplicate/review heuristics**

- Improve duplicate audit heuristics so formula-normalized prompts do not slip through as fake uniqueness.
- Add tests covering the new heuristic.

**Step 3: Re-run targeted tests**

Run: `flutter test test/question_bank_test.dart`

Expected: docs/tests reflect the new priority ordering and duplicate audit remains green.

### Task 5: Full verification

**Files:**
- No new files

**Step 1: Run focused suite**

Run: `flutter test test/math_text_formatter_test.dart test/widget_test.dart test/geometry_scene_test.dart test/question_bank_test.dart`

Expected: all pass.

**Step 2: Run broader regression suite**

Run: `flutter test`

Expected: full suite green with no new warnings.
