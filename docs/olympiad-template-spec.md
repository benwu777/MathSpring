# MathSpring Olympiad Template Spec

## Purpose

This document defines the first formal olympiad-question authoring framework
for MathSpring. It exists to replace low-quality free-form question writing with
a template-guided review system that is:

- closer to real olympiad problem structure
- consistent with the current app schema
- easier to validate before shipping
- extensible toward future official-source ingestion

Important boundary:

- templates are for classification, validation, and quality review
- templates are not a license to mass-produce shipping questions by swapping numbers
- every shipped question must still be an original standalone problem

Current date reference for this spec: July 19, 2026.

## Scope

Phase 1 covers:

- elementary learners only
- four shipped topics (`arithmetic`, `geometry`, `logic`, `mixed`)
- two difficulty layers (`foundation`, `competition`)
- two answer modes only (`multiple_choice`, `integer_input`)
- JSON-first integration with the current bundled question bank

Phase 1 does not cover:

- fraction-input answers
- decimal-input answers
- free-response text answers
- junior-high expansion
- automatic direct import of official copyrighted contest text

## Current Project Schema Mapping

All approved question output must map directly to the current question schema already
used by the app:

- `topic`
- `topicCode`
- `difficulty`
- `levelStage`
- `challengeTier`
- `prompt`
- `answer`
- `solutionSteps`
- `figure`
- `answerMode`
- `options`
- `correctAnswer`
- `inputConstraints`
- `source`

No parallel schema should be introduced.

## Topic Set

Phase 1 ships **four** top-level `topicCode` values (these are the only pack
folders and the only allowed `topic`/`topicCode` values in shipped questions):

- `arithmetic`
- `geometry`
- `logic`
- `mixed`

Six mathematical **skill families** are still used as a classification layer for
templates and subtopics, but they are mapped onto the four shipped topicCodes —
they are NOT separate top-level topics or pack folders:

| skill family    | shipped `topicCode` |
| --------------- | ------------------- |
| arithmetic      | `arithmetic`        |
| number theory   | `arithmetic` (or `mixed` for cross-family competition items) |
| algebra         | `mixed` (or `arithmetic` when it is a plain word-relation) |
| geometry        | `geometry`          |
| combinatorics   | `mixed` (or `logic` for pure reasoning-count items) |
| logic           | `logic`             |

Cross-family, competition-style items (e.g. Math-Kangaroo mixed sets) ship under
`topicCode = mixed`; each such question still records its specific skill family in
its `subtopic`.

Display names may remain localized in the app, but template definitions and
shipped questions must use the stable internal `topicCode` from the four above.

## Difficulty Layers

Each template must exist in two layers:

- `foundation`
- `competition`

### Foundation

Foundation questions should:

- teach the pattern of the problem type
- require about 1 to 2 major reasoning turns
- avoid excessive distractor conditions
- keep numeric scale age-appropriate
- remain olympiad-style rather than textbook drill

### Competition

Competition questions should:

- use the same underlying problem family as the foundation template
- require about 2 to 4 major reasoning turns
- include transformation, hidden structure, or controlled trap conditions
- avoid becoming merely "bigger numbers"

## Answer Modes

Phase 1 supports only:

- `multiple_choice`
- `integer_input`

### Multiple Choice Rules

- one uniquely correct option
- distractors must be plausible
- distractors must reflect common wrong reasoning, not random noise
- no ambiguous wording

### Integer Input Rules

- exactly one valid integer answer
- answer must not depend on formatting interpretation
- `inputConstraints` must specify `allowNegative` and `maxDigits`

## First-Batch Template Count

The first production batch should define:

- `6 skill families`
- `3 core template families per skill family`
- `2 difficulty layers per family`

Total:

- `36 core templates`

The skill families are the classification layer above; every resulting template
still maps onto one of the four shipped topicCodes. This batch is intended to
establish quality, not maximize question count.

## Template Usage Boundary

MathSpring templates are intentionally narrow. They may be used to:

- identify the intended olympiad skill
- define acceptable difficulty layering
- validate whether a new question fits a known family

They must not be used to:

- generate large batches of near-duplicate shipping questions
- justify cross-grade copies with only larger numbers
- combine fragments of multiple official problems into one blended item

If two questions differ mainly in numeric surface values while preserving the
same reasoning path, they should be treated as the same template instance and
normally only one of them should ship.

## Core Template Matrix

The headings below are the six **skill families** (the classification layer), not
shipped topics. Each maps onto one of the four shipped topicCodes per the Topic
Set table (number-theory & plain algebra → `arithmetic`; combinatorics & mixed
algebra → `mixed`/`logic`; geometry → `geometry`; logic → `logic`).

### Arithmetic

First three core families:

- `sum_difference_and_multiple_relations`
- `working_backward`
- `pattern_and_sequence_reasoning`

### Number Theory

First three core families:

- `factors_and_multiples`
- `remainders`
- `parity_and_divisibility_logic`

### Algebra

First three core families:

- `unknown_value_translation`
- `equivalent_substitution`
- `equation_style_reasoning`

### Geometry

First three core families:

- `perimeter_and_area`
- `figure_cutting_and_rearrangement`
- `coordinates_and_position_relations`

### Combinatorics

First three core families:

- `systematic_listing`
- `basic_counting`
- `case_splitting`

### Logic

First three core families:

- `elimination`
- `truth_lie_reasoning`
- `ordering_and_matching`

## Template Record Shape

Each template definition should include at least the following fields:

