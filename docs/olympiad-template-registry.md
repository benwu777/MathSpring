# Olympiad Template Registry

> **Phase-1 topic mapping (canonical).** The sections below are the six **skill
> families** (arithmetic / number_theory / algebra / geometry / combinatorics /
> logic) — a classification layer for templates, NOT shipped topics. Shipped
> questions and pack folders use only the **four** topicCodes
> `arithmetic` / `geometry` / `logic` / `mixed`. Mapping: number_theory → `arithmetic`;
> algebra → `mixed` (or `arithmetic`); combinatorics → `mixed` (or `logic`);
> geometry → `geometry`; logic → `logic`. A `templateId` may keep its skill-family
> prefix, but the generated question's `topicCode` must be one of the four.
> See `olympiad-template-spec.md` (Topic Set) and `question-bank-taxonomy.md`.

## Summary

- Total core templates: 36
- Skill families covered: 6 (mapped onto 4 shipped topicCodes — see note above)
- Core families per skill family: 3
- Difficulty layers per family: 2 (`foundation`, `competition`)
- Supported answer modes in phase 1:
  - `multiple_choice`
  - `integer_input`

Registry date: July 19, 2026

## Registry Rules

Each family below is defined twice:

- `foundation`
- `competition`

Each template is expected to map directly to the current MathSpring question
schema and follow the constraints in `docs/olympiad-template-spec.md`.

---

### arithmetic

#### sum_difference_and_multiple_relations

- `arithmetic_foundation_sum_difference_and_multiple_relations_v1`
  - goal: infer unknown quantities from total, difference, or multiple relations
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: translate verbal relationships into structured quantities
- `arithmetic_competition_sum_difference_and_multiple_relations_v1`
  - goal: solve multi-step relation problems with hidden grouping or comparison traps
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: manage layered total-difference reasoning

#### working_backward

- `arithmetic_foundation_working_backward_v1`
  - goal: reverse one or two operations to recover a starting value
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: invert a sequence of changes
- `arithmetic_competition_working_backward_v1`
  - goal: reverse a longer process with conditional steps or grouped changes
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: preserve order while unwinding operations

#### pattern_and_sequence_reasoning

- `arithmetic_foundation_pattern_and_sequence_reasoning_v1`
  - goal: identify simple numeric growth rules and continue or compare terms
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: detect arithmetic or grouped repetition structure
- `arithmetic_competition_pattern_and_sequence_reasoning_v1`
  - goal: solve disguised sequence rules with alternating or nested patterns
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: isolate repeating units and hidden increments

---

### number_theory

#### factors_and_multiples

- `number_theory_foundation_factors_and_multiples_v1`
  - goal: reason about divisors, multiples, and shared factor structure
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: connect multiplication structure to constraints
- `number_theory_competition_factors_and_multiples_v1`
  - goal: solve constrained divisibility problems with multiple candidate filters
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: narrow candidates through intersecting factor conditions

#### remainders

- `number_theory_foundation_remainders_v1`
  - goal: determine remainder outcomes in simple division settings
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: interpret quotient-remainder structure
- `number_theory_competition_remainders_v1`
  - goal: solve repeated or transformed remainder situations
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: track congruent behavior through changes

#### parity_and_divisibility_logic

- `number_theory_foundation_parity_and_divisibility_logic_v1`
  - goal: use odd-even and divisibility facts to eliminate impossible answers
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: detect parity-based impossibility
- `number_theory_competition_parity_and_divisibility_logic_v1`
  - goal: combine parity with divisibility and expression structure
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: prove feasibility or impossibility from multiple properties

---

### algebra

#### unknown_value_translation

- `algebra_foundation_unknown_value_translation_v1`
  - goal: convert a verbal relationship into an unknown-value equation
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: represent one unknown cleanly
- `algebra_competition_unknown_value_translation_v1`
  - goal: interpret layered verbal conditions before solving for an unknown
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: encode hidden relations before solving

#### equivalent_substitution

