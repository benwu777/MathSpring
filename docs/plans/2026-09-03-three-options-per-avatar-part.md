# Three Options Per Avatar Part Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give both avatar presentations at least three visibly distinct, selectable options for every editor part.

**Architecture:** Retain the aligned bitmap layers and add a small, data-driven visual treatment to `AvatarAssetBundle` for third options that do not yet have a separate bitmap. Treatments remain part-specific: skin uses a tint, face uses scale, eyes use scale, nose uses scale, mouth uses scale, and hair uses scale/translation. Keep the existing small-nose mouth calibration unchanged.

**Tech Stack:** Flutter, Dart, flutter_test.

### Task 1: Add the third selection identifiers

**Files:**
- Modify: `lib/models/avatar_configuration.dart:25-53`
- Test: `test/avatar_catalog_test.dart`

**Step 1: Write the failing test**

Assert every category list for both presentations has three or more entries.

**Step 2: Run test to verify it fails**

Run: `flutter test test/avatar_catalog_test.dart`
Expected: FAIL because multiple categories contain two IDs.

**Step 3: Write minimal implementation**

Add a `*_03` ID to every list currently shorter than three.

**Step 4: Run test to verify it passes**

Run: `flutter test test/avatar_catalog_test.dart`
Expected: PASS.

### Task 2: Map third IDs to visible, aligned treatments

**Files:**
- Modify: `lib/services/avatar_asset_catalog.dart:7-145`
- Modify: `lib/widgets/avatar_preview.dart:15-70`
- Test: `test/avatar_preview_test.dart`

**Step 1: Write the failing test**

Resolve every new third option and assert a non-default treatment appropriate to its part, while retaining the boy small-nose mouth offset of `.20`.

**Step 2: Run test to verify it fails**

Run: `flutter test test/avatar_preview_test.dart`
Expected: FAIL because third IDs currently resolve as defaults.

**Step 3: Write minimal implementation**

Expose per-layer scale or tint values in `AvatarAssetBundle`; apply them in `AvatarPreview` without changing existing layer order or offsets.

**Step 4: Run test to verify it passes**

Run: `flutter test test/avatar_preview_test.dart`
Expected: PASS.

### Task 3: Make option tiles represent virtual treatments

**Files:**
- Modify: `lib/widgets/avatar_editor.dart:150-210`
- Test: `test/avatar_editor_test.dart`

**Step 1: Write the failing test**

Pump the editor and assert a third-option tile has its visual treatment widget.

**Step 2: Run test to verify it fails**

Run: `flutter test test/avatar_editor_test.dart`
Expected: FAIL because tiles only show the raw base image.

**Step 3: Write minimal implementation**

Apply the same tint/scale treatment used in the preview to the relevant option thumbnail.

**Step 4: Run test to verify it passes**

Run: `flutter test test/avatar_editor_test.dart`
Expected: PASS.

### Task 4: Verify and launch on iPhone

**Files:**
- Verify: `test/avatar_catalog_test.dart`
- Verify: `test/avatar_preview_test.dart`
- Verify: `test/avatar_editor_test.dart`

**Step 1: Format**

Run: `dart format lib/models/avatar_configuration.dart lib/services/avatar_asset_catalog.dart lib/widgets/avatar_preview.dart lib/widgets/avatar_editor.dart test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart`

**Step 2: Run the paper-doll suite**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart`
Expected: PASS.

**Step 3: Launch**

Run: `flutter run -d C216595E-584A-482E-AD88-E09256156A1C`
Expected: iPhone simulator shows the new third thumbnails and selectable preview treatments.
