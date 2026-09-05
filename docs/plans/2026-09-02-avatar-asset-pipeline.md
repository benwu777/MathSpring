# Avatar Asset Pipeline Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Produce a consistent, composable female paper-doll avatar asset set whose pieces always align on one fixed headshot canvas.

**Architecture:** A single complete reference portrait defines the canvas, facial landmarks, and face-safe region. Every generated component is an isolated transparent PNG on that exact canvas; the generator must preserve the reference geometry, and a local composition command checks the result before an asset may enter the app catalog.

**Tech Stack:** Built-in image generation, PNG chroma-key removal, ImageMagick composition, Flutter assets.

### Task 1: Freeze the reference canvas

**Files:**
- Create: `assets/avatars/girl/reference/portrait-01.png`
- Create: `assets/avatars/girl/reference/portrait-01.landmarks.json`

**Step 1: Create the reference portrait**

Generate one complete front-facing girl headshot without clothing. Use a 1:1 canvas, retain it unchanged for all later edits, and remove the chroma-key background.

**Step 2: Record the landmark contract**

Write fixed normalized positions for the face-safe oval, two eye centers, nose center, mouth center, and the outer hair boundary. The contract must state that hair cannot paint inside the face-safe oval except for the top fringe band.

**Step 3: Inspect the portrait**

Open the transparent PNG and check that both the outline and the landmark locations are visually symmetric.

### Task 2: Make one isolated layer per category

**Files:**
- Create: `assets/avatars/girl/hair/hair-01.png`
- Create: `assets/avatars/girl/eyes/eyes-01.png`
- Create: `assets/avatars/girl/nose/nose-01.png`
- Create: `assets/avatars/girl/mouth/mouth-01.png`

**Step 1: Generate the hair edit from the reference**

Use the portrait as the reference. Output only the selected hairstyle on the same canvas and keep every non-hair pixel the chroma key. Require the transparent face opening and prohibit face, eyes, nose, mouth, and neck.

**Step 2: Generate each facial feature from the same reference**

Create one layer per category. Each prompt must lock its landmark position and prohibit all other components.

**Step 3: Remove chroma backgrounds**

Run `remove_chroma_key.py` through the isolated Pillow environment, then inspect each PNG for alpha and edge quality.

### Task 3: Verify compositing before accepting assets

**Files:**
- Create: `assets/avatars/girl/previews/composite-01.png`
- Create: `scripts/compose_avatar_preview.sh`

**Step 1: Create the composition command**

Use ImageMagick to layer face base, eyes, nose, mouth, and hair in that order onto a transparent canvas.

**Step 2: Open and inspect the preview**

Reject the asset set if hair overlaps eyes, a facial feature changes face geometry, any layer carries a nontransparent rectangle, or style/perspective no longer match.

**Step 3: Commit the accepted source assets**

Run `git add assets/avatars/girl scripts/compose_avatar_preview.sh` and commit only accepted assets.

### Task 4: Prepare the production catalog

**Files:**
- Create: `assets/avatars/girl/catalog.json`
- Modify: `pubspec.yaml`

**Step 1: Define catalog identifiers**

Record each accepted layer's stable identifier, category, canvas size, and filename. Keep identifiers independent from the generated filename so later artwork can be upgraded without changing saved learner preferences.

**Step 2: Register the asset directory**

Add the avatar asset directory to Flutter's asset manifest.

**Step 3: Verify Flutter sees all assets**

Run `flutter test` and `flutter analyze`; later avatar UI tests will resolve assets by catalog identifier.
