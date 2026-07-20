# MathSpring Local Data Architecture

## Overview

MathSpring should separate bundled learning content from device-local user data.

- Bundled content: packaged inside the app
- User data: stored in on-device SQLite

This keeps the question bank easy to ship with the app while allowing each
device to maintain its own learner profiles and progress.

## Storage Split

### 1. Bundled Question Content

Recommended location:

- `assets/questions/manifest.json`
- `assets/questions/<topic>/<pack>.json`

Recommended use:

- Question prompt
- Localized answer
- Localized solution steps
- Topic and difficulty metadata
- Figure rendering description
- Answer mode metadata
- Option sets and input constraints

This data is read-only at runtime in the first phase.

### 2. Device-Local SQLite

Current location:

- App sandbox database created by `sqflite`

Current use:

- Learner profiles
- Current selected learner
- Practice history
- Quiz history
- Saved answers and scoring summaries
- App preferences

Planned later use:

- Favorites, bookmarks, wrong-answer collections
- Future download/sync bookkeeping

## Why This Split Fits MathSpring

- Bundled assets are simple to version with source control.
- Localized content is easy to review in JSON.
- Figure data can be stored as rendering parameters instead of bitmap files.
- User data changes frequently and should not be stored back into bundled assets.
- SQLite gives better local query support once progress and filtering grow.

## Question Record Shape

Each question should include:

- `id`
- `topic`
- `difficulty`
- `levelStage`
- `challengeTier`
- `prompt`
- `answer`
- `solutionSteps`
- `figure`
- `answerMode`
- `correctAnswer`
- `options`
- `inputConstraints`

### Figure Strategy

Use vector-style descriptions instead of bitmap images whenever possible.

- `figure.type = "custom"` for `CustomPainter`-driven math diagrams
- `figure.type = "svg"` for complex but fixed vector assets

### Example Figure Record

```json
{
  "type": "custom",
  "kind": "trig_plane",
  "params": {
    "showGrid": true,
    "showLegend": true,
    "highlightInterval": ["pi/2", "pi"],
    "functions": ["sin", "cos"]
  }
}
```

## Current SQLite Tables

Current tables:

- `learner_profiles`
- `practice_sessions`
- `session_answers`
- `app_preferences`

Current field direction:

- `learner_profiles`: `id`, `display_name`, learner level/profile fields, `created_at`
- `practice_sessions`: learner, mode, score, elapsed time, created time
- `session_answers`: question id, submitted answer, correctness, answer snapshot
- `app_preferences`: `key`, `value`

## Evolution Path

Phase 1:

- Bundle JSON question banks in assets
- Use SQLite for mutable learner/session data

Phase 2:

- Add more bundled question files by topic or grade
- Add taxonomy-driven pack organization and manifest indexing
- Keep the repository layer centered on asset JSON plus local persistence

Phase 3:

- If content becomes large, move bundled question content into a prebuilt SQLite database
- Keep the same domain models so UI and business logic stay stable
