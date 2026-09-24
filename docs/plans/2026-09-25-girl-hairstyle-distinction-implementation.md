# Girl Hairstyle Distinction Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace girl hair assets 02, 08, and 09 with visually distinct, aligned, transparent paper-doll layers while retaining their stable catalog IDs.

**Architecture:** Only raster assets change; `AvatarConfiguration` IDs and `AvatarAssetCatalog` paths remain stable. Each replacement must conform to the shared 1254×1254 RGBA layer contract so saved learner selections continue resolving without migration.

**Tech Stack:** Built-in image generation, PNG/RGBA assets, ImageMagick/Pillow checks, Flutter avatar tests, MathSpringReviewer visual inspection.

### Task 1: Preserve the asset contract in tests

**Files:**
- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_preview_test.dart`
- Verify: `assets/avatars/girl/hair/hair-02.png`, `hair-08.png`, `hair-09.png`

**Step 1: Add a focused regression assertion**

Assert IDs `girl_hair_02`, `girl_hair_08`, and `girl_hair_09` resolve to their own existing front-layer paths and remain individually selectable.

**Step 2: Run the focused suite**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart`

Expected: PASS before artwork replacement, proving the stable-ID contract is already covered.

### Task 2: Generate replacement artwork

**Files:**
- Replace: `assets/avatars/girl/hair/hair-02.png`
- Replace: `assets/avatars/girl/hair/hair-08.png`
- Replace: `assets/avatars/girl/hair/hair-09.png`

**Step 1: Generate hair 02**

Generate one transparent hair-only layer: ear-length, visibly springy short curls; no tied sections, no face, no features, and no background.

**Step 2: Generate hair 08**

Generate one transparent hair-only layer: high ponytail with side-swept fringe; visibly raised rear silhouette; no face, features, or background.

**Step 3: Generate hair 09**

Generate one transparent hair-only layer: low twin ponytails, smooth rather than braided; no face, features, or background.

**Step 4: Install selected outputs**

Move only the accepted images into their stable paths. Preserve the old files until a replacement has passed inspection.

### Task 3: Validate images and composed previews

**Files:**
- Verify: replacement PNGs and generated previews under `/private/tmp`

**Step 1: Check format and alpha**

Run ImageMagick/Pillow checks confirming each output is 1254×1254 RGBA with transparent pixels and no chroma-key spill.

**Step 2: Compose each hairstyle**

Run:

```sh
sh scripts/compose_girl_avatar_preview.sh \
  assets/avatars/girl/hair/hair-02.png \
  assets/avatars/girl/nose/nose-01.png \
  assets/avatars/girl/mouth/mouth-01.png \
  /private/tmp/hair-02-preview.png
```

Repeat with `hair-08.png` and `hair-09.png` in the first argument and matching
`/private/tmp/hair-08-preview.png` and `/private/tmp/hair-09-preview.png` output paths.

**Step 3: Visually inspect**

Confirm each style preserves face visibility, alignment, alpha, and a distinct outline from hair 01, 03, and one another.

### Task 4: Verify application integration

**Files:**
- Verify: `assets/avatars/girl/hair/hair-02.png`, `hair-08.png`, `hair-09.png`

**Step 1: Run avatar tests**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`

Expected: PASS.

**Step 2: Launch reviewer simulator**

Open MathSpringReviewer → paper-doll material inspection. Select girl hair 02, 08, and 09 and inspect at runtime.

**Step 3: Commit**

Run: `git add assets/avatars/girl/hair/hair-02.png assets/avatars/girl/hair/hair-08.png assets/avatars/girl/hair/hair-09.png test/avatar_catalog_test.dart docs/plans/2026-09-25-girl-hairstyle-distinction-implementation.md && git commit -m "art: distinguish girl hairstyle options"`
