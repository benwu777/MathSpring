# Girl Avatar Layer Expansion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Expand the paper-doll asset library toward ten hairstyles and eight options for every other part per presentation, while making the chooser grid as dense as each facial part permits.

**Architecture:** The existing girl face image remains the immutable 1254×1254 reference canvas. Each new asset is a transparent PNG generated against that reference, accepted only after a local composite preview proves that the face, eyes, nose, mouth, and hair align without background artifacts or eye occlusion. The catalog exposes only verified IDs and maps each saved ID to the matching layer.

**Tech Stack:** Flutter, `AvatarAssetCatalog`, built-in image generation, ImageMagick, Flutter widget tests.

### Task 1: Add a compositing acceptance command

**Files:**
- Create: `scripts/compose_girl_avatar_preview.sh`
- Create: `assets/avatars/girl/previews/acceptance/`

**Step 1: Write the command that composes the reference face, eyes, a supplied nose, a supplied mouth, and a supplied hairstyle in that order.**

**Step 2: Require a 1254×1254 transparent PNG input for every supplied layer and fail on a missing file.**

**Step 3: Run the command on the existing `*-01` layers and open the generated preview.**

**Step 4: Accept the command only if the preview has no opaque rectangle, eye overlap, or geometry drift.**

**Step 5: Commit.**

### Task 2: Produce six hairstyle layers

**Files:**
- Create: `assets/avatars/girl/hair/hair-02.png` through `hair-07.png`
- Create: matching chroma-source files only when needed for deterministic local background removal

**Step 1: Generate one hairstyle at a time using `portrait-01.png` as the geometry reference.**

**Step 2: Require a transparent 1254×1254 layer containing only dark-brown hair, with the face, eyes, brows, nose, mouth, neck, and background absent. Keep all fringe above the eyebrow line.**

**Step 3: Inspect alpha; reject opaque checkerboards or baked backgrounds. If a chroma background was produced, remove it locally and inspect edges.**

**Step 4: Compose and open each candidate with the acceptance command; retain only candidates that preserve both eyes.**

**Step 5: Commit accepted hair layers.**

### Task 3: Produce six nose layers

**Files:**
- Create: `assets/avatars/girl/nose/nose-02.png` through `nose-07.png`

**Step 1: Generate one nose at a time against the reference canvas, containing only a small hand-painted nose at the fixed center landmark.**

**Step 2: Inspect alpha and remove any chroma background deterministically.**

**Step 3: Compose each nose with the default hair and mouth; reject mismatched scale, perspective, or vertical placement.**

**Step 4: Commit accepted nose layers.**

### Task 4: Produce six mouth layers

**Files:**
- Create: `assets/avatars/girl/mouth/mouth-02.png` through `mouth-07.png`

**Step 1: Generate one mouth at a time against the reference canvas, containing only a subtle closed-mouth expression at the fixed mouth landmark.**

**Step 2: Inspect alpha and remove any chroma background deterministically.**

**Step 3: Compose each mouth with the default hair and nose; reject any opaque background or placement drift.**

**Step 4: Commit accepted mouth layers.**

### Task 5: Expose verified options in the catalog

**Files:**
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_preview_test.dart`

**Step 1: Write failing tests that expect seven girl options for hair, nose, and mouth, and expect each selected `*_07` ID to resolve to its own asset path.**

**Step 2: Run `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart` and confirm the new expectations fail.**

**Step 3: Add only the accepted IDs to `AvatarConfiguration` and map every ID explicitly in `AvatarAssetCatalog`.**

**Step 4: Re-run the two tests and confirm they pass.**

**Step 5: Commit.**

### Task 6: Verify interaction and final compositions

**Files:**
- Modify: `test/avatar_editor_test.dart`
- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_preview_test.dart`
- Test: `test/avatar_editor_test.dart`
- Test: `test/local_database_test.dart`

**Step 1: Write a widget test that taps a girl hairstyle, nose, and mouth option and asserts that `onChanged` receives each selected ID.**

**Step 2: Run it and confirm it fails if any picker does not propagate a selection.**

**Step 3: Make the smallest editor change required to pass, then run `dart format` on changed Dart files.**

**Step 4: Run `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/local_database_test.dart`.**

**Step 5: Build and open `flutter build macos --debug`; manually inspect a sample from each new layer family.**

**Step 6: Commit.**

