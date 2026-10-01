# 男生髮型 1 中分重製 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace boy hairstyle 1 with a neat center-part style sized from approved hairstyle 6.

**Architecture:** Retain the existing option ID and 1254px transparent PNG contract. Produce one replacement layer whose crown and side extents are measured visually from hair 6, then use the matrix test to ensure the fringe leaves brows and eyes unobstructed.

**Tech Stack:** Built-in image generation, ImageMagick, Pillow, Flutter widget tests.

### Task 1: Produce hairstyle 1 artwork

**Files:**

- Modify: `assets/avatars/boy/hair/hair-01.png`
- Reference: `assets/avatars/boy/hair/hair-06.png`

**Step 1: Generate a transparent center-part layer**

Create a 1254×1254 RGBA PNG containing only a neat, closely controlled center-parted boys haircut. Match hair 6 for crown size, width and temple extents; use a shallow fringe that keeps eyebrows and eyes visible.

**Step 2: Verify the asset contract**

Run: `magick identify -format '%wx%h %[channels]\\n' assets/avatars/boy/hair/hair-01.png`

Expected: `1254x1254 srgba 4.0`.

**Step 3: Validate edge colour**

Run the alpha and green-spill check in `docs/avatar-asset-generation-rules.md`.

Expected: transparent canvas and no positive green spill on opaque pixels.

### Task 2: Verify avatar composition

**Files:**

- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_preview_test.dart`
- Test: `test/avatar_editor_test.dart`
- Test: `test/avatar_visual_matrix_test.dart`

**Step 1: Run the focused avatar suite**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`

Expected: all tests pass.

**Step 2: Inspect the boy matrix in Reviewer**

Open `/private/tmp/mathspring-avatar-rendered-matrix/boy-matrix-page-1.png` and MathSpringReviewer. Confirm hair 1 matches hair 6's scale and leaves the brows and eyes clearly readable.

**Step 3: Commit**

Stage `assets/avatars/boy/hair/hair-01.png` and the design/implementation documents, then commit with `feat: redesign boy center-part hairstyle`.
