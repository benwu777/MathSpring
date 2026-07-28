# MathSpring Duplicate Review Ledger

> Audit date: 2026-07-28
> Scope: all bundled question packs under `assets/questions/`
> Source scan: [question-bank-duplicate-audit-2026-07-28.json](/Users/benwu/sideproject/Flutter/MathSpring/docs/question-bank-duplicate-audit-2026-07-28.json)
> Tool: [tool/question_bank_duplicate_audit.dart](/Users/benwu/sideproject/Flutter/MathSpring/tool/question_bank_duplicate_audit.dart)

Update:

- The audit tool now scans **manifest-listed shipped packs only** by default.
- Legacy `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json` is no longer part of duplicate-risk scoring because it is not bundled in `manifest.json`.

## Purpose

This ledger tracks duplicate-risk review in a way that can be continued across sessions.

The standard is strict:

- A valid new question must be a **completely different question**
- Not a number swap
- Not a story reskin
- Not a moved target quantity
- Not the same solution skeleton in a different wrapper

## Status Labels

- `exact_duplicate`: prompt text is identical or effectively identical
- `likely_reskin`: very high risk same skeleton; needs rewrite or merge decision
- `family_cluster`: broad same-family grouping; review manually before acting
- `acceptable_variant`: reviewed and allowed to coexist
- `corrected`: rewritten already

## Review Order

Review in this order each time:

1. High-confidence 2-item or 3-item reskins in risky subtopics:
   `work_backwards`, `balance_transfer`, `age_problem`, `angle_ratio`,
   `angle_sum_polygon`, `triangle_angles`, `trapezoid_area`, `state_tracking`
2. Lower-grade arithmetic (`grade1` to `grade3`)
3. Lower-grade geometry (`grade1` to `grade3`)
4. Logic packs
5. Broad family clusters that may contain false positives but still indicate overuse

## Current Snapshot

- Total scanned questions: `832`
- Candidate groups flagged by heuristic: `47`
- Exact-duplicate groups: `0`

Current interpretation:

- The previously reported 24 exact duplicates were legacy overlap between split
  mixed packs and the unbundled `kangaroo56` file. After manifest-scoped auditing,
  those are removed from active shipped-pack review.
- The heuristic was tightened twice on 2026-07-28: structure tags now distinguish
  arrangement constraints, ordering query types, matching/cardinality cases,
  coordinate families, translation variants, truth-statement families, and several
  geometry area/perimeter structures more accurately.
- A sixth rewrite pass replaced 11 weak same-skeleton questions directly in the
  shipped packs, an eighth pass replaced 10 more, a ninth pass replaced 10
  additional same-shell questions, and three final cleanup passes replaced 22
  more across arithmetic, geometry, and logic packs. Later heuristic
  refinements also split several broad logic and geometry families more
  accurately. The drop from `118` to `47` groups is
  therefore a mix of:
  genuine content cleanup, better structural classification, and removal of false
  positives that were previously merged under under-specified fingerprints.
- The broadest remaining queue is now much narrower. The current largest active
  content risk is still `geometry/perimeter_area`, followed by cross-grade
  arithmetic shells such as `inclusion_exclusion`, `multi_step`,
  `number_line`, `page_numbering`, and residual logic families such as
  `grid_elimination`, `grouping_balance`, `pigeonhole`, and `position`.

## Exact Duplicates

Status: no exact duplicates remain in manifest-listed shipped packs.

Historical note:

- Those 24 pairs were not independently rewritten yet.
- They were removed from active audit scope because they belong to the old,
  unbundled `kangaroo56` aggregate pack rather than current shipped content.

## High-Confidence Reskin Candidates

These are not always literal duplicates, but they are strong same-skeleton suspects.

