# Paper-Doll Avatar Assets Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add two complete, composable paper-doll facial-component libraries and wire a learner's selected avatar through local persistence and the learner UI.

**Architecture:** Keep the avatar catalogue in a dedicated Dart model that maps stable component IDs to opaque PNG assets. `LearnerProfile` persists one presentation and one ID per facial category, with deterministic catalogue defaults for legacy rows. A compositing widget stacks the fixed-size layers in the documented order and is used by the creation and editing workflows.

**Tech Stack:** Flutter/Dart, `flutter_test`, SQLite via `sqflite`, built-in image generation, bundled PNG assets.

### Task 1: Define the catalogue and its contract

**Files:**
- Create: `lib/models/paper_doll_avatar.dart`
- Create: `test/paper_doll_avatar_test.dart`

**Step 1: Write the failing test**

Assert both `boy` and `girl` catalogues define exactly the six categories (`skinTone`, `faceShape`, `hairstyle`, `eyes`, `nose`, `mouth`), at least five IDs in each, and return a deterministic default selection.

**Step 2: Run test to verify it fails**

Run: `flutter test test/paper_doll_avatar_test.dart`

Expected: FAIL because the catalogue does not exist.

**Step 3: Write minimal implementation**

Create immutable avatar/presentation/category types, stable IDs, asset path lookup, validation, and defaults. Keep image paths below `assets/avatars/<presentation>/<category>/`.

**Step 4: Run test to verify it passes**

Run: `flutter test test/paper_doll_avatar_test.dart`

Expected: PASS.

### Task 2: Generate and register composable PNG layers

**Files:**
- Create: `assets/avatars/boy/{skin_tone,face_shape,hairstyle,eyes,nose,mouth}/...png`
- Create: `assets/avatars/girl/{skin_tone,face_shape,hairstyle,eyes,nose,mouth}/...png`
- Modify: `pubspec.yaml`
- Modify: `test/paper_doll_avatar_test.dart`

**Step 1: Write the failing test**

Extend the catalogue test to assert every registered path appears in Flutter's asset manifest and every category has five usable, unique asset paths.

**Step 2: Run test to verify it fails**

Run: `flutter test test/paper_doll_avatar_test.dart`

Expected: FAIL because image assets are absent/unregistered.

**Step 3: Create assets**

Use the built-in image generator once per distinct layer. Each result must be a 1024×1024 transparent PNG in the same friendly flat-vector illustration style: forward-facing child head, no text, no background, centered in the same safe area. Generate independently composable layers only: skin/face silhouette as base; nose, mouth, eyes/glasses, and hairstyle on otherwise transparent canvas. Do not include clothing, accessories, neck/body, or duplicate facial features in the wrong layer. Inspect each generated file, place final assets in its stable catalogue path, and add `assets/avatars/` to `pubspec.yaml`.

**Step 4: Run test to verify it passes**

Run: `flutter test test/paper_doll_avatar_test.dart`

Expected: PASS with all 60+ paths registered and unique.

### Task 3: Persist avatar selections compatibly

**Files:**
- Modify: `lib/models/learner_profile.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Modify: `lib/data/local/app_services.dart`
- Modify: `test/local_database_test.dart`

**Step 1: Write the failing test**

Add tests proving a profile round-trips a non-default avatar through SQLite and a legacy row without avatar columns loads with the deterministic default.

**Step 2: Run test to verify it fails**

Run: `flutter test test/local_database_test.dart`

Expected: FAIL because profile serialization and schema omit avatar fields.

**Step 3: Write minimal implementation**

Add presentation and six component-ID columns, bump the schema version, migrate existing rows as nullable/default-safe, normalize missing or invalid selections through the catalogue default, and expose `copyWith` for edits. Extend `createLearner` to receive the confirmed avatar selection.

**Step 4: Run test to verify it passes**

Run: `flutter test test/local_database_test.dart`

Expected: PASS.

### Task 4: Render and edit the avatar

**Files:**
- Create: `lib/widgets/paper_doll_avatar.dart`
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing widget tests**

Test that the create flow exposes presentation plus six component steps, choosing an option changes the visible preview asset, saving retains the selected avatar, and reopening a learner lets the selection be changed.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`

Expected: FAIL because no avatar editor or compositing widget exists.

**Step 3: Write minimal implementation**

Build `PaperDollAvatar` as a fixed-aspect `Stack` ordered face/skin, nose, mouth, eyes, hair. Add a compact avatar to learner cards and an editor with one category per step; preserve selections on Back/Next and only persist after confirmation. Reuse the editor from the learner edit route.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`

Expected: PASS.

### Task 5: Verify the integrated feature

**Files:**
- Modify only if verification reveals a defect.

**Step 1: Format and analyze**

Run: `dart format lib test && flutter analyze`

Expected: no formatter changes left and no analyzer issues.

**Step 2: Run focused and full tests**

Run: `flutter test test/paper_doll_avatar_test.dart test/local_database_test.dart test/widget_test.dart && flutter test`

Expected: all tests pass.

**Step 3: Perform visual QA**

Run the app and inspect representative cross-category boy and girl combinations at both editor-preview and compact-card sizes. Check transparent backgrounds, fixed alignment, and intended layer order.

**Step 4: Commit**

```bash
git add lib/models/paper_doll_avatar.dart lib/widgets/paper_doll_avatar.dart lib/models/learner_profile.dart lib/data/local/mathspring_database.dart lib/data/local/app_services.dart lib/main.dart assets/avatars pubspec.yaml test/paper_doll_avatar_test.dart test/local_database_test.dart test/widget_test.dart docs/plans/2026-09-03-paper-doll-avatar-assets-implementation.md
git commit -m "feat: add composable paper-doll avatar assets"
```
