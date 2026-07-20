# Learner Management Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add basic learner management so one device can create, switch, and remove multiple learner profiles.

**Architecture:** Keep learner data in the existing local SQLite store and expose small lifecycle methods through `AppServices`. Extend the current home-screen learner section into a lightweight management surface with an add dialog and inline remove actions. Preserve the current single-screen flow and avoid introducing a separate settings page yet.

**Tech Stack:** Flutter, sqflite, widget tests, local database tests

### Task 1: Repository and Service Support

**Files:**
- Modify: `lib/data/local/learner_profile_repository.dart`
- Modify: `lib/data/local/question_progress_repository.dart`
- Modify: `lib/data/local/app_services.dart`
- Test: `test/local_database_test.dart`

**Step 1: Write the failing tests**

- Add a repository test for deleting a learner profile by id.
- Add a service-level test path that ensures deleting the current learner switches to another learner.

**Step 2: Run tests to verify they fail**

Run: `flutter test test/local_database_test.dart`

**Step 3: Write minimal implementation**

- Add delete support in `LearnerProfileRepository`.
- Add delete support for learner-linked progress in `QuestionProgressRepository`.
- Add `createLearner` and `deleteLearner` methods in `AppServices`.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/local_database_test.dart`

### Task 2: Learner Management UI

**Files:**
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart`

**Step 1: Write the failing widget tests**

- Add a test that creates a new learner from the profiles section.
- Add a test that deletes a learner and keeps a valid current learner selected.

**Step 2: Run tests to verify they fail**

Run: `flutter test test/widget_test.dart`

**Step 3: Write minimal implementation**

- Add a compact “add learner” action.
- Present a simple dialog with name, stage, and tier inputs.
- Add inline remove action for non-current learners.
- Refresh the profiles section after create/delete.

**Step 4: Run tests to verify they pass**

Run: `flutter test test/widget_test.dart`

### Task 3: Full Verification

**Files:**
- Verify only

**Step 1: Run the full test suite**

Run: `flutter test`

**Step 2: Confirm no regressions**

- Home locale tests still pass.
- Demo answer attribution still uses the selected learner.
- Database tests still pass.
