# Girl Hair 08 and Preview Consistency Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace malformed girl hair 08 and make girl hair 06’s option thumbnail use the same resolved visual layers as its editor preview.

**Architecture:** Preserve stable hair IDs and catalog paths. Trace `AvatarEditor` preview and option-thumbnail asset resolution to remove their divergence, then add a regression test. Generate only a new transparent front asset for hair 08 and validate it against the shared avatar layer contract.

**Tech Stack:** Flutter/Dart, flutter_test, built-in image generation, PNG/RGBA assets, MathSpringReviewer.

### Task 1: Reproduce and specify hair-06 consistency

**Files:**
- Test: `test/avatar_editor_test.dart`, `test/avatar_preview_test.dart`
- Modify: `lib/widgets/avatar_editor.dart`, `lib/widgets/avatar_preview.dart`, or `lib/services/avatar_asset_catalog.dart` only as tracing requires

**Step 1:** Trace the asset/treatment resolution used by the editor preview and hair option thumbnail.

**Step 2:** Add a focused failing test asserting hair 06’s thumbnail and preview resolve to the same ordered front/back layer paths and transforms.

**Step 3:** Run the focused test; confirm it fails for the actual divergence.

**Step 4:** Apply the smallest shared resolver or call-site correction; rerun focused tests.

### Task 2: Replace malformed hair 08

**Files:**
- Replace: `assets/avatars/girl/hair/hair-08.png`

**Step 1:** Inspect the girl reference and unchanged neighboring hairs.

**Step 2:** Generate a single transparent hair-only 1254×1254 layer: natural high ponytail, restrained raised rear silhouette, side-swept fringe entirely above eye line, no face/features/background/text.

**Step 3:** Validate alpha, dimensions, green spill, and compose with face 01; reject any eye obstruction or malformed silhouette.

### Task 3: Verify in app and reviewer

**Files:**
- Verify: changed Dart, test, asset files

**Step 1:** Run `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`.

**Step 2:** Rebuild MathSpringReviewer, open the paper-doll inspector, and verify hair 06 thumbnail matches preview and hair 08 appears natural.

**Step 3:** Commit the focused fix with a Chinese commit title.
