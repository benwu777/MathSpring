# Question Review Gating And Grade7-9 Audit Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add per-question review gating so practice/quiz only serve approved questions, and generate the first audit surface for grade 7-9 packs.

**Architecture:** Extend the `Question` schema with a review status field, defaulting to non-approved unless explicitly marked. Centralize launch-time filtering in `SessionLaunchPlanBuilder`, then create a grade 7-9 review audit document indexed by question id so later manual review can progress pack-by-pack without losing traceability.

**Tech Stack:** Flutter, Dart, JSON question packs, widget/unit tests

### Task 1: Lock the behavior with failing tests

**Files:**
- Modify: `test/session_launch_plan_test.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add tests that assert:
- launch question filtering drops `pending` / `needs_fix` questions
- only `reviewStatus = ok` survives into the launch pool
- grade 7-9 launch still works when approved questions exist

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`
Expected: FAIL because review status does not exist yet and launch code still serves every loaded question.

**Step 3: Write minimal implementation**

Add only the schema and launch filtering required to make the tests pass.

**Step 4: Run test to verify it passes**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`
Expected: PASS

### Task 2: Persist review status in the question schema

**Files:**
- Modify: `lib/models/question.dart`
- Modify: `lib/models/question_bank.dart` if needed

**Step 1: Write the failing test**

Extend tests to assert the parser preserves `reviewStatus`.

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart`
Expected: FAIL because parsed questions do not expose the new field.

**Step 3: Write minimal implementation**

Add `reviewStatus` to `Question` with safe parsing and a small helper like `isReviewApproved`.

**Step 4: Run test to verify it passes**

Run: `flutter test test/session_launch_plan_test.dart`
Expected: PASS

### Task 3: Gate practice/quiz launches by review status

**Files:**
- Modify: `lib/services/session_launch_plan_builder.dart`
- Modify: `lib/main.dart`

**Step 1: Write the failing test**

Cover launch-time behavior after pack load so unapproved questions never enter a session.

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`
Expected: FAIL because `mergedQuestions` currently includes all questions.

**Step 3: Write minimal implementation**

Add one filtering function and use it before randomization.

**Step 4: Run test to verify it passes**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`
Expected: PASS

### Task 4: Generate the grade 7-9 audit surface

**Files:**
- Create: `docs/question-review-grade7-9-audit.md`
- Modify: selected `assets/questions/...grade7...json`, `...grade8...json`, `...grade9...json` as needed

**Step 1: Generate an id-indexed audit list**

List every grade 7-9 question id with pack, topic, subtopic, source summary, figure kind, review status, and a blank review note field.

**Step 2: Seed explicit review status**

Ensure grade 7-9 question packs carry explicit `reviewStatus` values instead of implicit behavior.

**Step 3: Verify coherence**

Run a quick parse/test pass to confirm the edited JSON still loads.

### Task 5: Verify end-to-end

**Files:**
- Modify: any touched files above

**Step 1: Run focused tests**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`
Expected: PASS

**Step 2: Run broader content parser tests if relevant**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

**Step 3: Commit**

```bash
git add docs/plans/2026-08-02-question-review-gating-and-grade7-9-audit.md docs/question-review-grade7-9-audit.md test/session_launch_plan_test.dart test/widget_test.dart lib/models/question.dart lib/services/session_launch_plan_builder.dart lib/main.dart assets/questions
git commit -m "feat: gate launches by question review status"
```
