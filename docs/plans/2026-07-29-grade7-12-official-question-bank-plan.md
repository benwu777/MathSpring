# Grade 7-12 Official Question Bank Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first `grade7` to `grade12` question-bank packs using only official or publicly available competition problems that are rewritten into app-safe wording, with 3 real questions per grade/topic pack and explicit source attribution.

**Architecture:** Keep the existing manifest-driven pack system, but expand it to support a second taxonomy layer for olympiad topics: `algebra`, `geometry`, `number_theory`, `combinatorics`, and `logic`. Preserve existing `grade1` to `grade6` pack routing by adding compatibility metadata rather than replacing the old top-level topics. Seed each `grade7` to `grade12` pack with exactly 3 public-competition rewritten questions, one each for easier / medium / harder competition feel.

**Tech Stack:** Flutter, Dart tests, JSON question packs, manifest-based asset loading, web verification against public competition sources, Ruby helper scripts for batch generation

### Task 1: Add failing tests for grade 7-12 taxonomy and official-source expectations

**Files:**
- Modify: `test/question_bank_test.dart`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add focused tests that expect:
- `assets/questions/algebra/grade7_foundation.algebra.v1.json` to exist in manifest
- pack-level `olympiadTopicCode` / `olympiadTopic`
- question-level `olympiadTaxonomy`
- first imported `grade7` question source type to be `official_reference`
- source fields to include competition name, year, round, and problem number

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'grade7 packs load with olympiad taxonomy metadata'`

Expected: FAIL because the new packs and metadata do not exist yet.

**Step 3: Write minimal implementation**

No production implementation in this task beyond the failing test.

**Step 4: Run test to verify it still fails for the right reason**

Run the same test again.

Expected: FAIL with missing pack / missing metadata, not syntax errors.

**Step 5: Commit**

Do not commit yet.

### Task 2: Add parser support for olympiad taxonomy metadata

**Files:**
- Modify: `lib/models/question.dart`
- Modify: `lib/data/bundled/bundled_question_bank_repository.dart`
- Modify: `test/question_bank_test.dart`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add parser-level assertions for:
- pack info exposing `olympiadTopic` and `olympiadTopicCode`
- `Question` exposing `olympiadTaxonomy.topic`, `.topicCode`, `.subtopic`, `.subtopicCode`

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'parses olympiad taxonomy metadata on packs and questions'`

Expected: FAIL at compile or assertion level because these fields do not exist yet.

**Step 3: Write minimal implementation**

Add nullable parsing fields only. Do not change UI routing yet.

**Step 4: Run test to verify it passes**

Run the same focused test.

Expected: PASS

**Step 5: Commit**

Do not commit yet.

### Task 3: Define official-source intake rules for grade 7-12 packs

**Files:**
- Modify: `docs/official-source-intake.md`
- Modify: `docs/question-bank-expansion-guidelines.md`
- Modify: `docs/question-bank-taxonomy.md`

**Step 1: Write the failing test**

No code test. This is a rules checkpoint before bulk content import.

**Step 2: Verify source policy gaps**

Read and update the docs so they explicitly require:
- public or official source only
- app-safe rewritten wording
- exact source fields: contest, year, round, problem number
- first batch count: 3 questions per `grade7` to `grade12` pack
- difficulty mix: easier / medium / harder

**Step 3: Write minimal implementation**

Document the exact allowed first-batch source families, for example:
- AMC / AIME / Math Kangaroo / AoPS-hosted public archives
- public Chinese-language middle-school / high-school olympiad archives where access is public

**Step 4: Verification**

Re-read the docs and confirm they match the product decision made on July 29, 2026.

**Step 5: Commit**

Do not commit yet.

### Task 4: Create grade 7-12 pack files and manifest entries