### Task 7: Replace text chips with direct asset thumbnails

**Files:**
- Modify: `lib/widgets/avatar_editor.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Test: `test/avatar_editor_test.dart`

**Step 1: Write a failing widget test that advances to the girl hairstyle step and expects a grid of tappable asset thumbnail keys rather than text-only option chips.**

**Step 2: Run `flutter test test/avatar_editor_test.dart` and confirm it fails.**

**Step 3: Add a catalog method that resolves a category option ID to its own asset thumbnail.**

**Step 4: Replace the option `ChoiceChip` wrap with a 2–3 column grid. Each tile renders the isolated asset, exposes an accessible label, calls the existing selection callback, and shows a selected border plus check icon.**

**Step 5: Run `flutter test test/avatar_editor_test.dart` and confirm it passes.**

**Step 6: Build macOS debug, inspect hair, nose, and mouth grids, then commit.**

### Task 8: Enforce landmark-safe source specifications

**Files:**
- Modify: `docs/plans/2026-09-02-girl-avatar-layer-expansion.md`
- Modify: `scripts/compose_girl_avatar_preview.sh`

**Step 1: Record per-category fixed landmark boxes: hair excludes the eye, nose, and mouth safe zones while allowing upper and left expansion; eyes retain centers and separation; noses retain a fixed maximum bounding box; mouths retain a fixed center and maximum smile width.**

**Step 2: Update image-generation prompt templates to repeat the relevant category constraint verbatim.**

**Step 3: Verify each candidate at its actual app size as well as the 1254 px composition preview.**

### Task 9: Size chooser grids by facial-part scale

**Files:**
- Modify: `lib/widgets/avatar_editor.dart`
- Modify: `test/avatar_editor_test.dart`

**Step 1: Write a failing widget test that advances to hairstyle, eyes, nose, and mouth, and asserts their option grids use 3, 4, 5, and 5 columns respectively.**

**Step 2: Run `flutter test test/avatar_editor_test.dart` and confirm the new test fails because every grid currently uses three columns.**

**Step 3: Add one private grid-specification helper keyed by the editor step: skin, face, and hair use three columns; eyes use four; nose and mouth use five. Keep a compact, square tile ratio, and preserve the same tappable thumbnail semantics and selected treatment.**

**Step 4: Re-run `flutter test test/avatar_editor_test.dart` and confirm it passes.**

**Step 5: Run `dart format lib/widgets/avatar_editor.dart test/avatar_editor_test.dart`, build macOS debug, and visually inspect all five grid densities.**

### Task 10: Grow each presentation's verified asset set

**Files:**
- Create: `assets/avatars/{girl,boy}/{base,hair,eyes,nose,mouth}/*.png`
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `test/avatar_catalog_test.dart`
- Modify: `test/avatar_preview_test.dart`

**Step 1: Generate and accept assets one category at a time using the locked landmark boxes. Do not expose a generated image until its transparent composite passes visual inspection.**

**Step 2: For each newly accepted group, write failing catalog and preview mapping tests before adding its IDs.**

**Step 3: Increase each presentation to ten verified hairstyles and eight verified options for skin, face, eyes, nose, and mouth.**

**Step 4: Run the catalog, preview, editor, and local database test suite after every catalog update.**

**Step 5: Open the macOS build to inspect the chooser and real avatar changes at application size.**

### Task 11: Alternate verified facial-part batches across presentations

**Files:**
- Create: `assets/avatars/{girl,boy}/{eyes,nose,mouth}/*.png`
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `test/avatar_catalog_test.dart`
- Modify: `test/avatar_preview_test.dart`

**Step 1: Generate one facial layer per presentation at a time against its own 1254×1254 reference canvas. Keep eyes at their fixed centers, noses within the locked maximum box, and mouths within the maximum smile width.**

**Step 2: Use a background workflow appropriate to the layer: white keying for mouth layers; a separately validated transparent or masked workflow for eyes and noses. Reject a candidate whenever its actual composite has a halo, lost eye-white detail, or background speckles.**

**Step 3: Alternate accepted girl and boy assets so that neither presentation falls behind.**

**Step 4: Before every accepted batch is exposed, write the failing catalog and resolver test, run it to verify RED, add only the accepted paths and IDs, and run the focused Flutter test suite to GREEN.**

**Step 5: Reopen the iPhone simulator after every visible batch, and inspect selections at the real chooser size.**
