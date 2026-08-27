# Daily Mission and Formal Exam Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a five-question daily practice mission and a timed, fixed-paper formal exam with integer, grade-weighted scoring.

**Architecture:** Keep daily-mission calculation and exam scoring as pure Dart services, so their rules are testable independently of Flutter. Persist formal-exam configuration and awarded points alongside the existing answer-session history; the home screen reads session records to surface an unfinished daily mission, while the formal exam reuses the existing approved-question launch pipeline to create one immutable paper before the timer starts.

**Tech Stack:** Flutter/Dart, sqflite, flutter_test.

### Task 1: Grade-weighted integer scoring

**Files:**
- Create: `lib/services/formal_exam_scoring.dart`
- Create: `test/formal_exam_scoring_test.dart`

**Step 1: Write failing tests**

Cover grade parsing, the continuous raw weighting from 60 at grade 1 to 120 at grade 12, integer point allocation that sums to 100, and deterministic remainder tie-breaking.

**Step 2: Run the focused test and verify RED**

Run: `flutter test test/formal_exam_scoring_test.dart`

Expected: compilation failure because the scoring service does not exist.

**Step 3: Write minimal scoring service**

Create a `FormalExamQuestionScore` value object and an allocator that takes the fixed paper's questions. Convert each question's existing `levelStage` to its grade; calculate proportional quotas from `60 + (grade - 1) * 60 / 11`; floor values; then give the remaining points to the largest fractional remainders, breaking equal remainders by original paper order. Each question receives an integer and the paper always totals 100.

**Step 4: Run the focused test and verify GREEN**

Run: `flutter test test/formal_exam_scoring_test.dart`

**Step 5: Commit**

```bash
git add lib/services/formal_exam_scoring.dart test/formal_exam_scoring_test.dart
git commit -m "feat: add integer formal exam scoring"
```

### Task 2: Daily-practice mission domain rule

**Files:**
- Create: `lib/services/daily_mission.dart`
- Create: `test/daily_mission_test.dart`
- Modify: `lib/data/local/app_services.dart`

**Step 1: Write failing tests**

Verify only `practice` sessions answered on the requested local date count, correct and incorrect answers both count, five is complete, and the motivational phrase selection is stable for the same learner and date.

**Step 2: Run focused test and verify RED**

Run: `flutter test test/daily_mission_test.dart`

**Step 3: Write minimal implementation**

Add an immutable `DailyMissionProgress` and pure calculator. Add an `AppServices.getLearnerDailyMissionProgress` convenience method that loads existing sessions and records and delegates to the calculator.

**Step 4: Run focused test and verify GREEN**

Run: `flutter test test/daily_mission_test.dart`

**Step 5: Commit**

```bash
git add lib/services/daily_mission.dart lib/data/local/app_services.dart test/daily_mission_test.dart
git commit -m "feat: track daily practice missions"
```

### Task 3: Persist formal-exam scores and time limit

**Files:**
- Modify: `lib/models/answer_session.dart`
- Modify: `lib/models/session_answer_record.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Modify: `test/local_database_test.dart`

**Step 1: Write failing persistence test**

Save a formal-exam session with a time limit, score out of 100, and per-question maximum/earned values; assert they round-trip. Keep all legacy constructors valid by making new fields optional.

**Step 2: Run focused test and verify RED**

Run: `flutter test test/local_database_test.dart`

**Step 3: Write minimal migration and model changes**

Bump the SQLite schema to version 4. Add nullable `time_limit_seconds`, `max_score`, and `earned_score` columns to sessions and nullable per-answer `max_score`/`earned_score` columns. Include them in model map conversion and preserve existing history.

**Step 4: Run focused test and verify GREEN**

Run: `flutter test test/local_database_test.dart`

**Step 5: Commit**

```bash
git add lib/models/answer_session.dart lib/models/session_answer_record.dart lib/data/local/mathspring_database.dart test/local_database_test.dart
git commit -m "feat: persist formal exam score details"
```

### Task 4: Launch a five-question daily practice mission

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget tests**

Assert an unfinished mission is the default home content, displays a stable encouraging message and `0 / 5`, launches exactly five approved questions, and lets the learner still open normal practice and formal exam.

**Step 2: Run focused test and verify RED**

Run: `flutter test test/widget_test.dart --plain-name "shows the daily mission"`

**Step 3: Implement minimal mission landing UI**

Add a non-navigation daily-mission landing page selected only while today's practice count is under five. Reuse `_openFirstEligiblePack`, add an optional question limit, and use the existing randomized approved question set. Refresh its count after returning from a practice page.

**Step 4: Run focused test and verify GREEN**

Run: `flutter test test/widget_test.dart --plain-name "shows the daily mission"`

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: show and launch daily practice mission"
```

### Task 5: Formal-exam configuration and fixed-paper experience

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget tests**

Cover preset selection (5 questions / 10 minutes, 10 / 20, 15 / 30), creation of a fixed mixed-topic paper from the learner's grade range, score labels in the question navigator, free jumping without feedback, and manual submission saving a 100-point integer result.

**Step 2: Run focused test and verify RED**

Run: `flutter test test/widget_test.dart --plain-name "formal exam"`

**Step 3: Implement the exam flow**

Replace the direct quiz launch with a preset picker. Select a fixed number of approved questions before navigation, allocate the 100 points once, display countdown/progress and a navigator grid with unanswered/answered state and per-question points. Do not reveal correctness until submission; unanswered questions earn zero. Persist the configuration, total, and per-question awarded points, then show a scored result review. Use `Timer.periodic` to auto-submit at the deadline.

**Step 4: Run focused test and verify GREEN**

Run: `flutter test test/widget_test.dart --plain-name "formal exam"`

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: add timed formal exam flow"
```

### Task 6: Full verification

**Files:**
- Modify only if verification uncovers a defect.

**Step 1: Format modified Dart files**

Run: `dart format lib test`

**Step 2: Static analysis**

Run: `flutter analyze`

Expected: `No issues found!`

**Step 3: Full regression suite**

Run: `flutter test`

Expected: all tests pass.

**Step 4: Review and final commit**

Review `git diff --check` and `git status --short`, then commit any verification fixes separately.
