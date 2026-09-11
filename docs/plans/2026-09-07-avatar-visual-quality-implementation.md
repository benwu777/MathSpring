# Avatar Visual Quality Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make every avatar preview visually aligned on small screens, integrate glasses into eye artwork, prevent skin colour from touching transparent background pixels, and make editor sections directly selectable.

**Architecture:** Replace accessory rendering with eye-option assets that may already contain glasses. Give skin colour an explicit opaque skin-mask layer so the filter can never reach transparent canvas pixels. Add a reproducible visual matrix/golden screenshot harness that renders every gender, hairstyle and skin configuration; use it to repair every hair asset and keep all controls within iPhone bounds.

**Tech Stack:** Flutter/Dart widget tests and golden/screenshot rendering, PNG avatar layers, existing localization delegates, ImageMagick for alpha inspection, built-in image generation for replacement hairstyle art.

### Task 1: Establish visual reproduction and screenshot test matrix

**Files:**
- Create: `test/avatar_visual_matrix_test.dart`
- Modify: `test/avatar_preview_test.dart`

1. Write tests that render every presentation × hairstyle × skin tone and record a stable labelled grid image.
2. Run it before any production change; save baseline screenshots outside source assets and inspect all variants manually.
3. Add assertions that rendered content stays inside the preview bounds and that no non-transparent hair pixel overlaps the eye-safe region.
4. Commit the test/harness separately.

### Task 2: Make skin tint pixel-safe

**Files:**
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `lib/widgets/avatar_preview.dart`
- Modify: `test/avatar_preview_test.dart`, `test/avatar_visual_matrix_test.dart`

1. Write a failing test proving every non-default skin leaves the preview background unchanged.
2. Run the focused test and confirm it fails due to the face-wide colour filter.
3. Replace the face-wide filter with an explicit skin-only mask/layer treatment; retain nose skin matching.
4. Render and inspect the complete skin screenshot matrix, then commit.

### Task 3: Integrate glasses into eye options

**Files:**
- Modify: `lib/models/avatar_configuration.dart`, `lib/services/avatar_asset_catalog.dart`, `lib/widgets/avatar_preview.dart`, `lib/widgets/avatar_editor.dart`
- Add/modify: `assets/avatars/{boy,girl}/eyes/*.png`
- Modify: `test/avatar_catalog_test.dart`, `test/avatar_preview_test.dart`, `test/avatar_editor_test.dart`, `test/avatar_layering_test.dart`

1. Write failing tests: no accessory editor step or rendered accessory layer; eye options include ordinary and built-in-glasses assets; legacy stored accessory remains accepted but ignored.
2. Run focused tests red.
3. Generate/copy aligned transparent complete eye assets for normal, round glasses, square glasses and sunglasses for each presentation; preserve regular no-glasses eyes.
4. Remove external accessory rendering/editor behaviour while retaining stored field compatibility.
5. Run tests green and inspect eye-option screenshot grid; commit.

### Task 4: Repair and diversify all hairstyles

**Files:**
- Modify: `assets/avatars/{boy,girl}/hair/*.png` and any necessary `*-back.png`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `test/avatar_layering_test.dart`, `test/avatar_visual_matrix_test.dart`

1. Use the visual baseline to enumerate each clipped, misaligned, overly similar or eye-covering hairstyle.
2. Write a failing per-style test for safe bounds/eye clearance and distinct asset mapping.
3. Generate or refit only the failing/similar assets with transparent canvas, distinct silhouette, consistent anchor and correct front/back separation.
4. Re-render the complete matrix, inspect it manually, and commit the assets plus tests.

### Task 5: Direct multi-language section navigation and iPhone-safe layout

**Files:**
- Modify: `lib/widgets/avatar_editor.dart` and localization files used by the editor
- Modify: `test/avatar_editor_test.dart`, `test/responsive_layout_test.dart`

1. Write failing widget tests for tappable translated section labels, no glasses section, direct navigation, and visible Back/Next controls at iPhone 390×844.
2. Run focused tests red.
3. Implement a horizontally scrollable localized section selector and a constrained bottom navigation row with safe padding.
4. Capture an iPhone-sized editor screenshot and manually inspect it; run tests green and commit.

### Task 6: Final visual and regression verification

**Files:**
- Add: `docs/plans/2026-09-07-avatar-visual-quality-design.md`, this implementation plan

1. Recreate final visual screenshots for all matrices and inspect every image.
2. Run `flutter test`, `flutter analyze`, and `git diff --check`.
3. Request review, then commit documentation and verification adjustments.
