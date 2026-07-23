# MathSpring Question Bank Audit

> Audit date: 2026-07-23
> Scope: bundled `arithmetic`, `geometry`, `logic` packs for `grade1` to `grade6`

## Goal

This document records the current question-bank distribution, repeated-pattern
risk, and content-priority gaps after the recent arithmetic cleanup work.

It is meant to keep future expansion aligned with:

- `docs/question-bank-expansion-guidelines.md`
- `docs/question-bank-taxonomy.md`
- the current bundled JSON pack structure

## Snapshot

### Arithmetic

- `grade1`: 32 questions
- `grade2`: 32 questions
- `grade3`: 35 questions
- `grade4`: 32 questions
- `grade5`: 32 questions
- `grade6`: 36 questions

Current arithmetic condition:

- `grade4` to `grade6` are materially better than before and no longer dominated
  by bare inverse-operation drills.
- `grade5` still has local clustering in `remainders`, `page_numbering`,
  `calendar_counting`, `factors_and_rectangles`, and `ratio`.
- `grade6` still has local clustering in `page_numbering`, `age_problem`,
  `gcd_lcm`, `inclusion_exclusion`, and `remainders`.
- `grade1` to `grade3` remain the weakest arithmetic segment in overall olympiad
  flavor because `comparison` and other low-transform sentence problems still
  take a relatively large share.

### Geometry

- `grade1`: 23 questions
- `grade2`: 23 questions
- `grade3`: 25 questions
- `grade4`: 23 questions
- `grade5`: 23 questions
- `grade6`: 25 questions

Current geometry condition:

- Upper-grade geometry is in reasonable shape, with visible variety in
  coordinate, area, transformation, and angle families.
- Lower-grade geometry is still strongly concentrated in
  `shapes_properties`, `shape_cutting`, and `perimeter_area`.
- `grade3` geometry is especially heavy in `perimeter_area` and should later be
  diversified with more counting, transformation, and structured reasoning.

### Logic

- `grade1`: 22 questions
- `grade2`: 22 questions
- `grade3`: 24 questions
- `grade4`: 22 questions
- `grade5`: 22 questions
- `grade6`: 25 questions

Current logic condition:

- Logic packs are more stable than arithmetic and generally have better
  uniqueness than before.
- Every grade still leans on `ordering`, `elimination`, and `position`.
- This is acceptable as a foundation mix, but future expansion should avoid
  overfilling those three families before adding more:
  `case_reasoning`, `state_tracking`, `pigeonhole`, `truth_deduction`,
  `matching`, and schedule/grid constraints.

## Repetition Risk

### High Risk

- Arithmetic `grade5`:
  `remainders`, `page_numbering`, `calendar_counting`, `factors_and_rectangles`
- Arithmetic `grade6`:
  `page_numbering`, `age_problem`, `gcd_lcm`, `inclusion_exclusion`
- Geometry `grade1`:
  `shapes_properties`
- Geometry `grade3`:
  `perimeter_area`
- Logic all grades:
  `ordering` remains the default fallback family too often

### Medium Risk

- Arithmetic `grade1` to `grade3`:
  `comparison` is overused relative to stronger olympiad-style structures
- Geometry `grade2`:
  `shape_cutting`
- Geometry `grade4`:
  `perimeter_area` and `area_counting`
- Logic `grade4` to `grade6`:
  `elimination` and `position`

### Low Risk

- Upper-grade geometry transformation families
- Mixed logic families in `grade5` and `grade6`
- Arithmetic `grade4` variety after the latest cleanup

## Difficulty Gradient Review

### Arithmetic

- `grade1` to `grade2`:
  basic but still often reads like enriched school math rather than competition
  math
- `grade3`:
  transitional; some packs already show olympiad structure, but the floor is
  still inconsistent
- `grade4`:
  acceptable foundation competition entry level
- `grade5`:
  mostly acceptable, but some packs still repeat the same reasoning skeleton
- `grade6`:
  strongest arithmetic foundation pack at present, though still not fully
  balanced across subtopics

### Geometry

- Difficulty rises more smoothly than arithmetic.
- The main issue is not correctness but concentration.
- `grade1` to `grade3` need more non-formulaic visual reasoning.

### Logic

- Difficulty progression is broadly coherent.
- The main issue is family spread, not level placement.

## Recommended Expansion Order

### Priority 1

- Rebuild `grade1` to `grade3` arithmetic to reduce dependence on:
  `comparison`, weak `pattern`, and bare one-step story arithmetic
- Add more:
  pairing, parity, constrained counting, exchange chains, structured remainder
  ideas, simple casework, and nontrivial arrangement problems

### Priority 2

- Diversify `grade3` geometry and `grade1` to `grade2` geometry
- Add more:
  border counting, composition traps, transformation invariance, and visual
  counting with clearer geometric reasoning

### Priority 3

- Expand logic without defaulting to more `ordering`
- Add more:
  schedule grids, truth-lying hybrids, grouping balance, pigeonhole,
  impossible-case elimination, and short but sharp counterexample reasoning

### Priority 4

- After new content lands, rebalance arithmetic `grade5` and `grade6` again so
  no single family exceeds roughly 2 questions unless it is intentionally split
  by clearly different reasoning structures

## Practical Editing Rules From This Audit

- Do not add more `page_numbering` to `grade5` or `grade6` for now.
- Do not add more bare `ordering` logic questions until other logic families are
  expanded.
- Do not add more lower-grade geometry that only asks for shape naming or raw
  perimeter counting without a twist.
- For arithmetic `grade1` to `grade3`, any new question should pass this test:
  if it can be solved by one obvious operation with no structural choice, it
  should not ship.

## Suggested Next Audit Checkpoint

Run another full audit when one of these happens:

- arithmetic `grade1` to `grade3` receive at least 12 newly rewritten items
- lower-grade geometry receives at least 8 diversification items
- logic receives at least 6 non-ordering additions across grades 4 to 6

At that checkpoint, compare:

- pack size by grade
- subtopic concentration
- repeated reasoning skeletons
- whether the weakest shipped items still feel like olympiad questions
