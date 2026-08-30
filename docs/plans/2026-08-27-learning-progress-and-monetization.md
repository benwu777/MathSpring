# Learning Progress And Monetization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Give each learner a calendar-based answer history and meaningful progress achievements, remove Olympiad wording from public-facing copy, and prepare safe seams for future iCloud sync and ad-removal purchases.

**Architecture:** Derive calendar days, streaks, topic milestones, and wrong-answer recovery milestones from the immutable answer-session records already stored locally. Keep the new calculations in a pure Dart service so UI rendering and eventual CloudKit import/export use the same rules. Present those derived values in the existing Review tab and keep third-party monetization and CloudKit adapters disabled until real Apple/advertising account configuration exists.

**Tech Stack:** Flutter/Dart, sqflite persistence already in the app, Flutter widget tests, no new runtime SDKs in this milestone.

### Task 1: Add tested learning-history summaries

**Files:**
- Create: `lib/services/learning_activity_summary.dart`
- Create: `test/learning_activity_summary_test.dart`
- Modify: `lib/data/local/app_services.dart:250-290`
- Test: `test/local_database_test.dart`

**Step 1: Write the failing unit tests**

Create sessions and answer records across multiple local calendar days. Assert that a summary groups question count and correct count by the learner's local day, calculates the current and longest consecutive-day streak, awards topic thresholds at 20/50/100 answered questions, and only counts a recovery when a question previously answered incorrectly is later answered correctly.

**Step 2: Run the focused tests to verify RED**

Run: `flutter test test/learning_activity_summary_test.dart`

Expected: FAIL because `LearningActivitySummary` and its API do not exist.

**Step 3: Implement the minimal pure-Dart summary API**

Add immutable summary value types and `LearningActivitySummary.fromSessions(...)`. Sort answer records by `answeredAtIso`; count every recorded answer for the session topic, and maintain a per-question previous-result map to count wrong-to-correct recoveries once. Convert ISO timestamps to local dates for calendar grouping and streaks.

**Step 4: Expose learner history through AppServices**

Add `getLearnerLearningActivitySummary(learnerId)`, loading the learner's sessions and their records through the existing repository or test in-memory stores. Do not change the SQLite schema.

**Step 5: Run focused tests to verify GREEN**

Run: `flutter test test/learning_activity_summary_test.dart test/local_database_test.dart`

Expected: PASS.

**Step 6: Commit the tested domain layer**

```bash
git add lib/services/learning_activity_summary.dart lib/data/local/app_services.dart test/learning_activity_summary_test.dart test/local_database_test.dart
git commit -m "feat: derive learner activity achievements"
```

### Task 2: Build the calendar and achievement review experience

**Files:**
- Modify: `lib/main.dart:_ReviewTab`, `lib/main.dart:AnswerHistoryPage`, and `lib/main.dart:AppStrings`
- Modify: `test/widget_test.dart`

**Step 1: Write the failing widget tests**

Add seeded sessions and records to test services. Assert the Review tab shows an achievement section, the selected month calendar marks a practiced date with count and accuracy, and tapping that date shows its sessions and can open the existing answer-detail page.

**Step 2: Run the focused widget test to verify RED**

Run: `flutter test test/widget_test.dart --name "review"`

Expected: FAIL because the calendar/achievement controls are absent.

**Step 3: Implement minimal review UI**

Replace the review preview with an asynchronous learner-activity screen. Render a dependency-free monthly calendar grid, one selected-day summary, topic achievement rows (20/50/100: Newcomer, Familiar, Master equivalents in every supported locale), recovery achievements (10/50/100: `重整旗鼓`, `重新上手`, `百折不撓` in Traditional Chinese), and current/best streak. Reuse `SessionDetailPage` for answer-level history.

**Step 4: Add all four locale strings**

Add Traditional Chinese, Simplified Chinese, English, and Japanese strings for every visible calendar, achievement, streak, count, and empty-state label. Keep copy clear and non-competitive.

