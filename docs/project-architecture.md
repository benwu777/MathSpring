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
  main.dart                  # current app shell and feature entry
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
3. Split `main.dart` into feature-oriented files as the app grows.
4. Improve remaining documentation so it matches the current competition-profile flow.
