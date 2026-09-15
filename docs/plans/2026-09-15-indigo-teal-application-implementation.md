# Indigo Teal Application Visual System Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Apply a consistent indigo-primary and teal-progress visual system to every MathSpring surface.

**Architecture:** Extend `AppVisualTokens` with explicit brand, progress, surface and outline roles, then wire those roles through the Material theme. Replace high-visibility legacy blue and gray local overrides on primary app surfaces with the shared tokens while retaining semantic error/success feedback and responsive layout behavior.

**Tech Stack:** Flutter/Dart, Material 3, existing widget tests and macOS debug build.

### Task 1: Establish dual-color theme tokens

**Files:**
- Modify: `lib/main.dart:36-390`
- Test: `test/widget_test.dart`

**Step 1:** Add a failing test for indigo primary and teal selected/progress tokens.

**Step 2:** Run `flutter test test/widget_test.dart --plain-name "application visual tokens use indigo primary and teal progress"` and confirm failure.

**Step 3:** Add `brand`, `brandSoft`, `progress`, `progressSoft`, neutral surface and outline tokens; map Material buttons, navigation, fields, cards, chips and icons to them.

**Step 4:** Re-run the focused test and commit `style: 建立深靛藍與青綠全站色彩系統`.

### Task 2: Replace primary-flow local overrides

**Files:**
- Modify: `lib/main.dart` homepage, practice, quiz, review, settings, result and collection surfaces
- Test: `test/widget_test.dart`

**Step 1:** Add focused widget assertions for navigation selection, primary actions and question selection states.

**Step 2:** Run the focused tests and confirm failures on legacy colors.

**Step 3:** Replace local legacy navy, pure blue and inconsistent gray styling with shared tokens; preserve red for destructive/error and teal for positive progress.

**Step 4:** Run focused tests and commit `style: 統一主要流程的雙主色視覺層次`.

### Task 3: Finish and refine favorites management

**Files:**
- Modify: `lib/data/local/app_services.dart`
- Modify: `lib/data/local/favorite_question_repository.dart`
- Modify: `lib/main.dart`
- Test: `test/local_database_test.dart`, `test/widget_test.dart`

**Step 1:** Add failing tests for managing collections and direct question reopen.

**Step 2:** Implement collection membership, note/tag editing, removal and refined question-first cards using the shared visual tokens.

**Step 3:** Run focused tests and commit `feat: 完成收藏題目管理流程`.

### Task 4: Verify visuals and integration

**Files:**
- Modify: none unless verification identifies a defect

**Step 1:** Run `dart format lib/main.dart lib/data/local/app_services.dart lib/data/local/favorite_question_repository.dart test/local_database_test.dart test/widget_test.dart`.

**Step 2:** Run `flutter test` and `flutter analyze`; resolve new diagnostics.

**Step 3:** Run `flutter build macos --debug`, open the built app, and inspect home, answer, review, settings, avatar and favorites at narrow and desktop widths.

**Step 4:** Commit docs and verified changes, then follow `superpowers:finishing-a-development-branch` to merge into `develop`.
