# Reviewer Avatar Simulator Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Put the complete temporary paper-doll editor in MathSpringReviewer, not in the learner-facing MathSpring app.

**Architecture:** MathSpringReviewer will use the MathSpring package as a local dependency so it renders the same `AvatarEditor`, asset catalog, and image assets as the learner app. A top-level reviewer mode selector keeps question review intact and adds a dedicated paper-doll inspection view with no persistence callbacks.

**Tech Stack:** Flutter, local path package dependency, widget tests.

### Task 1: Expose the shared paper-doll editor to the reviewer

**Files:**
- Modify: `/Users/benwu/sideproject/Flutter/MathSpringReviewer/pubspec.yaml`
- Test: `/Users/benwu/sideproject/Flutter/MathSpringReviewer/test/widget_test.dart`

**Step 1:** Write a widget test that expects the reviewer to show a paper-doll inspection mode and an `AvatarEditor`.

**Step 2:** Run that test and confirm it fails because the mode does not exist.

**Step 3:** Add the `../MathSpring` path dependency so the reviewer can import its editor and assets.

**Step 4:** Run the test and confirm the import is now resolvable but the required mode still fails.

### Task 2: Add the temporary inspection mode

**Files:**
- Modify: `/Users/benwu/sideproject/Flutter/MathSpringReviewer/lib/main.dart`
- Test: `/Users/benwu/sideproject/Flutter/MathSpringReviewer/test/widget_test.dart`

**Step 1:** Add a test selecting the paper-doll mode and asserting the editor and its default girl presentation appear.

**Step 2:** Run it and confirm it fails before implementation.

**Step 3:** Add a reviewer-level mode selector; retain existing question-review loading and place a constrained `AvatarEditor` in the new mode without an `onChanged` callback.

**Step 4:** Run the targeted test and confirm it passes.

### Task 3: Verify reviewer behavior

**Files:**
- Test: `/Users/benwu/sideproject/Flutter/MathSpringReviewer/test/widget_test.dart`

**Step 1:** Run reviewer tests and static analysis.

**Step 2:** Build and open the reviewer app, then visually confirm full paper-doll controls and preview render.
