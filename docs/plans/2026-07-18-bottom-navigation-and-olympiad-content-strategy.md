# Bottom Navigation And Olympiad Content Strategy Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the current home-plus-library navigation with a bottom-tab app structure centered on practice, quiz, review, and settings, while aligning content rules to elementary olympiad-style question sourcing.

**Architecture:** Move from a marketing-style landing page to a task-oriented shell with four persistent tabs: `Practice`, `Quiz`, `Review`, and `Settings`. Practice becomes the app entry view and sources questions from the bundled bank without exposing a user-facing library page. In parallel, document a content policy that separates officially sourced olympiad references from app-usable question content so the project can follow Math Kangaroo-style structure without accidentally assuming direct reuse rights.

**Tech Stack:** Flutter `Scaffold` navigation, existing local data services, bundled JSON question packs, Flutter widget tests, docs in `docs/plans/`

### Task 1: Lock the new navigation expectations with failing widget tests

**Files:**
- Modify: `test/widget_test.dart`

**Step 1: Write the failing test**

Add widget coverage that verifies:
- the app shows a persistent bottom navigation with four tabs
- the tabs are `Practice`, `Quiz`, `Review`, and `Settings` in English
- the old library entry point is no longer present on the main shell
- the practice tab is selected on app launch

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because the app still uses the old home screen and library preview layout.

**Step 3: Write minimal implementation**

Add the new shell and tab structure in Tasks 2-4.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS

### Task 2: Introduce the main app shell with bottom navigation

**Files:**
- Modify: `lib/main.dart`

**Step 1: Replace the old home entry**

Refactor `MathSpringHomePage` into a shell that owns the selected tab state and renders:
- `Practice`
- `Quiz`
- `Review`
- `Settings`

**Step 2: Keep page state stable**

Use a simple in-memory tab switch strategy that preserves per-tab state where practical and avoids destructive rebuilds during ordinary navigation.

**Step 3: Remove the old library-first information layout**

The shell should no longer present the landing-page hero, library preview, or browse-library CTA as the primary app surface.

### Task 3: Build the first version of the Practice tab

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Make Practice the default entry tab**

The practice page should show:
- current learner name
- current competition profile label
- one primary `Start Practice` action
- one secondary `Choose Topic` action
- direct topic buttons for the currently available olympiad-style categories, such as `Geometry`, `Arithmetic`, and `Logic`

**Step 2: Keep responsibility narrow**

Do not place learner switching or profile editing here. Practice only starts current-profile practice or topic-filtered practice.

**Step 3: Preserve existing practice flow**

Wire the tab to the current practice session implementation rather than inventing a second practice system.

### Task 4: Reframe quiz, review, and settings around current capabilities

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Quiz tab**

Expose a compact quiz-start surface that uses the current quiz session flow.

**Step 2: Review tab**

Rename history-facing surfaces toward learning review language while still using the existing saved-session infrastructure. Reuse `AnswerHistoryPage` behavior if practical, but shift visible copy from generic history to review-oriented language.

**Step 3: Settings tab**

Move learner/profile management here:
- learner list
- create learner
- delete learner
- current learner selection
- competition-profile display

In this batch, if competition profile editing is not fully implemented yet, expose the current values clearly and structure the page so profile controls can be added next.

### Task 5: Remove user-facing library navigation and preserve internal bank usage

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Remove library entry points from the main shell**

Do not expose `QuestionLibraryPage` from the new navigation.

**Step 2: Keep internal question-bank loading intact**

Practice and quiz should still source questions from the bundled bank.

**Step 3: Avoid deleting useful internal code prematurely**

If the current library page is still useful for temporary internal validation, leave the implementation in code but remove user-facing navigation to it in this batch.

### Task 6: Add olympiad content policy documentation

**Files:**
- Create: `docs/plans/2026-07-18-olympiad-content-policy.md`

**Step 1: Document source tiers**

Describe:
- official competition references
- internally rewritten olympiad-style questions
- future licensed content

**Step 2: Document elementary-first strategy**

State that elementary content should first align to Math Kangaroo-style competition structure and level grouping, with future expansion toward AMC-style content for older learners.

**Step 3: Document rights boundary**

State explicitly that official past papers and official competition problems must not be assumed reusable inside the app without confirming usage rights.

### Task 7: Verify the navigation refactor and content policy changes

**Files:**
- Test: `test/widget_test.dart`
- Test: `test/question_bank_test.dart`
- Create/Modify docs: `docs/plans/2026-07-18-bottom-navigation-and-olympiad-content-strategy.md`
- Create docs: `docs/plans/2026-07-18-olympiad-content-policy.md`

**Step 1: Run targeted widget verification**

Run: `flutter test test/widget_test.dart`
Expected: PASS

**Step 2: Run targeted question-bank verification**

Run: `flutter test test/question_bank_test.dart`
Expected: PASS

**Step 3: Run full regression verification**

Run: `flutter test`
Expected: PASS