**Files:**
- Create: `assets/questions/algebra/grade7_foundation.algebra.v1.json`
- Create: `assets/questions/algebra/grade8_foundation.algebra.v1.json`
- Create: `assets/questions/algebra/grade9_foundation.algebra.v1.json`
- Create: `assets/questions/algebra/grade10_foundation.algebra.v1.json`
- Create: `assets/questions/algebra/grade11_foundation.algebra.v1.json`
- Create: `assets/questions/algebra/grade12_foundation.algebra.v1.json`
- Create: `assets/questions/geometry/grade7_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade8_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade9_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade10_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade11_foundation.geometry.v1.json`
- Create: `assets/questions/geometry/grade12_foundation.geometry.v1.json`
- Create: `assets/questions/number_theory/grade7_foundation.number_theory.v1.json`
- Create: `assets/questions/number_theory/grade8_foundation.number_theory.v1.json`
- Create: `assets/questions/number_theory/grade9_foundation.number_theory.v1.json`
- Create: `assets/questions/number_theory/grade10_foundation.number_theory.v1.json`
- Create: `assets/questions/number_theory/grade11_foundation.number_theory.v1.json`
- Create: `assets/questions/number_theory/grade12_foundation.number_theory.v1.json`
- Create: `assets/questions/combinatorics/grade7_foundation.combinatorics.v1.json`
- Create: `assets/questions/combinatorics/grade8_foundation.combinatorics.v1.json`
- Create: `assets/questions/combinatorics/grade9_foundation.combinatorics.v1.json`
- Create: `assets/questions/combinatorics/grade10_foundation.combinatorics.v1.json`
- Create: `assets/questions/combinatorics/grade11_foundation.combinatorics.v1.json`
- Create: `assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json`
- Create: `assets/questions/logic/grade7_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade8_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade9_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade10_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade11_foundation.logic.v1.json`
- Create: `assets/questions/logic/grade12_foundation.logic.v1.json`
- Modify: `assets/questions/manifest.json`
- Modify: `pubspec.yaml`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Extend the manifest test to expect:
- 30 new packs
- updated manifest count
- `grade7` to `grade12` pack question counts of exactly `3`

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'loads bundled question manifest and pack metadata'`

Expected: FAIL until the new manifest and pack files exist.

**Step 3: Write minimal implementation**

Add all 30 pack files and manifest entries, each with:
- canonical olympiad topic metadata
- 4 language keys
- exactly 3 questions
- no placeholder/demo content
- all sources marked `official_reference`

Also update `pubspec.yaml` to expose the new asset directories.

**Step 4: Run test to verify it passes**

Run the focused manifest test.

Expected: PASS

**Step 5: Commit**

```bash
git add assets/questions pubspec.yaml test/question_bank_test.dart lib/models/question.dart lib/data/bundled/bundled_question_bank_repository.dart
git commit -m "feat: 建立七到十二年級正式題庫骨架"
```

### Task 5: Source and rewrite the first official/public batch

**Files:**
- Modify: `assets/questions/algebra/*.json`
- Modify: `assets/questions/geometry/*.json`
- Modify: `assets/questions/number_theory/*.json`
- Modify: `assets/questions/combinatorics/*.json`
- Modify: `assets/questions/logic/*.json`
- Create: `scripts/append_grade7_12_public_batch_2026_07_29.rb`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add focused assertions for a small representative sample, such as:
- one `grade7 algebra` question from a public contest source
- one `grade10 geometry` question from a public contest source
- one `grade12 number_theory` question from a public contest source

Assertions must verify:
- `source.type == official_reference`
- `source.contest` present
- `source.year` present
- `source.problemNumber` present
- rewritten prompt exists in all four locales

**Step 2: Run test to verify it fails**

Run the focused sample-source test.

Expected: FAIL because the official/public content has not been imported yet.

**Step 3: Write minimal implementation**

Collect and rewrite the first batch:
- 3 questions per pack
- one easier, one medium, one harder
- rewritten wording only
- preserve exact source attribution
- skip figure-heavy questions unless the figure can already be represented cleanly in app

Prefer script-generated intake for repeatability.

**Step 4: Run test to verify it passes**

Run the focused source sample test.

Expected: PASS

**Step 5: Commit**

```bash
git add assets/questions scripts test/question_bank_test.dart
git commit -m "feat: 匯入七到十二年級第一批公開競賽題"
```

### Task 6: Backfill compatibility taxonomy into grade 1-6 packs

**Files:**
- Modify: `assets/questions/arithmetic/*.json`
- Modify: `assets/questions/geometry/*.json`
- Modify: `assets/questions/logic/*.json`
- Modify: `docs/question-bank-taxonomy.md`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add assertions proving old packs now include `olympiadTaxonomy` compatibility metadata on representative questions.

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'legacy packs expose olympiad taxonomy compatibility metadata'`

Expected: FAIL because the old packs do not yet contain the mapping field.

**Step 3: Write minimal implementation**

Backfill compatibility metadata only. Do not rename old folders or old `topicCode`.

**Step 4: Run test to verify it passes**

Run the focused compatibility test.

Expected: PASS

**Step 5: Commit**

```bash
git add assets/questions docs/question-bank-taxonomy.md test/question_bank_test.dart
git commit -m "feat: 補齊舊題庫奧數分類相容欄位"
```

### Task 7: Keep loading and launch flows stable with the expanded manifest

**Files:**
- Modify: `lib/services/session_launch_plan_builder.dart`
- Modify: `lib/main.dart`
- Modify: `test/session_launch_plan_test.dart`

**Step 1: Write the failing test**

Add a test confirming:
- expanded manifest does not break existing `grade1` to `grade6` launch flows
- the current app can ignore `grade7` to `grade12` packs until the new range UI is implemented

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart`

Expected: FAIL only if loading assumptions are hard-coded.

**Step 3: Write minimal implementation**

Relax any hard-coded assumptions around topic folders, count, or grade ceiling.

**Step 4: Run test to verify it passes**

Run the same session launch test.

Expected: PASS

**Step 5: Commit**

```bash
git add lib/main.dart lib/services/session_launch_plan_builder.dart test/session_launch_plan_test.dart
git commit -m "fix: 相容擴充後題庫與啟動流程"
```

### Task 8: Full verification and batch review checkpoint

**Files:**
- Test: `test/question_bank_test.dart`
- Test: `test/session_launch_plan_test.dart`
- Test: `test/question_bank_duplicate_audit_test.dart`
- Run: `dart run tool/question_bank_duplicate_audit.dart`

**Step 1: Run the full verification suite**

Run:
- `flutter test test/question_bank_test.dart`
- `flutter test test/session_launch_plan_test.dart`
- `flutter test test/question_bank_duplicate_audit_test.dart`
- `dart run tool/question_bank_duplicate_audit.dart`

**Step 2: Review outputs**

Check especially for:
- duplicated reskins in the new `grade7` to `grade12` packs
- broken manifest counts
- any asset-loading failures from the new topic folders

**Step 3: Fix only verification regressions**

Do not widen scope beyond what the failures require.

**Step 4: Re-run the same suite**

Expected: all green

**Step 5: Commit**

```bash
git add .
git commit -m "test: 驗證七到十二年級題庫首批匯入"
```
