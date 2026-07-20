# MathSpring Olympiad Template Spec

## Purpose

This document defines the first formal olympiad-question generation framework
for MathSpring. It exists to replace low-quality free-form question writing with
a template-driven system that is:

- closer to real olympiad problem structure
- consistent with the current app schema
- easier to validate before shipping
- extensible toward future official-source ingestion

Current date reference for this spec: July 19, 2026.

## Scope

Phase 1 covers:

- elementary learners only
- six major topics
- two difficulty layers
- two answer modes only
- JSON-first integration with the current bundled question bank

Phase 1 does not cover:

- fraction-input answers
- decimal-input answers
- free-response text answers
- junior-high expansion
- automatic direct import of official copyrighted contest text

## Current Project Schema Mapping

All template output must map directly to the current question schema already
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

Phase 1 uses six major topics:

- `arithmetic`
- `number_theory`
- `algebra`
- `geometry`
- `combinatorics`
- `logic`

Display names may remain localized in the app, but template definitions should
use the stable internal `topicCode`.

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

- `6 topics`
- `3 core template families per topic`
- `2 difficulty layers per family`

Total:

- `36 core templates`

This batch is intended to establish quality, not maximize question count.

## Core Template Matrix

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
