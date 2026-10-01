# Boy Hair Colours Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give boy avatars the same six selectable hair colours and live tinting as girl avatars.

**Architecture:** Reuse the existing `girl_hair_color_*` identifiers and shared palette for both presentations. Permit those values through `AvatarConfiguration`, expose `hair_color` in the boy option list, apply the catalog tint to boy hair layers, and always show the editor's existing hair-colour step.

**Tech Stack:** Flutter, Dart, widget tests.

### Task 1: Specify the shared colour contract

**Files:**
- Modify: `test/avatar_catalog_test.dart`
- Modify: `test/avatar_preview_test.dart`
- Modify: `test/avatar_editor_test.dart`

**Step 1:** Replace assertions that boy avatars reject hair colours with expectations that the six shared colour IDs persist and resolve.

**Step 2:** Add a preview test expecting a selected boy colour to install the existing front hair tint filter.

**Step 3:** Replace the boy-editor absence test with a test that finds the hair-colour section and all six swatches.

**Step 4:** Run the three focused tests and confirm they fail because boys are currently fixed to deep brown and omit the editor step.

### Task 2: Reuse the girl colour mechanism for boys

**Files:**
- Modify: `lib/models/avatar_configuration.dart`
- Modify: `lib/services/avatar_asset_catalog.dart`
- Modify: `lib/widgets/avatar_editor.dart`

**Step 1:** Add the existing shared colour list to the boy options and permit validated persisted colour IDs for both presentations.

**Step 2:** Resolve the selected shared tint for both avatar presentations.

**Step 3:** Include the existing hair-colour section after hair for boys as well as girls.

**Step 4:** Run focused tests and confirm they pass.

### Task 3: Regression verification and reviewer preview

**Files:**
- Verify: `test/avatar_catalog_test.dart`
- Verify: `test/avatar_preview_test.dart`
- Verify: `test/avatar_editor_test.dart`
- Verify: `test/avatar_visual_matrix_test.dart`

**Step 1:** Run the complete avatar suite.

**Step 2:** Build and open the sibling reviewer app, select boy avatar and a non-default hair colour, and inspect the tint.

**Step 3:** Commit only after visual approval.
