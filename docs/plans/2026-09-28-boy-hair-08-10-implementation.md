# Boy Hair 08–10 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace boy hairstyles 08–10 with three distinct, animated-character silhouettes while keeping the shared head fit and visible eyes.

**Architecture:** Generate the three transparent 1254px PNG layers using the confirmed silhouettes, then replace only `hair-08.png`, `hair-09.png`, and `hair-10.png`. Existing catalog IDs and face-aware preview resolution remain unchanged. The visual matrix and existing avatar tests validate that each layer is distinct, bounded, and available to the editor.

**Tech Stack:** Flutter, Dart widget tests, existing avatar visual-matrix tests, image generation.

### Task 1: Create the three confirmed hairstyle layers

**Files:**
- Modify: `assets/avatars/boy/hair/hair-08.png`
- Modify: `assets/avatars/boy/hair/hair-09.png`
- Modify: `assets/avatars/boy/hair/hair-10.png`

**Step 1: Generate hair 08**

Create a transparent hair-only layer: short side coverage, three to four upward/sideward front spikes, visible eye area, and a crown that fully covers the head.

**Step 2: Generate hair 09**

Create a transparent hair-only layer: an extremely short military buzz cut, tight to the head with equally close-cropped crown and sides, only faint root texture, and no fringe, spikes, braid, ponytail, or bulky volume.

**Step 3: Generate hair 10**

Create a transparent hair-only layer: rounded bowl-cut volume, fringe ending above the eyes, and small outward flips at the sides and back.

**Step 4: Install the generated PNGs**

Copy each final PNG onto its matching catalog path while preserving the canonical transparent canvas.

### Task 2: Prove the redesigned layers are distinct

**Files:**
- Modify: `test/avatar_preview_test.dart`

**Step 1: Write the failing test**

Add a catalog-resolution test that checks hair 08, 09, and 10 resolve to their matching asset paths and remain distinct from each other.

**Step 2: Run the focused test**

Run: `flutter test test/avatar_preview_test.dart --name "resolves the animated boy hairstyles 08 through 10"`

Expected: the test initially fails if the expected coverage is absent.

**Step 3: Add only the minimal assertion or catalog update needed**

Do not change IDs or layout code unless a new asset cannot be resolved.

**Step 4: Re-run the focused test**

Expected: PASS.

### Task 3: Verify the visual output and full regression suite

**Files:**
- Verify: `/private/tmp/mathspring-avatar-rendered-matrix/boy-matrix-page-1.png`

**Step 1: Run the complete avatar suite**

Run: `flutter test test/avatar_catalog_test.dart test/avatar_preview_test.dart test/avatar_editor_test.dart test/avatar_visual_matrix_test.dart`

Expected: all tests pass, including transparent-canvas and bounded-placement assertions.

**Step 2: Inspect the generated boy matrix**

Confirm 08 is the front-spike protagonist style, 09 is the flat-top buzz cut, and 10 is the outward-flipped bowl cut; none expose scalp or cover the eyes.

**Step 3: Build and launch the reviewer**

Run in the sibling reviewer project: `flutter build macos --debug`, then open `build/macos/Build/Products/Debug/mathspring_reviewer.app`.

**Step 4: Commit after user visual approval**

Stage only the three hair assets, their test changes, and the design/implementation records. Commit with a Chinese subject per repository convention.
