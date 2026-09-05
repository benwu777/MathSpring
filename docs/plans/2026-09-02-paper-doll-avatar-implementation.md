# Paper-Doll Avatar Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Let every learner create, persist, display, and later revise a composable boy or girl avatar with five selectable options for each supported feature.

**Architecture:** `AvatarConfiguration` is a small immutable model stored directly with `LearnerProfile`. `AvatarCatalog` exposes stable identifiers and safe defaults, while `AvatarPreview` renders the selected components on a shared normalized canvas. The current generated boy and girl portraits remain visual references; the runtime renderer uses fixed proportional component slots so every combination remains aligned and does not require a large, fragile bitmap batch before the feature is usable.

**Tech Stack:** Flutter Material widgets and `CustomPainter`, Dart models, sqflite migration, flutter_test.

### Task 1: Model the configurable avatar catalog

**Files:**
- Create: `lib/models/avatar_configuration.dart`
- Create: `lib/services/avatar_catalog.dart`
- Test: `test/avatar_catalog_test.dart`

**Step 1: Write failing catalog tests**

Assert that both presentations expose five options for skin, face, hair, eyes, nose, and mouth; assert invalid or missing legacy values resolve to a deterministic default.

**Step 2: Run the focused test**

Run: `flutter test test/avatar_catalog_test.dart`
Expected: FAIL because the model and catalog do not exist.

**Step 3: Implement the immutable configuration and catalog**

Add stable string identifiers, `copyWith`, map serialization, validation, and presentation-specific defaults.

**Step 4: Re-run the focused test**

Run: `flutter test test/avatar_catalog_test.dart`
Expected: PASS.

### Task 2: Persist avatar selection with legacy safety

**Files:**
- Modify: `lib/models/learner_profile.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Modify: `lib/data/local/app_services.dart`
- Test: `test/local_database_test.dart`

**Step 1: Write failing persistence tests**

Save a learner with an avatar, reload it, and assert all selections survive. Read a map with no avatar fields and assert it receives a deterministic legacy-safe default.

**Step 2: Run the focused test**

Run: `flutter test test/local_database_test.dart`
Expected: FAIL because avatar fields are absent from the schema and profile model.

**Step 3: Add schema version 5 migration and profile mapping**

Store presentation plus one stable id per category in `learner_profiles`; migrate existing rows with nullable/default-safe fields. Let creation accept an optional avatar configuration.

**Step 4: Re-run the focused test**

Run: `flutter test test/local_database_test.dart`
Expected: PASS.

### Task 3: Render the aligned avatar preview

**Files:**
- Create: `lib/widgets/avatar_preview.dart`
- Test: `test/avatar_preview_test.dart`

**Step 1: Write failing widget tests**

Pump a girl and boy preview, assert the canvas is present and changing a component selection changes its semantic label / painter configuration.

**Step 2: Run the focused test**

Run: `flutter test test/avatar_preview_test.dart`
Expected: FAIL because the preview widget does not exist.

**Step 3: Implement the shared-coordinate renderer**

Draw face base, nose, mouth, eyes, and hair in a stable layer order. Each catalog id changes only its own component; boy and girl use distinct facial and hair proportions based on the approved references.

**Step 4: Re-run the focused test**

Run: `flutter test test/avatar_preview_test.dart`
Expected: PASS.

### Task 4: Build the wizard and integrate learner flows

**Files:**
- Modify: `lib/main.dart`
- Test: `test/widget_test.dart`

**Step 1: Write failing workflow tests**

Verify new learner creation exposes presentation first, can proceed through six feature steps, keeps a live preview, and returns the chosen configuration. Verify edit opens the same editor and saving updates the learner avatar.

**Step 2: Run the focused test**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because the wizard and preview integration do not exist.

**Step 3: Implement the reusable avatar editor**

Add a progressive editor with Back/Next controls and option chips. Require an explicit gender presentation on the first step. Embed it after the learner name/range creation inputs and in `LearnerEditPage`; display the avatar on profile tiles and current-learner banner.

**Step 4: Re-run widget tests**

Run: `flutter test test/widget_test.dart`
Expected: PASS.

### Task 5: Register reference assets and verify

**Files:**
- Modify: `pubspec.yaml`
- Modify: `docs/plans/2026-09-02-avatar-asset-pipeline.md`

**Step 1: Register avatar reference assets**

Add the avatar directory to Flutter assets for future bitmap replacements while keeping the runtime renderer independent from unreviewed generated variants.

**Step 2: Run the full quality gate**

Run: `flutter test && flutter analyze`
Expected: all tests pass and analysis reports no errors.

**Step 3: Commit the feature branch**

Run: `git add lib test pubspec.yaml assets/avatars docs/plans && git commit -m "feat: add paper-doll learner avatars"`