| Status | Topic | Subtopic | Question IDs | Note |
| --- | --- | --- | --- | --- |
| `likely_reskin` | geometry | border_counting | `geometry_grade2_foundation_040`, `geometry_grade3_foundation_033` | Same rectangular border-counting family with only counts swapped |
| `likely_reskin` | logic | grid_elimination | `logic_grade2_foundation_008`, `logic_grade5_foundation_025`, `logic_grade5_foundation_027`, `logic_grade5_foundation_029` | Same grid-style elimination family with richer surface data |
| `likely_reskin` | logic | grouping_balance | `logic_grade6_foundation_027`, `logic_grade6_foundation_031` | Both remain partition-by-total-balance deduction shells |
| `likely_reskin` | arithmetic | inclusion_exclusion | `arithmetic_grade3_foundation_001`, `arithmetic_grade5_foundation_012`, `arithmetic_grade6_foundation_012` | Same direct union-count formula family |
| `likely_reskin` | arithmetic | number_line | `arithmetic_grade1_foundation_028`, `arithmetic_grade2_foundation_031`, `arithmetic_grade3_foundation_025`, `arithmetic_grade4_foundation_030` | Same forward-backward jump structure |

## Broad Family Clusters

These groups are too broad to auto-delete, but they show where uniqueness review should focus.

| Status | Topic | Subtopic | Count |
| --- | --- | --- | --- |
| `family_cluster` | geometry | perimeter_area | 4 |
| `family_cluster` | arithmetic | route_counting | 2 |
| `family_cluster` | geometry | scale_factor | 2 |
| `family_cluster` | arithmetic | inclusion_exclusion | 2 |
| `family_cluster` | logic | pigeonhole | 2 |
| `family_cluster` | geometry | shape_cutting | 2 |
| `family_cluster` | logic | position | 2 |
| `family_cluster` | geometry | position_direction | 2 |
| `family_cluster` | logic | truth_deduction | 2 |
| `family_cluster` | logic | ranking | 2 |
| `family_cluster` | logic | pattern | 2 |
| `family_cluster` | arithmetic | pair_counting | 1 |
| `family_cluster` | arithmetic | parity_counting | 1 |

## Already Corrected In This Audit Cycle

These IDs were rewritten in the current 2026-07-28 cleanup passes and should be treated as reviewed.

### First Pass

- `arithmetic_grade1_foundation_026`
- `arithmetic_grade1_foundation_037`
- `arithmetic_grade2_foundation_023`
- `arithmetic_grade2_foundation_042`
- `arithmetic_grade3_foundation_028`
- `arithmetic_grade3_foundation_035`
- `geometry_grade3_foundation_028`
- `geometry_grade3_foundation_030`
- `logic_grade4_foundation_020`
- `mixed_grade5_foundation_001`

### Second Pass

- `arithmetic_grade1_foundation_021`
- `arithmetic_grade1_foundation_029`
- `arithmetic_grade2_foundation_026`
- `arithmetic_grade2_foundation_043`
- `arithmetic_grade2_foundation_048`
- `arithmetic_grade2_foundation_050`
- `arithmetic_grade3_foundation_016`
- `arithmetic_grade3_foundation_029`
- `arithmetic_grade3_foundation_051`
- `arithmetic_grade4_foundation_029`
- `arithmetic_grade4_foundation_035`
- `arithmetic_grade4_foundation_037`
- `arithmetic_grade4_foundation_046`
- `arithmetic_grade4_foundation_049`
- `arithmetic_grade5_foundation_007`
- `arithmetic_grade6_foundation_032`
- `geometry_grade3_foundation_003`
- `geometry_grade3_foundation_008`
- `geometry_grade3_foundation_010`
- `geometry_grade3_foundation_022`
- `geometry_grade3_foundation_038`
- `logic_grade1_foundation_022`
- `logic_grade2_foundation_022`
- `logic_grade3_foundation_022`
- `logic_grade5_foundation_020`
- `logic_grade6_foundation_023`

### Third Pass

- `geometry_grade5_foundation_018`
- `geometry_grade6_foundation_001`
- `geometry_grade6_foundation_009`
- `geometry_grade6_foundation_024`
- `arithmetic_grade5_foundation_023`
- `arithmetic_grade6_foundation_022`
- `arithmetic_grade6_foundation_026`
- `arithmetic_grade1_foundation_004`
- `arithmetic_grade5_foundation_008`
- `arithmetic_grade6_foundation_008`
- `geometry_grade5_foundation_011`
- `geometry_grade5_foundation_015`
- `geometry_grade5_foundation_025`
- `geometry_grade5_foundation_027`
- `geometry_grade5_foundation_028`
- `geometry_grade5_foundation_030`
- `geometry_grade5_foundation_032`
- `geometry_grade5_foundation_036`
- `arithmetic_grade1_foundation_002`
- `arithmetic_grade2_foundation_005`
- `arithmetic_grade4_foundation_008`

