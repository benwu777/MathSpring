# Question Pack Realignment Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Realign bundled MathSpring question packs so topic, competition profile, and grade progression better match olympiad-foundation expectations.

**Architecture:** Keep the current JSON-pack storage model and manifest-driven loading flow. Replace weak or duplicated content in the riskiest packs first, add targeted tests for pack selection and content invariants, and preserve the current app/runtime data model so only bundled content and validation logic change.

**Tech Stack:** Flutter, Dart tests, bundled JSON assets

### Task 1: Lock current pack-selection expectations

**Files:**
- Modify: `test/session_launch_plan_test.dart`
- Modify: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add tests for:
- dedicated `mixed/kangaroo56_foundation.mixed.v1.json` launch preference
- manifest pack count and total question count after adding the dedicated mixed pack

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart`
Expected: fail before mixed-pack preference is implemented

**Step 3: Write minimal implementation**

Update `lib/services/session_launch_plan_builder.dart` so grade-5/6 mixed launches prefer a dedicated mixed pack when available.

**Step 4: Run test to verify it passes**

Run: `flutter test test/session_launch_plan_test.dart`
Expected: PASS

### Task 2: Replace the highest-risk bundled content

**Files:**
- Modify: `assets/questions/logic/grade3_foundation.logic.v1.json`
- Modify: `assets/questions/logic/grade4_foundation.logic.v1.json`
- Modify: `assets/questions/logic/grade5_foundation.logic.v1.json`
- Modify: `assets/questions/logic/grade6_foundation.logic.v1.json`
- Modify: `assets/questions/geometry/grade4_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade5_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade6_foundation.geometry.v1.json`
- Modify: `assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json`
- Modify: `assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json`
- Create/Modify: `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json`

**Step 1: Write the failing test**

Add or extend content-audit expectations so:
- grade-4 geometry contains no trigonometry prompt
- logic grade packs do not share large verbatim prompt sets
- upper-grade packs contain multi-step olympiad-style prompts

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart`
Expected: fail on duplicated logic content and off-band geometry content

**Step 3: Write minimal implementation**

Rewrite the affected JSON packs with:
- unique prompt sets per grade
- explicit topic/subtopic alignment
- multi-step reasoning appropriate to the band
- multilingual prompt/answer/solution content
- valid `source` objects for every question

**Step 4: Run test to verify it passes**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

### Task 3: Harden remaining packs

**Files:**
- Modify: lower-risk packs under `assets/questions/arithmetic/` and `assets/questions/geometry/` as needed
- Modify: `docs/question-bank-taxonomy.md` if structure assumptions changed

**Step 1: Write the failing test**

Add expectations for:
- no obvious direct-recall-only outliers in upper packs
- all packs still contain 10 questions
- all questions still carry source metadata and supported locales

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart`
Expected: fail if remaining packs still violate the new baseline

**Step 3: Write minimal implementation**

Adjust remaining packs to remove obvious school-drill outliers while preserving current data schema.

**Step 4: Run test to verify it passes**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

### Task 4: Final regression

**Files:**
- Modify: none unless regressions appear

**Step 1: Run full verification**

Run: `flutter test`
Expected: all tests pass

**Step 2: Relaunch simulator build**

Run: `flutter run -d <simulator-id>`
Expected: app launches with updated question packs
