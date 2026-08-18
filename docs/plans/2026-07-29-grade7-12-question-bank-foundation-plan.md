# Grade 7-12 Question Bank Foundation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first working `grade7` to `grade12` question-bank foundation with new olympiad topic codes, compatibility metadata for `grade1` to `grade6`, and 5 demo questions per grade/topic pack.

**Architecture:** Keep the existing pack-per-grade-per-topic JSON model and manifest-driven loading flow. Add a second-layer taxonomy for all packs, while preserving current `grade1` to `grade6` UI behavior by storing compatibility metadata instead of replacing existing topic codes. Seed `grade7` to `grade12` with small but structurally correct packs so filtering, intake, and future official expansion can build on stable files.

**Tech Stack:** Flutter, Dart tests, JSON question packs, Ruby helper scripts, manifest-based repository loading

### Task 1: Audit the current pack schema and taxonomy touchpoints

**Files:**
- Read: `assets/questions/manifest.json`
- Read: `assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json`
- Read: `lib/models/question.dart`
- Read: `lib/main.dart`
- Read: `docs/question-bank-taxonomy.md`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add a new test block in `test/question_bank_test.dart` that expects:
- `grade7_foundation.algebra.v1.json` to load from manifest
- topic code metadata for a grade 7 pack to be `algebra`
- a compatibility mapping field to exist on one legacy `grade1` to `grade6` question

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'grade7 packs load with olympiad taxonomy metadata'`

Expected: FAIL because the new pack and metadata do not exist yet.

**Step 3: Write minimal implementation**

Identify the exact schema additions needed:
- pack-level display topic vs canonical olympiad topic
- question-level compatibility field for old packs
- manifest entries for new grade 7+ packs

Document the chosen field names before editing production data.

**Step 4: Run test to verify it still fails for the right reason**

Run the same test again.

Expected: FAIL with missing files or missing metadata, not syntax errors.

**Step 5: Commit**

Do not commit yet. Batch commit after Tasks 3 or 4.

### Task 2: Add taxonomy metadata support to existing parsing

**Files:**
- Modify: `lib/models/question.dart`
- Modify: `test/question_bank_test.dart`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Extend the new test to assert parsed access for:
- canonical olympiad topic code
- canonical olympiad topic display label
- legacy compatibility topic for `grade1` to `grade6`

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'grade7 packs load with olympiad taxonomy metadata'`

Expected: FAIL because the parser does not expose the new fields yet.

**Step 3: Write minimal implementation**

Update parsing models with nullable fields only:
- pack-level canonical topic metadata
- question-level taxonomy compatibility metadata

Do not refactor UI routing in this task.

**Step 4: Run test to verify it passes**

Run the same focused test.

Expected: It still fails, but only because JSON data is not present yet.

**Step 5: Commit**

Do not commit yet.

### Task 3: Create grade 7-12 pack files and manifest entries

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
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Assert manifest counts and loadability for at least:
- `grade7_foundation.algebra.v1.json`
- `grade12_foundation.logic.v1.json`

**Step 2: Run test to verify it fails**

Run the focused test again.

Expected: FAIL because files and manifest entries are absent.

**Step 3: Write minimal implementation**

Create all 30 pack files with:
- topic code
- canonical olympiad topic metadata
- `foundation` tier
- `zh-Hant`, `zh-Hans`, `en`, `ja`
- exactly 5 demo questions per pack

Each demo question must include:
- prompt
- answer
- solution steps
- answer mode
- correct answer
- source marker like `internal_demo`

**Step 4: Run test to verify it passes**

Run: `flutter test test/question_bank_test.dart --plain-name 'grade7 packs load with olympiad taxonomy metadata'`

Expected: PASS

**Step 5: Commit**

```bash
git add assets/questions test/question_bank_test.dart lib/models/question.dart
git commit -m "feat: 建立七到十二年級奧數題庫骨架"
```

### Task 4: Backfill canonical taxonomy mapping into grade 1-6 packs

**Files:**
- Modify: `assets/questions/arithmetic/*.json`
- Modify: `assets/questions/geometry/*.json`
- Modify: `assets/questions/logic/*.json`
- Modify: `docs/question-bank-taxonomy.md`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add assertions for one legacy question from each old top-level topic to confirm it now contains:
- canonical olympiad topic code
- canonical olympiad subtopic or mapping field

**Step 2: Run test to verify it fails**

Run: `flutter test test/question_bank_test.dart --plain-name 'legacy packs expose olympiad taxonomy compatibility metadata'`

Expected: FAIL because the new fields are missing from old data.

**Step 3: Write minimal implementation**

Backfill only the new compatibility fields. Do not rename old topic codes or file paths.

Suggested mapping:
- arithmetic → algebra / number_theory / combinatorics by subtopic
- geometry → geometry
- logic → logic / combinatorics depending on structure

Prefer scripted edits over manual repetition.

**Step 4: Run test to verify it passes**

Run the focused compatibility test.

Expected: PASS

**Step 5: Commit**

```bash
git add assets/questions docs/question-bank-taxonomy.md test/question_bank_test.dart
git commit -m "feat: 補齊舊題庫奧數分類對應欄位"
```

### Task 5: Keep mixed-launch and pack-loading flows stable

**Files:**
- Modify: `lib/services/session_launch_plan_builder.dart`
- Modify: `lib/main.dart`
- Test: `test/session_launch_plan_test.dart`
- Test: `test/question_bank_test.dart`

**Step 1: Write the failing test**

Add a focused test asserting the launch builder:
- still resolves legacy `grade1` to `grade6` flows unchanged
- ignores `grade7` to `grade12` only when no UI path selects them yet
- does not crash on the expanded manifest

**Step 2: Run test to verify it fails**

Run: `flutter test test/session_launch_plan_test.dart`

Expected: FAIL if manifest assumptions are hard-coded.

**Step 3: Write minimal implementation**

Relax any hard-coded assumptions tied to the old three-topic world. Do not implement the new 1-12 slider UI yet.

**Step 4: Run test to verify it passes**

Run: `flutter test test/session_launch_plan_test.dart`

Expected: PASS

**Step 5: Commit**

```bash
git add lib/main.dart lib/services/session_launch_plan_builder.dart test/session_launch_plan_test.dart
git commit -m "fix: 相容擴充後題庫清單與啟動流程"
```

### Task 6: Full verification and handoff docs

**Files:**
- Modify: `docs/question-bank-expansion-guidelines.md`
- Modify: `docs/AGENT_PROMPT_question_bank.md`
- Test: `test/question_bank_test.dart`
- Test: `test/session_launch_plan_test.dart`
- Test: `test/question_bank_duplicate_audit_test.dart`

**Step 1: Write the failing test**

No new product test. This task is verification and documentation only.

**Step 2: Run tests and audits**

Run:
- `flutter test test/question_bank_test.dart`
- `flutter test test/session_launch_plan_test.dart`
- `flutter test test/question_bank_duplicate_audit_test.dart`
- `dart run tool/question_bank_duplicate_audit.dart`

Expected: all pass; duplicate audit output is reviewed for obvious bad demo reskins.

**Step 3: Write minimal implementation**

Update docs to describe:
- the new `grade7` to `grade12` topic system
- the compatibility mapping strategy for `grade1` to `grade6`
- demo vs official question status

**Step 4: Run tests again**

Re-run the same commands after doc or data cleanup if needed.

**Step 5: Commit**

```bash
git add docs test
git commit -m "docs: 記錄七到十二年級題庫骨架規格"
```
