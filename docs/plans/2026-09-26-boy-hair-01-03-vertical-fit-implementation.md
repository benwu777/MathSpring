# 男生髮型 1–3 頭頂對位 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Raise boy hairstyles 1–3 by one shared amount so each covers the crown like hairstyle 6 without covering the eyes.

**Architecture:** Apply a common vertical correction after resolving the per-face hair treatment, rather than changing PNG pixels or duplicating values across every face-specific fit. This keeps the main preview and thumbnail renderer aligned because both consume `AvatarAssetCatalog.resolve`.

**Tech Stack:** Flutter/Dart, existing avatar asset catalog, Flutter widget tests, Reviewer visual matrix.

### Task 1: Express the shared vertical correction

**Files:**

- Modify: `lib/services/avatar_asset_catalog.dart`
- Test: `test/avatar_preview_test.dart`

**Step 1: Write a failing test**

Add a test that resolves default boy hairstyles 1, 2, and 3 and expects all three to carry the same negative vertical hair offset while hairstyle 6 remains unaffected.

**Step 2: Run the focused test to verify it fails**

Run: `flutter test test/avatar_preview_test.dart`

Expected: FAIL because resolved hair offsets are currently neutral or differ by the original fit.

**Step 3: Implement the minimal correction**

Add a single constant lift for boy hair IDs 1–3 and combine it with the face-aware offset when creating `AvatarAssetBundle`.

**Step 4: Run the focused test to verify it passes**

Run: `flutter test test/avatar_preview_test.dart`

Expected: PASS.

### Task 2: Verify the visual composition

**Files:**

- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_editor_test.dart`
- Test: `test/avatar_visual_matrix_test.dart`

**Step 1: Run the avatar suite**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`

Expected: all tests pass.

**Step 2: Inspect and rebuild Reviewer**

Inspect `/private/tmp/mathspring-avatar-rendered-matrix/boy-matrix-page-1.png`, then run `flutter build macos --debug` from `../MathSpringReviewer` and launch the resulting app. Confirm 1–3 cover the crown while keeping eyes unobstructed.

**Step 3: Commit**

Stage the catalog, test, and plan documentation, then commit with `fix: lift early boy hairstyles over the crown`.