### Fourth Pass

- `arithmetic_grade2_foundation_006`
- `arithmetic_grade4_foundation_007`
- `arithmetic_grade4_foundation_044`

### Fifth Pass

- `arithmetic_grade4_foundation_007`
- `arithmetic_grade6_foundation_008`

### Sixth Pass

- `arithmetic_grade1_foundation_040`
- `arithmetic_grade4_foundation_009`
- `arithmetic_grade4_foundation_032`
- `arithmetic_grade5_foundation_010`
- `geometry_grade3_foundation_016`
- `geometry_grade3_foundation_026`
- `geometry_grade4_foundation_013`
- `geometry_grade4_foundation_021`
- `geometry_grade5_foundation_012`
- `logic_grade2_foundation_010`
- `logic_grade6_foundation_011`

### Eighth Pass

- `geometry_grade2_foundation_022`
- `geometry_grade4_foundation_001`
- `geometry_grade4_foundation_024`
- `geometry_grade4_foundation_036`
- `logic_grade2_foundation_015`
- `logic_grade3_foundation_020`
- `logic_grade5_foundation_018`
- `logic_grade6_foundation_021`
- `logic_grade2_foundation_013`
- `logic_grade5_foundation_021`

### Ninth Pass

- `arithmetic_grade1_foundation_043`
- `arithmetic_grade2_foundation_003`
- `arithmetic_grade3_foundation_021`
- `geometry_grade5_foundation_005`
- `logic_grade2_foundation_018`
- `logic_grade3_foundation_015`
- `logic_grade4_foundation_013`
- `logic_grade4_foundation_021`
- `logic_grade5_foundation_013`
- `logic_grade6_foundation_016`

### Tenth Pass

- `arithmetic_grade1_foundation_040`
- `arithmetic_grade2_foundation_003`
- `arithmetic_grade2_foundation_004`
- `arithmetic_grade4_foundation_010`
- `arithmetic_grade4_foundation_018`
- `arithmetic_grade5_foundation_027`
- `arithmetic_grade5_foundation_028`
- `geometry_grade1_foundation_023`
- `geometry_grade5_foundation_007`
- `geometry_grade5_foundation_014`
- `logic_grade4_foundation_004`
- `logic_grade5_foundation_016`

### Eleventh Pass

- `arithmetic_grade1_foundation_018`
- `arithmetic_grade1_foundation_039`
- `arithmetic_grade2_foundation_012`
- `arithmetic_grade3_foundation_034`
- `arithmetic_grade4_foundation_026`
- `logic_grade5_foundation_001`

### Twelfth Pass

- `arithmetic_grade3_foundation_015`
- `arithmetic_grade3_foundation_010`
- `arithmetic_grade5_foundation_028`
- `arithmetic_grade3_foundation_036`
- `arithmetic_grade4_foundation_026`
- `logic_grade6_foundation_015`

## Next Actions

1. Review the remaining `geometry/perimeter_area` family carefully; this is still the largest active cluster.
2. Prioritize the current top arithmetic shells next: `inclusion_exclusion`, `multi_step`, `number_line`, `page_numbering`, `overlap_counting`.
3. Review residual logic families next: `grid_elimination`, `grouping_balance`, `pigeonhole`, `position`, `truth_deduction`, `ranking`.
4. Add more structure tags only when a cluster is demonstrably a false positive family rather than real duplicate risk.
5. After each rewrite or rule refinement, rerun:

```bash
dart run tool/question_bank_duplicate_audit.dart > docs/question-bank-duplicate-audit-2026-07-28.json
flutter test test/question_bank_duplicate_audit_test.dart test/question_bank_test.dart
```

6. When a candidate is reviewed, mark it explicitly as:
   `acceptable_variant` / `corrected` / `merged-away`
