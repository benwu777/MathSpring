# Geometry Foundation Pack Expansion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Expand the six bundled geometry foundation packs from one question each to ten questions each, with bilingual `zh-Hant` and `en` content and app-native drawn figures where needed.

**Architecture:** Keep the existing JSON-first content pipeline and current filename conventions. Update only the six geometry asset files plus targeted tests that verify pack counts and content integrity; do not change runtime models or repository interfaces. Every geometry question remains compatible with current answer modes, figure rendering, grading, and solution display.

**Tech Stack:** Flutter asset JSON packs, bundled manifest indexing, Flutter test

### Task 1: Lock the expected geometry pack size

**Files:**
- Modify: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add assertions that verify:
- each `geometry` foundation pack contains `10` questions
- total `geometry` foundation questions across grade1-grade6 equals `60`
- the existing grade4 trigonometry demo pack still loads successfully

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart`
Expected: FAIL because the geometry packs currently contain only 1 question each.

**Step 3: Write minimal implementation**

No runtime implementation. Make the content changes in Tasks 2-4.

**Step 4: Run test to verify it passes**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

### Task 2: Expand grade1-grade2 geometry foundation packs

**Files:**
- Modify: `assets/questions/geometry/grade1_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade2_foundation.geometry.v1.json`

**Step 1: Add grade1 geometry questions 002-010**

Cover simple shape recognition, side counting, corner counting, equal-length intuition, inside/outside, and basic position or symmetry prompts.

**Step 2: Add grade2 geometry questions 002-010**

Cover polygons, perimeter-by-counting unit edges, simple nets intuition, mirrored shapes, and basic route or direction interpretation.

**Step 3: Validate JSON shape**

Check every new question includes:
- stable `id`
- `topic`, `subtopic`, `difficulty`, `levelStage`, `challengeTier`
- `prompt`, `answer`, `solutionSteps` in `zh-Hant` and `en`
- `figure`
- `answerMode`
- `correctAnswer`
- `inputConstraints` or `options` when required by the answer mode

### Task 3: Expand grade3-grade4 geometry foundation packs

**Files:**
- Modify: `assets/questions/geometry/grade3_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade4_foundation.geometry.v1.json`

**Step 1: Add grade3 geometry questions 002-010**

Cover angle intuition, line segment comparison, rectangle and square properties, grid movement, and area-by-counting squares.

**Step 2: Add grade4 geometry questions 002-010**

Preserve the existing trigonometry graph demo as question `001`, then add coordinate-plane reading, reflected points, graph interpretation, and introductory geometric relations that remain foundation level.

**Step 3: Validate figure compatibility**

Ensure all figures use app-native renderable definitions already supported by the current figure system. Do not introduce a new figure kind in this batch.

### Task 4: Expand grade5-grade6 geometry foundation packs

**Files:**
- Modify: `assets/questions/geometry/grade5_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade6_foundation.geometry.v1.json`

**Step 1: Add grade5 geometry questions 002-010**

Cover triangle classification, composite perimeter, area with missing dimensions inferred from diagrams, coordinate reading, and simple transformations.

**Step 2: Add grade6 geometry questions 002-010**

Cover ratio in geometric diagrams, coordinate distances on aligned axes, angle-chasing basics, circle parts, and graph-based geometric interpretation while staying in the `foundation` tier.

**Step 3: Keep answer modes natural**

Use mixed `multiple_choice` and `integer_input` only. Prefer integer input for count, coordinate, perimeter, or area answers; prefer multiple choice for classification, angle type, or figure interpretation.

### Task 5: Verify bilingual content quality and taxonomy consistency

**Files:**
- Modify: `assets/questions/geometry/grade1_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade2_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade3_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade4_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade5_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade6_foundation.geometry.v1.json`

**Step 1: Audit bilingual fields**

Confirm every question has usable `zh-Hant` and `en` text. Leave `zh-Hans` and `ja` absent for now rather than inserting placeholder text.

**Step 2: Audit subtopics**

Keep subtopics within the existing geometry taxonomy already introduced in the project, such as `lines_angles`, `shapes_properties`, `perimeter_area`, `coordinate_geometry`, `transformations`, or equivalent established geometry labels.

**Step 3: Audit solution quality**

Each question must have short, explicit, stepwise solutions that match the chosen answer mode and final answer exactly.

### Task 6: Run verification

**Files:**
- Test: `test/question_bank_test.dart`
- Test: `test/widget_test.dart`

**Step 1: Run targeted question bank verification**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

**Step 2: Run full regression verification**

Run: `flutter test`
Expected: PASS

**Step 3: Optional manual sanity check**

Run: `flutter run`
Expected: the app can open the existing geometry demo and still render geometry-driven question content without asset errors.
