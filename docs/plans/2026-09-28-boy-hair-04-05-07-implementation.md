# 男生髮型 4、5、7 重製 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace boy hairstyles 4, 5, and 7 with distinct flat-top, afro, and one-sided angular styles aligned to the accepted early-hair baseline.

**Architecture:** Keep option IDs and the shared 1254px transparent canvas unchanged. Generate one independent layer per hairstyle using 1–3 as scale references; the existing shared early-boy crown lift automatically aligns them during resolution.

**Tech Stack:** Built-in image generation, ImageMagick, Pillow, Flutter widget tests, MathSpringReviewer.

### Task 1: Produce flat-top hairstyle 4

**Files:**

- Modify: `assets/avatars/boy/hair/hair-04.png`
- Reference: `assets/avatars/boy/hair/hair-01.png`
- Reference: `assets/avatars/boy/hair/hair-02.png`
- Reference: `assets/avatars/boy/hair/hair-03.png`

**Step 1:** Generate a hair-only transparent layer with a short, low flat-top silhouette and no eye coverage.

**Step 2:** Verify `1254x1254 srgba 4.0` and zero green spill.

### Task 2: Produce afro hairstyle 5

**Files:**

- Modify: `assets/avatars/boy/hair/hair-05.png`

**Step 1:** Generate a hair-only transparent layer with a rounded, fluffy afro outline, staying clear of the brows and eyes.

**Step 2:** Verify `1254x1254 srgba 4.0` and zero green spill.

### Task 3: Produce angular side-swept hairstyle 7

**Files:**

- Modify: `assets/avatars/boy/hair/hair-07.png`

**Step 1:** Generate a hair-only transparent layer with a distinctive, exaggerated one-sided upward angular silhouette while keeping the eyes clear.

**Step 2:** Verify `1254x1254 srgba 4.0` and zero green spill.

### Task 4: Verify preview composition

**Files:**

- Test: `test/avatar_catalog_test.dart`
- Test: `test/avatar_preview_test.dart`
- Test: `test/avatar_editor_test.dart`
- Test: `test/avatar_visual_matrix_test.dart`

**Step 1:** Run `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`.

Expected: all tests pass.

**Step 2:** Inspect the rendered boy matrix and rebuild MathSpringReviewer. Confirm all three new hairstyles align to the 1–3 baseline and leave eyes unobstructed.

**Step 3:** Stage the three PNGs and planning documents, then commit with `feat: redesign boy hairstyles four five and seven`.

### Task 5: Correct the first visual-matrix pass

**Files:**

- Modify: `assets/avatars/boy/hair/hair-04.png`
- Modify: `assets/avatars/boy/hair/hair-05.png`
- Modify: `assets/avatars/boy/hair/hair-07.png`

**Step 1:** Regenerate hair 04 with a taller flat-top crown that covers the head top.

**Step 2:** Regenerate hair 05 as a compact, elevated afro whose lowest curls remain above the brows.

**Step 3:** Regenerate hair 07 with the same one-sided angular silhouette but a raised, shortened fringe that clears both eyes.

**Step 4:** Re-run the full avatar test matrix and inspect the boy page before rebuilding Reviewer.

### Task 6: Correct hair 04 and 07 silhouette

**Files:**

- Modify: `assets/avatars/boy/hair/hair-04.png`
- Modify: `assets/avatars/boy/hair/hair-07.png`

**Step 1:** Regenerate hair 04 as an unmistakably ultra-short military flat-top.

**Step 2:** Regenerate hair 07 with a taller crown but the same raised side-point silhouette.

**Step 3:** Run the visual matrix and inspect the boy page before rebuilding Reviewer.
