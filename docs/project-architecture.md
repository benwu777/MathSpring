# MathSpring Project Architecture

## Overview

MathSpring is structured around three layers:

- bundled question content
- local learner data
- Flutter presentation and rendering

The first release is offline-first and single-device.

## High-Level Diagram

```text
┌─────────────────────────────────────────────┐
│                  MathSpring                 │
├─────────────────────────────────────────────┤
│ Flutter UI Layer                            │
│ - 首頁 / 題目頁 / 作答元件 / 語言切換       │
│ - CustomPainter 圖形繪製                    │
├─────────────────────────────────────────────┤
│ Domain Layer                                │
│ - Question                                  │
│ - QuestionBank                              │
│ - AnswerMode                                │
│ - LearnerProfile                            │
│ - SessionRecord / Progress models           │
├─────────────────────────────────────────────┤
│ Data Access Layer                           │
│ - BundledQuestionBankRepository             │
│ - Local SQLite repositories                 │
├─────────────────────────────────────────────┤
│ Storage                                     │
│ - assets/questions/*.json                   │
│ - local SQLite database                     │
└─────────────────────────────────────────────┘
```

## Runtime Data Flow

```text
Bundled JSON packs
        ↓
QuestionBank repository
        ↓
Question / QuestionBank models
        ↓
Question page / Answer widgets / Painter
        ↓
User answer / progress event
        ↓
Local SQLite
```

## Current Functional Blocks

### 1. App Shell

- Single Flutter app for iPhone and iPad
- Adaptive layout by available width
- Manual language switching
- Bottom navigation for practice, quiz, review, and settings

### 2. Question Content

- JSON-first bundled question packs
- Multilingual prompt / answer / solution fields
- Structured figure definitions
- Structured answer modes

### 3. Figure Rendering

- `CustomPainter` for math-native figures
- SVG reserved for fixed complex vector assets
- No bitmap-first strategy

### 4. Answer Interaction

- Multiple choice
- Integer input
- Practice mode self-check with inline solution review
- Quiz mode submit, score, elapsed-time summary, and post-submit review

### 5. Learner Data

Current local SQLite support for:

- learner profiles
- current learner selection
- practice and quiz history
- saved answers and score summaries
- app preferences

## Planned Directory Responsibilities

```text
lib/
  main.dart                  # app entry, theme tokens, app state; declares the parts below
  src/                       # parts of main.dart (one library, so private widgets stay shared)
    home_tabs.dart           # home shell, practice/quiz tabs, daily mission
    review_tab.dart          # learning review, achievements, calendar
    settings_tab.dart        # settings, full unlock, language, support links
    home_widgets.dart        # hero, section cards, topic grid
    learner_profiles.dart    # learner list, create/edit learner
    library_pages.dart       # favorites, answer history, session detail
    practice_session.dart    # practice flow and summary
    quiz_session.dart        # quiz / formal exam flow and result
    question_text.dart       # prompt, body, option text widgets
    app_strings.dart         # all UI strings (zh-Hant / zh-Hans / en / ja)
    question_figures.dart    # figure view, render spec, geometry scene painter
    session_helpers.dart     # pickers, launch helpers, answer formatting
    diagram_painters.dart    # remaining CustomPainters for figures
  models/
    question.dart            # question schema and answer schema
    question_bank.dart       # question pack container

assets/
  questions/                 # bundled question packs and manifest

docs/
  initial-product-outline.md
  local-data-architecture.md
  question-bank-taxonomy.md
  project-architecture.md
```

## Current Technical Follow-Ups

1. Continue polishing practice and quiz interaction details.
2. Keep expanding the bundled olympiad-style question packs by taxonomy.
3. Improve remaining documentation so it matches the current competition-profile flow.