- `templateId`
- `topicCode`
- `subtopic`
- `challengeTier`
- `templateFamily`
- `capabilityGoal`
- `reasoningStepsExpected`
- `allowedAnswerMode`
- `requiresFigure`
- `parameterRules`
- `constraintRules`
- `distractorRules`
- `solutionOutlineRules`
- `validationChecklist`
- `sourcePolicy`

This can live in a future registry file or generated data file, but the content
must follow this structure.

## Required Template Definition Fields

### templateId

Stable identifier, for example:

- `arithmetic_foundation_working_backward_v1`

### capabilityGoal

Short description of what olympiad skill the question is meant to train.

Examples:

- identify hidden equal groups
- reverse a process
- track changing perimeter under cuts
- enumerate without duplication

### reasoningStepsExpected

Should express target depth, not exact literal count.

Examples:

- `1_to_2_major_turns`
- `2_to_4_major_turns`

### requiresFigure

Allowed values:

- `none`
- `optional`
- `required`

If figure is required, the template must also specify acceptable `figure.kind`
values.

### parameterRules

Defines the safe generation range:

- numeric ranges
- parity requirements
- divisibility requirements
- shape restrictions
- coordinate bounds
- uniqueness requirements

### constraintRules

Defines conditions that must always hold in the generated problem.

Examples:

- answer must be a positive integer
- all given quantities must be necessary
- no two options may be equivalent
- diagram labels must match text conditions

### distractorRules

Required for `multiple_choice`.

Distractors should be drawn from:

- partial computation
- common misread of one condition
- wrong order of operations
- forgetting symmetry
- counting one case twice or missing one case

### solutionOutlineRules

Specifies what the generated worked solution must contain.

Examples:

- state the invariant first
- show backward step explicitly
- separate cases before counting
- explain why the distractor interpretation fails

### validationChecklist

Minimum checks before a question can ship:

- unique answer
- no missing condition
- solution matches answer
- answer mode compatible with the problem
- numbers suitable for the targeted age band
- olympiad character preserved
- figure and text consistency

### sourcePolicy

Defines whether the template is meant for:

- editorial rewrite generation
- official reference alignment only
- officially cleared content

## Official Source Metadata Rules

All generated or imported problems must use the shared `source` object.

Recommended source fields:

- `type`
- `name`
- `contest`
- `year`
- `division`
- `problemNumber`
- `reference`
- `displayText`
- `sourceUrl`
- `rightsStatus`
- `notes`

### rightsStatus

Allowed working values:

- `cleared_for_bundle`
- `needs_review`
- `do_not_bundle`

### Phase 1 Source Rule

Unless rights are explicitly cleared, generated problems should remain marked as
editorial or official-reference-backed, not full official bundled text.

## Shipping Status Stages

Every generated question should conceptually move through three states:

- `draft`
- `validated`
- `shipping_ready`

### draft

- generated from template
- not yet trusted

### validated

- passed structural checks
- answer and solution verified

### shipping_ready

- passed validation
- manually sampled or reviewed
- accepted for inclusion in bundled packs
- passed a final olympiad-character review, not just structural correctness

## Quality Gate

A question should not enter the shipping pack unless all of the following are
true:

- it fits one recognized template family
- it has one unique answer
- the explanation genuinely derives the answer
- it is not merely a classroom drill
- the reasoning depth matches the intended tier
- the chosen answer mode is appropriate
- its figure, if any, is consistent with the text
- it still reads like an olympiad problem when compared against real contest-style questions

## Final Olympiad Review Gate

Before a question becomes shipping-ready, it must pass one more manual review
focused specifically on olympiad character.

This review is separate from:

- schema validity
- answer correctness
- solution consistency
- figure-field completeness

The reviewer must reject the item if it is mainly:

- a bare inverse-operation exercise
- a bare sum-and-difference exercise
- a bare average exercise
- a bare perimeter or area plug-in exercise
- a thin numeric rewrite of an existing template instance

Passing this gate requires that the problem still feels like an elementary
contest problem, not merely a correct school-math exercise.

## Template Output Expectations by Topic

### Arithmetic

Generated questions should emphasize:

- structure over raw arithmetic
- hidden relationships
- reverse reasoning

Avoid:

- bare computation prompts
- worksheet-style direct addition or subtraction

### Number Theory

Generated questions should emphasize:

- divisibility structure
- parity logic
- modular reasoning at an elementary level

Avoid:

- formal notation that exceeds elementary olympiad expectations

### Algebra

Generated questions should emphasize:

- translating verbal structure into symbolic reasoning
- substitution and relation tracking

Avoid:

- routine textbook equation drills with no twist

### Geometry

Generated questions should emphasize:

- relationships, not formula recall alone
- area and perimeter changes
- visual inference tied to exact conditions

Avoid:

- pure naming or classification tasks with no reasoning depth

### Combinatorics

Generated questions should emphasize:

- complete counting without omission
- structured casework

Avoid:

- random guessable counting prompts

### Logic

Generated questions should emphasize:

- elimination
- truth structure
- ordering and matching constraints

Avoid:

- trivial "not A so B" style problems at higher tiers

## Suggested Implementation Order

After this spec is accepted, implementation should proceed in this order:

1. create a template registry document or data file
2. implement one sample template per topic
3. generate one validated example per template family
4. review quality manually
5. scale to larger batch generation

## Immediate Next Deliverables

The next concrete outputs should be:

- a template registry file under `docs/` or structured data
- one worked sample template per topic
- updated question-pack generation rules using this spec