- `algebra_foundation_equivalent_substitution_v1`
  - goal: replace equal expressions or quantities to simplify a problem
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: preserve equality while swapping forms
- `algebra_competition_equivalent_substitution_v1`
  - goal: use multiple substitutions to collapse a harder structure
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: chain equivalent transformations

#### equation_style_reasoning

- `algebra_foundation_equation_style_reasoning_v1`
  - goal: solve age-appropriate one-variable equation-style olympiad problems
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: solve by balancing or direct relation
- `algebra_competition_equation_style_reasoning_v1`
  - goal: solve equation-style setups with structure, not routine drill
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: identify hidden balance or regroup terms strategically

---

### geometry

#### perimeter_and_area

- `geometry_foundation_perimeter_and_area_v1`
  - goal: reason about perimeter or area using simple but non-routine structure
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `optional`
  - figure kinds: `shape_diagram`, `coordinate_plane`
  - typical skill: connect dimensions to derived measure
- `geometry_competition_perimeter_and_area_v1`
  - goal: solve area-perimeter problems with decomposition or hidden invariants
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `required`
  - figure kinds: `shape_diagram`, `coordinate_plane`
  - typical skill: derive effect of change rather than apply formula directly

#### figure_cutting_and_rearrangement

- `geometry_foundation_figure_cutting_and_rearrangement_v1`
  - goal: analyze simple cuts or rearrangements of familiar figures
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `required`
  - figure kinds: `shape_diagram`
  - typical skill: track preserved and changed quantities
- `geometry_competition_figure_cutting_and_rearrangement_v1`
  - goal: solve multi-step dissection or recombination problems
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `required`
  - figure kinds: `shape_diagram`
  - typical skill: reason through composite figure transformations

#### coordinates_and_position_relations

- `geometry_foundation_coordinates_and_position_relations_v1`
  - goal: read or infer coordinate movement and point location
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `required`
  - figure kinds: `coordinate_plane`
  - typical skill: translate movement into coordinate change
- `geometry_competition_coordinates_and_position_relations_v1`
  - goal: combine coordinate moves, symmetry, or path constraints
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `required`
  - figure kinds: `coordinate_plane`
  - typical skill: synthesize several spatial relations at once

---

### combinatorics

#### systematic_listing

- `combinatorics_foundation_systematic_listing_v1`
  - goal: list all valid cases without omission or duplication
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: organize enumeration cleanly
- `combinatorics_competition_systematic_listing_v1`
  - goal: control larger search spaces through structure and order
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: compress enumeration using a strategy

#### basic_counting

- `combinatorics_foundation_basic_counting_v1`
  - goal: count valid arrangements or choices under one main restriction
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: count directly with a clean model
- `combinatorics_competition_basic_counting_v1`
  - goal: count under interacting restrictions or grouped structure
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: avoid undercounting and overcounting

#### case_splitting

- `combinatorics_foundation_case_splitting_v1`
  - goal: divide a problem into a small number of exhaustive cases
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: identify natural branches
- `combinatorics_competition_case_splitting_v1`
  - goal: use nested or asymmetric cases while preserving completeness
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: structure difficult counting by layered casework

---

### logic

#### elimination

- `logic_foundation_elimination_v1`
  - goal: infer the only valid answer by removing impossible options
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: use direct exclusions
- `logic_competition_elimination_v1`
  - goal: combine several constraints before the final elimination step
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: track multiple interacting exclusions

#### truth_lie_reasoning

- `logic_foundation_truth_lie_reasoning_v1`
  - goal: reason about statements that are true, false, or opposite
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: compare statement compatibility
- `logic_competition_truth_lie_reasoning_v1`
  - goal: solve truth-structure puzzles with several speakers or layered claims
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: evaluate global consistency across statements

#### ordering_and_matching

- `logic_foundation_ordering_and_matching_v1`
  - goal: place people or objects in order or pairs using a few constraints
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: organize relation constraints clearly
- `logic_competition_ordering_and_matching_v1`
  - goal: solve denser arrangement or assignment puzzles with interdependent clues
  - answer modes: `multiple_choice`, `integer_input`
  - figure: `none`
  - typical skill: manage a constraint grid mentally or structurally
