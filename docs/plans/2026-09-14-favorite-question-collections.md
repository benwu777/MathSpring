# Favorite Question Collections Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Let every learner bookmark a question mid-session or after answering, organize it in free local collections, and reopen it quickly from Review.

**Architecture:** Store one learner-scoped favorite record per question and separate collection membership records in SQLite. `AppServices` remains the single data-facing API, with in-memory equivalents for widget tests. The Review tab gains a Favorites entry that opens a responsive collection browser: a selector on phones and a navigation rail-like list on iPad.

**Tech Stack:** Flutter/Dart, sqflite, existing bundled question repository, Material UI, flutter_test.

### Task 1: Add favorite and collection domain persistence

**Files:**
- Create: `lib/models/favorite_question.dart`
- Create: `lib/models/favorite_question_collection.dart`
- Create: `lib/data/local/favorite_question_repository.dart`
- Modify: `lib/data/local/mathspring_database.dart`
- Modify: `test/local_database_test.dart`

**Step 1: Write failing repository tests**

Test a learner can create the default `all` and `discuss` collections; save one favorite with a note and tags; add it to more than one collection; delete a custom collection while preserving the favorite and its `all` membership. Test that a seventh collection is rejected (six total collections, including defaults).

**Step 2: Verify RED**

Run: `flutter test test/local_database_test.dart --plain-name 'favorites'`

Expected: fail because favorite models/repository/tables do not exist.

**Step 3: Implement minimal persistence**

Create `favorite_question_collections` (`id`, `learner_id`, `name`, `sort_order`, `is_default`, `created_at`) and `favorite_questions` (`learner_id`, `question_id`, `note`, `tags_json`, `created_at`, `updated_at`) plus a collection membership table. Upgrade the SQLite schema. Make `all` an implicit/default membership; seed `All favorites` and editable `Discuss` per learner on first favorites access. Cap collections at six and never allow deleting `all`; deleting another collection removes only its membership.

**Step 4: Verify GREEN**

Run: `flutter test test/local_database_test.dart --plain-name 'favorites'`

Expected: PASS.

### Task 2: Expose favorite behavior through AppServices

**Files:**
- Modify: `lib/data/local/app_services.dart`
- Modify: `test/local_database_test.dart`

**Step 1: Write failing service tests**

Test `toggleFavorite`, `isFavorite`, collection creation/rename/delete, note/tag update, filtered fetch, and learner deletion cleanup with `AppServices.forTesting`.

**Step 2: Verify RED**

Run: `flutter test test/local_database_test.dart --plain-name 'favorite service'`

Expected: fail because the service API does not exist.

**Step 3: Implement the service boundary**

Add repository injection and in-memory favorite/collection stores to `AppServices`; initialize default collections lazily per learner. Return favorite summaries ordered by most recently saved, filterable by collection, topic, grade stage, answered state, correct state, and tag. Remove the learner's favorite data when deleting that learner.

**Step 4: Verify GREEN**

Run: `flutter test test/local_database_test.dart --plain-name 'favorite service'`

Expected: PASS.

### Task 3: Add the bookmark control to answer flows

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget tests**

Test the current practice question has an unfilled bookmark button; tapping it saves the question without changing the current question or answer state; tapping again removes it. Test the quiz question likewise saves without advancing or submitting.

**Step 2: Verify RED**

Run: `flutter test test/widget_test.dart --plain-name 'bookmark'`

Expected: fail because no bookmark controls exist.

**Step 3: Implement minimal controls**

Add an accessible bookmark icon in practice and quiz question headers. After saving, present a short confirmation and keep the learner exactly where they were. Reuse the same control on result/history question cards when practical.

**Step 4: Verify GREEN**

Run: `flutter test test/widget_test.dart --plain-name 'bookmark'`

Expected: PASS.

### Task 4: Build the Favorites manager and reopen flow

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Step 1: Write failing widget tests**

Test Review exposes `My Favorites`; an iPhone presents a collection selector, list cards show question metadata/note/tags, and tapping a card opens that exact bundled question. Test creating a collection stops at six, editing a note/tag persists, and deleting a custom collection retains its question in All favorites.

**Step 2: Verify RED**

Run: `flutter test test/widget_test.dart --plain-name 'favorites'`

Expected: fail because the manager UI is absent.

**Step 3: Implement responsive manager UI**

Add `FavoritesPage` from Review. Use a compact dropdown selector on narrow layouts and a left-side list of collections on wide layouts. Offer filters for topic, grade, answer status, correctness, and custom tags. A favorite card opens a read-only question detail page loaded by question ID, showing prompt, figure, answer and the entitlement-appropriate solution section. Add menu actions for add/rename/delete collection and edit note/tags.

**Step 4: Verify GREEN**

Run: `flutter test test/widget_test.dart --plain-name 'favorites'`

Expected: PASS.

### Task 5: Localize, verify, and build

**Files:**
- Modify: `lib/main.dart`
- Modify: relevant tests above

**Step 1: Add all user-facing strings**

Add Traditional Chinese, English, Simplified Chinese, and Japanese strings for favorites, collection actions, note/tag labels, filters, empty states, and limit/error messages through `AppStrings`.

**Step 2: Format and analyze**

Run: `dart format lib/models lib/data/local lib/main.dart test && flutter analyze`

Expected: no analyzer errors.

**Step 3: Run full regression**

Run: `flutter test`

Expected: all tests pass.

**Step 4: Build iOS**

Run: `flutter build ios --debug --no-codesign`

Expected: `Runner.app` builds.
