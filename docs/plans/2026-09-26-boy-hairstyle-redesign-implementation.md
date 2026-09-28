# Boy Hairstyle Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace boys avatar hairstyles with ten clearly different natural hairstyles.

**Architecture:** Preserve existing stable IDs and canonical transparent PNG placement. Replace only the hair assets and update catalog treatments or back-layer mappings only when a new silhouette requires it. The editor and preview keep their shared `AvatarPreview` renderer.

**Tech Stack:** Flutter/Dart, PNG RGBA assets, built-in image generation, flutter_test, MathSpringReviewer.

### Task 1: Specify and test the ten-style catalog

**Files:**
- Modify: `docs/plans/2026-09-10-avatar-material-specification.md`
- Test: `test/avatar_preview_test.dart`
- Test: `test/avatar_visual_matrix_test.dart`

**Step 1:** Add a failing distinct-silhouette assertion for every boy hair ID and retain the transparent-canvas/eye-clearance checks.

**Step 2:** Run the focused tests and verify any new expected IDs/spec are absent.

**Step 3:** Document the mapping: 01 buzz, 02 textured crop, 03 side part, 04 loose curls, 05 fluffy curls, 06 fringe crop, 07 pompadour, 08 medium-short, 09 tapered cut, 10 low bun.

### Task 2: Replace hairstyles 01–05

**Files:**
- Replace: `assets/avatars/boy/hair/hair-01.png` through `hair-05.png`

**Step 1:** Inspect boy face reference and current canonical assets.

**Step 2:** Generate one transparent, hair-only, 1254×1254 asset per ID, using each assigned silhouette; reject any face/features/background, eye obstruction, or near-duplicate.

**Step 3:** Compose each on the boy face and inspect at editor scale.

**Step 4:** Run focused preview/matrix tests and commit.

### Task 3: Replace hairstyles 06–10 and supporting layers

**Files:**
- Replace: `assets/avatars/boy/hair/hair-06.png` through `hair-10.png`
- Modify only if required: `lib/services/avatar_asset_catalog.dart`

**Step 1:** Generate/validate five remaining natural silhouettes. Use a back layer only if a design genuinely needs one and cover it in the catalog.

**Step 2:** Verify all ten at full preview and tile scale; compare neighboring styles for silhouette separation.

**Step 3:** Run the focused suites and commit.

### Task 4: Final validation and reviewer inspection

**Files:**
- Verify: all changed hair assets, catalog treatment, tests, and documents

**Step 1:** Run `dart format --set-exit-if-changed` on changed Dart, `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`, and `git diff --check`.

**Step 2:** Build MathSpringReviewer Release and inspect all ten boy hairstyles in the paper-doll editor. Confirm thumbnail/preview agreement, visible eyes, transparent canvases, and strong differences.

**Step 3:** Commit the implementation plan and complete review before integration.
