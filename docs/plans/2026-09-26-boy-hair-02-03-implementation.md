# 男生髮型 2、3 重製 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the placeholder boy hairstyles 2 and 3 with distinct, aligned paper-doll artwork.

**Architecture:** Keep the existing canonical 1254px transparent layers and option IDs. Generate independent raster hair layers based on the visual size of approved hairstyles 1 and 6, then validate their alpha, geometry, and composition through the existing reviewer test matrix.

**Tech Stack:** Built-in image generation, ImageMagick, Pillow, Flutter widget tests.

### Task 1: Produce hairstyle 2 artwork

**Files:**

- Modify: `assets/avatars/boy/hair/hair-02.png`
- Reference: `assets/avatars/boy/hair/hair-01.png`
- Reference: `assets/avatars/boy/hair/hair-06.png`

**Step 1: Generate the initial transparent layer**

Create a 1254×1254 transparent PNG that contains only a natural short, textured boy haircut. Retain a modest crown and side silhouette comparable to hairstyles 1 and 6; keep the fringe above y=490.

**Step 2: Verify canvas and alpha**

Run: `magick identify -format '%wx%h %[channels]\\n' assets/avatars/boy/hair/hair-02.png`

Expected: `1254x1254 srgba 4.0`.

**Step 3: Check background and green spill**

Run the alpha and green-spill checks documented in `docs/avatar-asset-generation-rules.md`.

Expected: transparent canvas; maximum green spill is zero or lower.

### Task 2: Produce hairstyle 3 artwork

**Files:**

- Modify: `assets/avatars/boy/hair/hair-03.png`
- Reference: `assets/avatars/boy/hair/hair-01.png`
- Reference: `assets/avatars/boy/hair/hair-06.png`

**Step 1: Generate the initial transparent layer**

Create a 1254×1254 transparent PNG containing only a clearly side-parted, medium-short boy haircut. The fringe must sweep naturally to one side and stop above the eyebrow band.

**Step 2: Verify canvas and alpha**

Run: `magick identify -format '%wx%h %[channels]\\n' assets/avatars/boy/hair/hair-03.png`

Expected: `1254x1254 srgba 4.0`.

**Step 3: Check background and green spill**

Run the alpha and green-spill checks documented in `docs/avatar-asset-generation-rules.md`.

Expected: transparent canvas; maximum green spill is zero or lower.

### Task 3: Verify composition

**Files:**

- Test: `test/avatar_visual_matrix_test.dart`
- Review: `MathSpringReviewer/lib/main.dart`

**Step 1: Run the visual matrix**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`

Expected: all tests pass and output matrices appear below `/private/tmp/mathspring-avatar-rendered-matrix`.

**Step 2: Inspect the boy matrix**

Open the rendered matrix and MathSpringReviewer. Compare 2 and 3 with 1 and 6: crown scale and temple placement should match; eyes must remain visible in both tile and full preview.

**Step 3: Commit**

Stage the two replacement PNGs and the plan documentation, then commit with `feat: redesign boy hairstyles two and three`.
