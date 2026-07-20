# MathSpring Initial Product Outline

## Project Summary

- App name: `MathSpring`
- Product type: olympiad math learning app
- Primary platforms: iPhone and iPad
- Tech stack: Flutter single codebase with adaptive layouts
- Visual direction: modern minimalist math interface with deep-blue brand color
- Initial languages: Traditional Chinese and English
- Planned expansion languages: Simplified Chinese and Japanese

## Initial Development Strategy

The first release should use one Flutter project for both iPhone and iPad.
Shared flows, data models, and question content formats should be built once.
The UI should adapt by available width instead of splitting into separate phone
and tablet apps.

Recommended approach:

- Keep one shared app architecture for mobile devices.
- Design pages mobile-first, then add iPad layout optimization.
- Use adaptive layout patterns for list/detail and wider reading surfaces.
- Avoid device-specific business logic unless iOS platform behavior requires it.
- Resolve the initial language from the system locale, then allow manual language switching.

## Visual Direction

The first version should not look like a children's toy app.
The interface should feel calm, precise, and premium.

Visual principles:

- Minimal layout with strong whitespace
- Deep-blue primary brand color
- Soft neutral background surfaces
- Rounded cards with light borders instead of heavy shadows
- Clear hierarchy for title, progress, and question content
- Mobile-first composition with wider iPad reading layouts

## Initial User Flow

1. First launch opens onboarding.
2. User creates a learner profile.
3. User selects a starting level.
4. User starts practicing from the recommended question set.
5. User can later add more learner profiles on the same device.
6. User can switch between learner profiles with different levels and progress.

## Learner Profiles

The app should support multiple learner profiles on one device.
This allows siblings such as an older brother and younger brother to use the
same iPhone or iPad while keeping their own level and progress.

Each learner profile should eventually include:

- Display name
- Current level
- Progress summary
- Preferred question sets
- Practice history

## Level Structure

The app now uses competition-style learner levels as the main user-facing
selection, while keeping internal question metadata flexible enough to map to
elementary grade bands.

Current user-facing direction:

- Competition profile first, not raw grade first
- Each profile should include helper text that explains the approximate school
  grade range
- Different learner profiles on one device can use different competition levels

Current profile examples:

- `Kangaroo 1-2`
- `Kangaroo 3-4`
- `Kangaroo 5-6`

## Question Bank Strategy

The question bank must support gradual expansion over time.
All content should follow one stable structure so new questions can be appended
without changing the app logic.

The question bank should be multilingual from the start.
The first release should ship real content in Traditional Chinese and English.
Simplified Chinese and Japanese should be supported in the data structure even
if the content rollout happens later.

Each question record must include:

- Question prompt
- Final answer
- Solution steps
- Difficulty or level
- Topic category

Recommended topic categories for the first version:

- Arithmetic
- Number theory
- Geometry
- Logic
- Word problems
- Patterns
- Fractions and ratios
- Measurement
- Combinatorics

`Trigonometry` should not be a first-phase category if the product is focused on
elementary olympiad math. It can be introduced later if the target scope expands
to older students.

## Content Format Principles

To keep the question bank maintainable, every question should follow a
consistent schema.

Suggested content fields:

- `id`
- `prompt`
- `answer`
- `solutionSteps`
- `levelStage`
- `challengeTier`
- `topic`
- `tags`
- `source`
- `language`

Recommended multilingual structure:

- `prompt`: map keyed by locale code such as `zh-Hant`, `en`, `zh-Hans`, `ja`
- `answer`: map keyed by locale code
- `solutionSteps`: map keyed by locale code
- fallback rules for missing translations

## First-Phase Scope

The first phase should focus on:

- Flutter app foundation
- iPhone and iPad adaptive support
- Modern minimalist visual system
- Learner profile switching
- System-locale default with manual language switching
- Competition-profile-based learner setup
- Expandable question data format
- Multilingual question display and answer review
- Practice and quiz session flow
- Local history review

Items that can wait until later:

- Cloud sync
- Account login
- Parent dashboard
- Paid subscription
- Teacher/admin backend
- Advanced analytics

## Open Decisions For Later

- Final level naming shown to families
- Whether learner data is local-only first or cloud-backed
- Whether question content is bundled locally or downloaded remotely
- Whether progress should unlock by topic, level, or both
- Exact translation workflow for future question content
