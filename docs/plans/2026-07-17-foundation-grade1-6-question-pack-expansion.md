# Foundation Grade1-6 Question Pack Expansion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Expand the bundled question bank to a complete grade1-grade6 foundation skeleton across arithmetic, geometry, and logic with one question per pack.

**Architecture:** Keep the existing JSON-first content pipeline. Add one pack file per `(topicCode, levelStage, foundation)` combination, preserve the current filename and manifest rules, and use mixed answer modes where natural. Update only question assets and question-bank tests; do not change runtime data models.

**Tech Stack:** Flutter asset JSON packs, manifest indexing, Flutter test

### Task 1: Lock the expected bundled bank size

**Files:**
- Modify: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add assertions for:
- manifest pack count = 18
- loadAllPacks count = 18
- total bundled questions = 18

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart`
Expected: FAIL because the manifest and assets still only contain 2 packs.

**Step 3: Write minimal implementation**

No runtime implementation. Add the content files and manifest entries in Tasks 2-4.

**Step 4: Run test to verify it passes**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

### Task 2: Add arithmetic foundation packs for grade1-grade6

**Files:**
- Create: `assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json`
- Create: `assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json`
- Modify: `assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json`
- Create: `assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json`
- Create: `assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json`
- Create: `assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json`

**Step 1: Add one valid question per pack**

Use stable ids and foundation-level arithmetic prompts with mixed answer modes when natural.

**Step 2: Verify JSON shape**

Check that each file contains:
- metadata block
- multilingual prompt/answer/solution fields
- figure
- answer mode
- correct answer

### Task 3: Add geometry foundation packs for grade1-grade6

**Files:**
- Create: `assets/questions/geometry/grade1_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade2_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade3_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade4_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade5_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade6_foundation.geometry.v1.json`

**Step 1: Add one valid question per pack**

Prefer elementary geometry topics aligned to the taxonomy and app support.

### Task 4: Add logic foundation packs for grade1-grade6 and update the manifest

**Files:**
- Create: `assets/questions/logic/grade1_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade2_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade3_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade4_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade5_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade6_foundation.logic.v1.json`
- Modify: `assets/questions/manifest.json`

**Step 1: Add one valid question per pack**

Use elementary logic subtopics such as matching, elimination, and truth/false statements.

**Step 2: Update the manifest**

List all 18 packs with `questionCount: 1`.

### Task 5: Verify the full bank

**Files:**
- Test: `test/question_bank_test.dart`

**Step 1: Run targeted verification**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

**Step 2: Run full verification**

Run: `flutter test`
Expected: PASS
