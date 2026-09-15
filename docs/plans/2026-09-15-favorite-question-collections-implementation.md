# Favorite Question Collections Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a learner-scoped Favorites page with one fixed All Favorites collection, up to five custom collections, tags, notes, and direct reopening of a saved question.

**Architecture:** Extend the existing SQLite favorite repository with queries and mutations for collections and saved questions, then expose those methods from `AppServices`. Keep question data in the bundled bank; the UI resolves saved IDs while loading. Add a review-tab toolbar entry and a stateful page in `main.dart` so navigation remains consistent with the current single-file app UI.

**Tech Stack:** Flutter/Dart, sqflite, existing `FavoriteQuestionRepository`, Flutter widget tests.

### Task 1: Make favorite persistence queryable and keep only one new default collection

**Files:**
- Modify: `lib/data/local/favorite_question_repository.dart`
- Modify: `lib/data/local/app_services.dart`
- Modify: `test/local_database_test.dart`

**Step 1: Write the failing repository tests**

Add tests that assert a new learner receives only `favorites_all_<learnerId>`, saved favorites can be listed by learner or collection, and updating note/tags persists.

**Step 2: Run test to verify it fails**

Run: `flutter test test/local_database_test.dart`
Expected: FAIL because the list/update APIs do not exist and the old default count is two.

**Step 3: Write minimal implementation**

Add favorite list, membership list/removal, and note/tag update methods. Expose a small AppServices API for the page. Preserve existing database rows and do not delete old default collections.

**Step 4: Run test to verify it passes**

Run: `flutter test test/local_database_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/data/local/favorite_question_repository.dart lib/data/local/app_services.dart test/local_database_test.dart
git commit -m "feat: 支援收藏分類與筆記管理"
```

### Task 2: Add Favorites navigation and management interface

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget tests**

Add coverage for the review toolbar bookmark opening the Favorites page, the empty state, and creating a custom collection from the page.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because there is no Favorites page or navigation entry.

**Step 3: Write minimal implementation**

Add localized copy, the review toolbar action, collection selector and management controls, saved-question cards, tag/note editing, and removal actions. Keep the fixed all-collection unremovable.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: 新增我的收藏與自訂書籤頁"
```

### Task 3: Resolve saved IDs and reopen questions safely

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget test**

Add a test that saves a known bundled question, taps it on the Favorites page, and verifies its question view opens.

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart`
Expected: FAIL because saved items have no navigation handler.

**Step 3: Write minimal implementation**

Resolve question IDs from bundled packs during page loading. Open the existing single-question practice/view flow; render unavailable saved IDs as disabled cards with explanatory text.

**Step 4: Run test to verify it passes**

Run: `flutter test test/widget_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: 收藏題目可直接重新開啟"
```

### Task 4: Verify the complete feature

**Files:**
- Modify: none unless verification identifies a defect

**Step 1: Format**

Run: `dart format lib/main.dart lib/data/local/app_services.dart lib/data/local/favorite_question_repository.dart test/local_database_test.dart test/widget_test.dart`

**Step 2: Run focused and complete tests**

Run: `flutter test test/local_database_test.dart test/widget_test.dart && flutter test`
Expected: all tests pass.

**Step 3: Analyze**

Run: `flutter analyze`
Expected: no new errors.

**Step 4: Run macOS visual check**

Run: `flutter build macos --debug`
Expected: debug app builds, then open it and manually verify Favorites entry, empty state, new collection, and direct question opening.

**Step 5: Commit documentation**

```bash
git add docs/plans/2026-09-15-favorite-question-collections-design.md docs/plans/2026-09-15-favorite-question-collections-implementation.md
git commit -m "docs: 補充收藏分類設計與實作計畫"
```