**Step 5: Run focused widget tests to verify GREEN**

Run: `flutter test test/widget_test.dart`

Expected: PASS.

**Step 6: Commit the review UI**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: add calendar learning history"
```

### Task 3: Remove public Olympiad/奧數 product wording

**Files:**
- Modify: `lib/main.dart:AppStrings`
- Modify: `docs/site/index.html`
- Modify: `docs/app-store-metadata-zh-Hant.md`
- Modify: affected public release docs found by targeted search
- Test: `test/widget_test.dart`

**Step 1: Write the failing copy assertion**

Assert the home screen renders the new mathematical-thinking tagline and no longer renders the old Traditional-Chinese public phrase.

**Step 2: Run the focused test to verify RED**

Run: `flutter test test/widget_test.dart --name "tagline"`

Expected: FAIL because the old copy is still present.

**Step 3: Replace only public-facing copy**

Use `數學思維／進階數學練習` and locale-equivalent wording in application, support site, and App Store metadata. Preserve internal model names, research taxonomy, historical plans, and question-bank editorial documents so source compatibility and audit trail remain intact.

**Step 4: Run focused copy/widget tests to verify GREEN**

Run: `flutter test test/widget_test.dart`

Expected: PASS.

**Step 5: Commit public copy changes**

```bash
git add lib/main.dart docs/site/index.html docs/app-store-metadata-zh-Hant.md test/widget_test.dart
git commit -m "feat: refresh public math learning copy"
```

### Task 4: Add honest sync and monetization foundations

**Files:**
- Create: `lib/services/learning_data_snapshot.dart`
- Create: `lib/services/monetization_service.dart`
- Create: `docs/icloud-sync-handoff.md`
- Create: `docs/monetization-handoff.md`
- Create: `test/learning_data_snapshot_test.dart`

**Step 1: Write failing snapshot merge tests**

Create two offline snapshots containing different answer sessions and conflicting mutable progress records. Assert that merging unions distinct immutable answer records and selects the record with the latest update timestamp for identical mutable progress keys.

**Step 2: Run snapshot tests to verify RED**

Run: `flutter test test/learning_data_snapshot_test.dart`

Expected: FAIL because the serializable snapshot and merge API do not exist.

**Step 3: Implement pure snapshot and monetization contracts**

Add a JSON-safe learning-data snapshot with a deterministic merge function. Add a `MonetizationService` interface whose default status is `notConfigured`; it must not display a fake advertisement, make a fake purchase, or claim entitlement. Keep UI space at zero when no real configured banner adapter exists.

**Step 4: Document external configuration boundaries**

Document exact follow-up work: Apple Developer membership, a real CloudKit container/capability and entitlement, CloudKit adapter and conflict handling; separately, AdMob account/app unit/test ads, privacy disclosures, StoreKit product ID, App Store Connect agreement/tax/banking, restore-purchase flow, and production validation. State clearly that these external adapters are not operational in this milestone.

**Step 5: Run snapshot tests to verify GREEN**

Run: `flutter test test/learning_data_snapshot_test.dart`

Expected: PASS.

**Step 6: Commit foundations and handoff docs**

```bash
git add lib/services/learning_data_snapshot.dart lib/services/monetization_service.dart docs/icloud-sync-handoff.md docs/monetization-handoff.md test/learning_data_snapshot_test.dart
git commit -m "feat: prepare sync and monetization handoff"
```

### Task 5: Full verification and review

**Files:**
- Verify all files changed by Tasks 1-4

**Step 1: Run formatting**

Run: `dart format lib/services lib/data/local/app_services.dart lib/main.dart test/learning_activity_summary_test.dart test/learning_data_snapshot_test.dart test/widget_test.dart`

**Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`

**Step 3: Run complete tests**

Run: `flutter test`

Expected: all tests pass.

**Step 4: Inspect the final isolated branch**

Run: `git status --short` and `git log --oneline feature/app-store-readiness..HEAD`

Expected: only this feature's files changed, in clear commits, ready for review/merge.
