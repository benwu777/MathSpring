# Avatar Color and Boy Hair Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restrict skin tinting to skin pixels, remove eye-colour editing, keep glasses/eyes fixed dark, and replace the four new boy hair assets with face-clear aligned styles.

**Architecture:** Retain legacy persisted eye-colour values for compatibility but remove them from editor options and catalog rendering. Make preview tinting mask-aware so opaque source backgrounds cannot be recoloured. Preserve the existing boy-hair alignment policy and replace only `hair-06` through `hair-09` with transparent, aligned assets.

**Tech Stack:** Flutter/Dart, existing avatar asset catalog/preview/editor, PNG assets, built-in image generation, Flutter tests.

### Task 1: Lock down colour behaviour

**Files:** `lib/models/avatar_configuration.dart`, `lib/services/avatar_asset_catalog.dart`, `lib/widgets/avatar_preview.dart`, `lib/widgets/avatar_editor.dart`, `test/avatar_catalog_test.dart`, `test/avatar_preview_test.dart`, `test/avatar_editor_test.dart`.

1. Add failing tests for no eye-colour editor category, fixed dark eye tint, and skin tint isolation.
2. Run focused avatar tests red.
3. Remove the editor category while retaining deserialization compatibility; make catalog eyes fixed-dark; change preview skin rendering to affect only the face skin layer/mask, never opaque background or accessory layers.
4. Run focused avatar tests green and commit.

### Task 2: Replace new boy hair assets

**Files:** `assets/avatars/boy/hair/hair-06.png` through `hair-09.png`, `test/avatar_preview_test.dart`, `test/avatar_catalog_test.dart`.

1. Add failing alignment/face-clear asset expectations before replacing assets.
2. Generate four separate transparent PNGs with a consistent paper-doll style and canvas: short textured crop, side-part short hair, top-only fluffy curls, and crew cut. No ponytail, long side locks, or hair over eyes/face.
3. Inspect alpha and placement, copy final project assets non-destructively only after selection, run tests green, and commit.

### Task 3: Verify and document

**Files:** add validated design and this plan to branch.

1. Run all avatar and widget tests.
2. Run `flutter test`, `flutter analyze`, and `git diff --check`.
3. Request final review; commit docs; integrate only after user selection.
