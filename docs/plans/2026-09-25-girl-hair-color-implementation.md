# Girl Hair Color Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give girl avatars six persistent runtime hair-color choices while preserving the current hairstyle artwork and hair-layer alignment.

**Architecture:** Add a validated `hairColorId` to `AvatarConfiguration` and the learner-profile database, defaulting legacy data to deep brown. `AvatarAssetCatalog` will resolve a girl-only color treatment, and `AvatarPreview` will apply that treatment identically to front and back hair layers. `AvatarEditor` adds a color-swatch step only for girls; hairstyle tiles continue to use `AvatarPreview`, so their color and layer composition match the large preview.

**Tech Stack:** Flutter/Dart, sqflite migrations, `flutter_test`, `ColorFiltered`, MathSpringReviewer.

### Task 1: Persist a validated girl hair-color selection

**Files:**
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Test: `test/avatar_catalog_test.dart`
- Test: `test/local_database_test.dart`

**Step 1: Write failing configuration tests.**

Add tests that assert a default girl configuration selects `girl_hair_color_02` (deep brown), accepts each of the six known girl color IDs, and resolves a missing or invalid `avatar_hair_color_id` from a legacy profile to the default.

**Step 2: Run the focused configuration test.**

Run: `flutter test test/avatar_catalog_test.dart`

Expected: FAIL because `hairColorId` and the color option registry do not yet exist.

**Step 3: Implement the configuration contract.**

In `AvatarConfiguration`, add six stable girl color IDs, `optionsFor(..., 'hair_color')`, a `hairColorId` constructor field, `copyWith`, `fromMap`, and `toMap`. Keep boy configurations fixed to the default color so no boy editor choice is introduced.

**Step 4: Write the failing database migration test.**

Extend the existing schema-upgrade coverage to open a v7 learner-profile database, upgrade it, and assert that `avatar_hair_color_id` exists and a saved girl profile round-trips the selected color.

**Step 5: Implement the migration.**

Raise `MathSpringDatabase.schemaVersion` from 7 to 8; add `avatar_hair_color_id TEXT` to both new `learner_profiles` table creation and the v8 upgrade guarded by `_addColumnIfMissing`.

**Step 6: Run focused tests.**

Run: `flutter test test/avatar_catalog_test.dart test/local_database_test.dart`

Expected: PASS.

**Step 7: Commit.**

```bash
git add lib/models/avatar_configuration.dart lib/data/local/mathspring_database.dart test/avatar_catalog_test.dart test/local_database_test.dart
git commit -m '功能：儲存女生髮色選擇'
```

### Task 2: Apply a runtime hair color to both hair layers

**Files:**
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `lib/widgets/avatar_preview.dart`
- Test: `test/avatar_preview_test.dart`

**Step 1: Write failing preview tests.**

Add widget tests that build a girl configuration with a non-default hair color, assert a keyed color-filtered hair treatment surrounds the front layer, and repeat for `girl_hair_06` to prove the back layer has the same treatment. Assert the corresponding boy preview has no girl color treatment.

**Step 2: Run the focused preview test.**

Run: `flutter test test/avatar_preview_test.dart`

Expected: FAIL because the catalog does not expose a hair tint and the hair layers are unfiltered.

**Step 3: Add the six fixed swatches to the catalog.**

Declare fixed display colors for black, deep brown, chestnut, light brown, deep auburn, and silver gray. Add a nullable `hairTint` to `AvatarAssetBundle`; resolve it only for girls, using the deep-brown value by default.

**Step 4: Render through one shared hair-layer helper.**

In `AvatarPreview._hairLayer`, wrap the existing translate/scale/image composition in a keyed `ColorFiltered` using `BlendMode.color`. This preserves the alpha and the source luminance/highlights while replacing the source hair hue. Use this same helper for front and back hair assets.

**Step 5: Run focused tests.**

Run: `flutter test test/avatar_preview_test.dart test/avatar_visual_matrix_test.dart`

Expected: PASS.

**Step 6: Commit.**

```bash
git add lib/services/avatar_asset_catalog.dart lib/widgets/avatar_preview.dart test/avatar_preview_test.dart
git commit -m '功能：套用女生即時髮色'
```

### Task 3: Add the girl-only hair-color editor step

**Files:**
- Modify: `lib/widgets/avatar_editor.dart`
- Test: `test/avatar_editor_test.dart`

**Step 1: Write failing editor tests.**

Add a widget test that selects girl presentation, advances to the hair-color section, finds six keyed color-swatch choices, selects chestnut, and verifies both the emitted configuration and the large preview use `girl_hair_color_03`. Add a companion test that switches to boy and verifies the color section is absent.

**Step 2: Run the focused editor test.**

Run: `flutter test test/avatar_editor_test.dart`

Expected: FAIL because the editor exposes only seven sections and no hair-color controls.

**Step 3: Implement dynamic girl sections.**

Replace the fixed seven-step switch with a presentation-aware section list. Insert a `hairColor` section after `hair` for girls only; update selected values, next/back bounds, and selection handling without changing boy step ordering.

**Step 4: Implement accessible swatches.**

Render the six girl color options as circular `ChoiceChip`/InkWell swatches with stable keys `avatar_option_girl_hair_color_0N`, semantic labels, selection borders/checkmarks, and display colors from `AvatarAssetCatalog`. Do not run the regular asset-thumbnail path for this category.

**Step 5: Keep hairstyle previews synchronized.**

Verify each hairstyle tile still passes `_configuration.copyWith(hairId: id)` into `AvatarPreview`; therefore the currently selected `hairColorId` is retained for both large preview and option tiles.

**Step 6: Run focused tests.**

Run: `flutter test test/avatar_editor_test.dart test/avatar_preview_test.dart`

Expected: PASS.

**Step 7: Commit.**

```bash
git add lib/widgets/avatar_editor.dart test/avatar_editor_test.dart
git commit -m '功能：新增女生髮色色票'
```

### Task 4: Verify end-to-end behavior

**Files:**
- Verify: `lib/models/avatar_configuration.dart`
- Verify: `lib/data/local/mathspring_database.dart`
- Verify: `lib/services/avatar_asset_catalog.dart`
- Verify: `lib/widgets/avatar_preview.dart`
- Verify: `lib/widgets/avatar_editor.dart`

**Step 1: Run formatting and static analysis.**

Run: `dart format --set-exit-if-changed lib/models/avatar_configuration.dart lib/data/local/mathspring_database.dart lib/services/avatar_asset_catalog.dart lib/widgets/avatar_preview.dart lib/widgets/avatar_editor.dart test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/local_database_test.dart`

Run: `flutter analyze`

Expected: both exit 0.

**Step 2: Run the avatar and persistence suites.**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart test/local_database_test.dart`

Expected: PASS.

**Step 3: Build and inspect Reviewer Release.**

From `../MathSpringReviewer`, run `flutter build macos`, then launch `build/macos/Build/Products/Release/mathspring_reviewer.app/Contents/MacOS/mathspring_reviewer`. In the paper-doll inspector, verify all six girl colors, hair 06 front/back rendering, hair 08 silhouette, and that boy editor flow has no hair-color tab.

**Step 4: Check the diff and commit verification metadata.**

Run: `git diff --check`.

**Step 5: Commit.**

```bash
git add docs/plans/2026-09-25-girl-hair-color-implementation.md
git commit -m '文件：補上女生髮色實作計畫'
```
