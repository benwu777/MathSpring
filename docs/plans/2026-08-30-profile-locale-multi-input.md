# Profile Safety, Locale, And Multi-Input Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Prevent accidental learner-data deletion, expose all four shipped locales, and support ordered multi-field integer answers.

**Architecture:** Keep learner deletion in `AppServices` and add a UI confirmation gate before it is invoked. Extend the question model with an optional ordered list of expected integer answers while preserving existing single-answer question JSON. Store multi-field submissions as a deterministic encoded string so existing answer-session storage remains compatible.

**Tech Stack:** Flutter/Dart, sqflite, bundled JSON question bank, widget and unit tests.

### Task 1: Confirm destructive learner deletion

**Files:**
- Modify: `test/widget_test.dart`
- Modify: `lib/main.dart`

**Step 1:** Add a widget test that taps `delete_learner_<id>`, expects a confirmation dialog explaining that history, wrong-answer records, and achievements are permanently removed, then verifies cancel keeps the learner.

**Step 2:** Run the named test; it must fail because deletion currently runs immediately.

**Step 3:** Add a localized `AlertDialog` with cancel and destructive-confirm actions. Call `_deleteLearner` only after explicit confirmation.

**Step 4:** Re-run the named test and the learner-profile widget tests.

### Task 2: Expose four supported interface locales

**Files:**
- Modify: `test/widget_test.dart`
- Modify: `lib/main.dart`

**Step 1:** Add a widget test asserting Traditional Chinese, Simplified Chinese, English, and Japanese controls are present and each changes the selected locale.

**Step 2:** Run the named test; it must fail because settings currently exposes only Chinese and English.

**Step 3:** Replace the two-choice row with a compact wrapping four-choice control and select locales by full language/country identity.

**Step 4:** Re-run locale-specific widget tests.

### Task 3: Model and score ordered multi-integer answers

**Files:**
- Modify: `test/question_bank_test.dart`
- Modify: `lib/models/question.dart`
- Modify: `lib/main.dart`

**Step 1:** Add parsing and scoring tests for a question containing two expected integer answers. Assert exact order is required and existing single integer input remains unchanged.

**Step 2:** Run the focused tests; they must fail because the model only has one `CorrectAnswer.value`.

**Step 3:** Add an optional ordered integer-answer list to `CorrectAnswer`, JSON parsing, answer comparison, and stable persisted submission encoding.

**Step 4:** Re-run focused model and scoring tests.

### Task 4: Render one input per expected answer

**Files:**
- Modify: `test/widget_test.dart`
- Modify: `lib/main.dart`

**Step 1:** Add practice and exam widget tests that expect two numeric fields for a two-answer question, require both fields, and submit the ordered value pair.

**Step 2:** Run the focused tests; they must fail because both pages render one `TextField`.

**Step 3:** Render one controller/field per expected answer in practice and formal exam UIs. Reuse the model comparison from Task 3 and show each answer separately in review detail.

**Step 4:** Run focused tests, then `dart format`, `flutter analyze`, and `flutter test`.

### Task 5: Verify and commit

**Files:** all changed files above

**Step 1:** Run `git diff --check`.

**Step 2:** Run `flutter test` and `flutter build ios --release --no-codesign`.

**Step 3:** Commit with a Chinese message after verification.
