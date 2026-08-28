# Kangaroo 5–6 Legacy Pack Rewrite Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the 29 excluded legacy questions with distinct, source-traceable grade 5–6 questions that can safely enter the question bank.

**Architecture:** Retain the pack and its IDs so manifest references remain stable. Replace every question body, answer, solution, source metadata, and—where needed—figure with a new question that does not duplicate any approved pack. Add explicit review status only after a full cross-pack audit.

**Tech Stack:** JSON question packs, Dart/Flutter question-bank tests, duplicate-audit tooling.

### Task 1: Establish the replacement inventory

**Files:**
- Modify: `docs/question-review-kangaroo56-audit.md`
- Read: `docs/question-bank-expansion-guidelines.md`
- Read: `assets/questions/**/*.json`

1. For each legacy ID, record its closest approved duplicate and the replacement concept.
2. Select a unique, grade-appropriate topic and a traceable source/reference for each replacement.
3. Ensure no replacement is a numeric or narrative variation of an approved question.

### Task 2: Replace questions in small reviewed batches

**Files:**
- Modify: `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json`
- Modify: `docs/question-review-kangaroo56-audit.md`

1. Replace questions 001–010 with complete four-language prompt, answer, solution, source, and valid schema fields.
2. Independently recompute each answer and record the check in the audit document.
3. Repeat for 011–020, then 021–029.
4. Add `reviewStatus: ok` only to questions that pass the source, uniqueness, correctness, and figure checks.

### Task 3: Verify release readiness

**Files:**
- Test: `test/question_bank_test.dart`
- Test: `test/question_bank_duplicate_audit_test.dart`

1. Parse every edited JSON pack and assert all 29 questions have explicit `reviewStatus: ok`.
2. Run the duplicate audit and resolve every new actionable duplicate finding.
3. Run `flutter test test/question_bank_test.dart test/question_bank_duplicate_audit_test.dart`.
4. Run `git diff --check` and update the audit document with final evidence.
