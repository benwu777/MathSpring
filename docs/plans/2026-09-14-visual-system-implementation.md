# Visual System Implementation Plan

> **For Codex:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task.

**Goal:** Give every MathSpring screen a consistent compact, light visual system with teal-blue emphasis and rounded outline icons.

**Architecture:** Put the shared visual tokens and Material component themes in the application theme, then remove local overrides from shared surfaces and primary answer flows. Preserve the existing `LayoutSpec` responsive behavior and validate compact, medium, and expanded layouts with widget tests and simulator screenshots.

**Tech Stack:** Flutter, Material 3, existing `LayoutSpec`, Flutter widget tests.

### Task 1: Establish visual tokens and component themes

**Files:**
- Modify: `lib/main.dart:156-351`
- Test: `test/widget_test.dart`

1. Add a failing widget assertion for the scaffold, card, navigation, and selected-state colours.
2. Run `flutter test test/widget_test.dart` and confirm it fails against the legacy navy theme.
3. Add named colour constants and configure `ColorScheme`, cards, buttons, fields, navigation, chips, dividers, and icon-button defaults around the new system.
4. Re-run the focused test and format the changed file.
5. Commit the foundation separately.

### Task 2: Make shared layout and home surfaces compact

**Files:**
- Modify: `lib/ui/layout_spec.dart:14-179`
- Modify: `lib/main.dart:463-2160`
- Test: `test/layout_spec_test.dart`
- Test: `test/widget_test.dart`

1. Add failing tests for compact shared spacing and the home shell’s non-decorative surface.
2. Reduce layout token spacing where safe without changing minimum tap targets.
3. Replace home glows, gradients, oversized radii, filled navigation icons, and local navy button overrides with themed surfaces and outline icons.
4. Verify focused layout and widget tests.
5. Commit the home-shell pass.

### Task 3: Apply the system to question sessions

**Files:**
- Modify: `lib/main.dart:3303-5100`
- Test: `test/widget_test.dart`

1. Add failing practice and quiz widget assertions for the compact question header, favourite control, and primary action style.
2. Replace local legacy colours, oversized surface decoration, and filled/outline icon mixing in practice and quiz flows.
3. Ensure question headers, answer options, review panels, and bottom actions cannot overflow at compact width.
4. Run focused widget tests, then `flutter test`.
5. Commit the question-flow pass.

### Task 4: Apply the system to profile, analysis, and favourites

**Files:**
- Modify: `lib/main.dart:2647-3302`
- Modify: `lib/widgets/avatar_editor.dart`
- Modify: `lib/widgets/avatar_preview.dart`
- Test: `test/avatar_editor_test.dart`
- Test: `test/avatar_preview_test.dart`

1. Add tests for the shared page header and stable avatar option-cell presentation.
2. Replace page-local styles with theme tokens while preserving avatar asset alignment and identifiers.
3. Apply the same header, compact filtering, and empty-state pattern to analysis and favourites when their screens are available.
4. Run avatar and focused page tests.
5. Commit the account-and-avatar pass.

### Task 5: Verify on device sizes

**Files:**
- Modify only if verification reveals a reproducible overflow.
- Test: all tests under `test/`

1. Run `flutter analyze` and `flutter test`.
2. Launch the app on compact, medium, and expanded simulator devices.
3. Capture screenshots of the home, practice, quiz, profile editor, and favourites screens.
4. Fix any overflow, unreadable contrast, or inconsistent component treatment found during review.
5. Re-run checks and commit verification fixes.
