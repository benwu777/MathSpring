# Geometry Renderer Demo Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a first-stage geometry renderer that supports simple shape diagrams and coordinate-plane diagrams, then connect 2-3 bundled geometry questions to it for visual verification.

**Architecture:** Keep the existing `QuestionFigure` model and extend the app's figure rendering entry point beyond `trig_plane`. Use a mixed strategy: a small number of stable templates (`shape_diagram`, `coordinate_plane`) plus a constrained set of reusable elements driven by JSON params. Limit this batch to current app-native drawing only and reuse the existing question display flow in practice and quiz modes.

**Tech Stack:** Flutter widgets, `CustomPainter`, bundled JSON question packs, Flutter widget tests

### Task 1: Lock renderer behavior with failing widget tests

**Files:**
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add widget coverage that verifies:
- a `shape_diagram` figure renders a visible diagram container in a question flow
- a `coordinate_plane` figure renders a visible coordinate-plane container in a question flow
- the existing `trig_plane` renderer still works unchanged

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because only `trig_plane` is currently rendered.

**Step 3: Write minimal implementation**

Add the renderer in Tasks 2-3.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS

### Task 2: Add a reusable geometry figure rendering entry point

**Files:**
- Modify: `lib/main.dart`

**Step 1: Extract figure rendering logic**

Replace the inline `trig_plane` check with a single helper widget that:
- returns nothing for `kind: none`
- renders `trig_plane`
- renders `shape_diagram`
- renders `coordinate_plane`

**Step 2: Keep usage shared**

Use the same helper in both practice and quiz question presentation so visual behavior stays aligned.

### Task 3: Implement the two new diagram painters

**Files:**
- Modify: `lib/main.dart`

**Step 1: Add `shape_diagram` support**

Support a small template-driven schema such as:
- `shape`: `square`, `rectangle`, `triangle`, `circle`
- optional numeric labels for side lengths
- optional caption labels

**Step 2: Add `coordinate_plane` support**

Support a constrained param set such as:
- `maxX`, `maxY`
- `points`
- optional `path`
- optional `highlightPoint`
- `showGrid`

**Step 3: Keep scope narrow**

Do not introduce advanced angle arcs, circle sectors, or generalized vector scene graphs in this batch.

### Task 4: Connect demo questions to the new renderer

**Files:**
- Modify: `assets/questions/geometry/grade2_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade3_foundation.geometry.v1.json`
- Modify: `assets/questions/geometry/grade4_foundation.geometry.v1.json`

**Step 1: Add one shape demo question**

Attach `shape_diagram` params to a geometry question that benefits from a simple rectangle or square visual.

**Step 2: Add one coordinate demo question**

Attach `coordinate_plane` params to a grid-movement or coordinate-reading question.

**Step 3: Keep the trig demo intact**

Preserve the existing grade4 trigonometry question as the third visual proof point.

### Task 5: Verify the demo renderer end to end

**Files:**
- Test: `test/widget_test.dart`
- Test: `test/question_bank_test.dart`

**Step 1: Run targeted widget verification**

Run: `flutter test test/widget_test.dart`
Expected: PASS

**Step 2: Run targeted question-bank verification**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

**Step 3: Run full regression verification**

Run: `flutter test`
Expected: PASS
