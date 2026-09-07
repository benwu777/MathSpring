# Unanswered Question Priority Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make practice and quiz launches draw a learner's unanswered eligible questions before returning to answered questions.

**Architecture:** Keep the existing eligibility and approval filters unchanged. Add a pure ordering helper to `SessionLaunchPlanBuilder`, then have `_openFirstEligiblePack` load the current learner's progress records and pass their question IDs into that helper before session randomization.

**Tech Stack:** Flutter/Dart, `flutter_test`, sqflite-backed `QuestionProgressRepository`.

### Task 1: Define unanswered-first selection behavior

**Files:**
- Modify: `test/session_launch_plan_test.dart`
- Modify: `lib/services/session_launch_plan_builder.dart`

**Step 1: Write failing tests**

Add a test that returns only unanswered questions when at least one exists, and another that returns all eligible questions when all supplied IDs were answered.

**Step 2: Verify the tests fail**

Run: `flutter test test/session_launch_plan_test.dart`

Expected: FAIL because no unanswered-first helper exists.

**Step 3: Write the minimal helper**

Add `preferUnansweredQuestionsForLaunch(questions, answeredQuestionIds)` that filters by stable question ID; use all questions only when the unanswered set is empty.

**Step 4: Verify green**

Run: `flutter test test/session_launch_plan_test.dart`

Expected: PASS.

### Task 2: Connect persisted learner progress to every launch mode

**Files:**
- Modify: `lib/data/local/app_services.dart`
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart` if an integration regression needs coverage

**Step 1: Write a failing integration-oriented test**

Assert the service can retrieve the current learner's progress records for launch selection, or test the launch helper with persisted data when practical.

**Step 2: Verify red**

Run: `flutter test <targeted test>`

Expected: FAIL because launch code cannot obtain its learner's completed IDs.

**Step 3: Implement minimal wiring**

Expose a learner-progress read method through `AppServices`, read it in `_openFirstEligiblePack`, and pass the resulting question IDs to the selection helper before randomization. This shared entry point covers practice, quiz, and formal-exam launches.

**Step 4: Verify green**

Run: `flutter test test/session_launch_plan_test.dart test/widget_test.dart`

Expected: PASS.

### Task 3: Verify

**Files:**
- Modify only if verification reveals a defect.

**Step 1: Run format and analyzer**

Run: `dart format lib/services/session_launch_plan_builder.dart lib/data/local/app_services.dart lib/main.dart test/session_launch_plan_test.dart && flutter analyze`

**Step 2: Run full suite**

Run: `flutter test`

Expected: no test failures.
