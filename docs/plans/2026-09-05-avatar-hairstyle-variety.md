# Avatar Hairstyle Variety Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add four visually distinct, colour-varied hairstyle choices for each avatar presentation.

**Architecture:** Register eight stable hair IDs in `AvatarConfiguration`, resolve each to its own transparent PNG front layer through `AvatarAssetCatalog`, and give long or tied styles a separate back layer where required. Existing selections and assets remain unchanged.

**Tech Stack:** Flutter/Dart, `flutter_test`, transparent RGBA PNG assets, built-in image generation.

### Task 1: Specify the expanded hairstyle catalog

**Files:**
- Modify: `test/avatar_catalog_test.dart`
- Modify: `test/avatar_preview_test.dart`
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`

**Step 1: Write the failing test**

Assert the girl list ends with `girl_hair_07` through `girl_hair_10`, the boy list ends with `boy_hair_06` through `boy_hair_09`, and each resolves to its dedicated asset path (with a back layer for hairstyles that need it).

**Step 2: Run test to verify it fails**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart`

Expected: FAIL because the new IDs are not exposed or resolvable.

**Step 3: Write minimal implementation**

Add the eight IDs to their existing `hair` lists. Register only necessary back-layer paths; let the naming convention resolve every front layer directly.

**Step 4: Run test to verify it passes**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart`

Expected: PASS once assets exist.

### Task 2: Produce and add composable hairstyle artwork

**Files:**
- Create: `assets/avatars/girl/hair/hair-07.png` through `hair-10.png`
- Create: `assets/avatars/boy/hair/hair-06.png` through `hair-09.png`
- Create as needed: matching `*-back.png` files

**Step 1: Generate the artwork**

Use the built-in image generator for one distinct hairstyle per request. Require transparent backgrounds, a 1254×1254 aligned square canvas, the existing friendly flat child-avatar illustration style, and hair only—no face, features, text, body, or background.

**Step 2: Inspect and install final assets**

Check that each PNG has transparency and the shared square dimensions. Copy only the chosen output into the documented asset paths without overwriting existing files.

**Step 3: Run focused tests**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart`

Expected: PASS with every registered hairstyle backed by an asset.

### Task 3: Verify the user-facing picker and overall project

**Files:**
- Modify: `test/avatar_editor_test.dart` only if its expected option set requires updating.

**Step 1: Add or update picker test**

Assert the editor exposes all newly registered hair option IDs for both presentations.

**Step 2: Run test to verify it fails, then pass**

Run: `flutter test test/avatar_editor_test.dart`

Expected: initial failure for the missing IDs; PASS after the catalog implementation and assets are complete.

**Step 3: Format and verify**

Run: `dart format lib test && flutter analyze && flutter test`

Expected: no formatting changes, analyzer issues, or test failures.
