# MathSpring Question Bank Taxonomy

## Overview

MathSpring uses a two-level subject taxonomy:

- Level 1: major topic
- Level 2: subtopic

This keeps file management simple while still giving enough detail for
recommendation, filtering, and learner progress analysis.

## Level Structure

Primary level rules:

- Main stage is elementary school only in phase 1: `grade1` to `grade6`
- Current bundled packs ship with `foundation`
- The schema should remain extensible for later junior-high expansion

## Major Topics

- `算術`
- `數論`
- `代數`
- `幾何`
- `組合`
- `邏輯`

## Subtopics

### 算術

- 四則運算
- 分數
- 小數
- 比與比值
- 百分率
- 速率時間路程
- 平均數
- 單位換算

### 數論

- 整除性
- 因數與倍數
- 質數
- 最大公因數與最小公倍數
- 餘數問題
- 進位制

### 代數

- 規律與找規則
- 未知數
- 方程式
- 代數式
- 數列
- 座標平面
- 函數初步

### 幾何

- 直線與角
- 三角形
- 四邊形
- 圓
- 周長與面積
- 立體幾何
- 圖形變換
- 幾何推理

### 組合

- 計數
- 排列方式
- 排列組合
- 分情況討論
- 抽屜原理
- 容斥概念

### 邏輯

- 推理判斷
- 真話假話
- 配對問題
- 排除法
- 方格邏輯
- 策略謎題

## File Organization

Question packs should be grouped by:

- one major topic
- one grade stage
- one challenge tier

Recommended folder structure:

```text
assets/questions/
  manifest.json
  arithmetic/
    grade3_foundation.arithmetic.v1.json
    grade4_foundation.arithmetic.v1.json
  number_theory/
    grade4_foundation.number_theory.v1.json
  geometry/
    grade4_foundation.geometry.v1.json
```

## File Naming Rule

Recommended pack filename:

```text
<levelStage>_<challengeTier>.<topicCode>.v<version>.json
```

Examples:

- `grade4_foundation.geometry.v1.json`
- `grade5_foundation.arithmetic.v1.json`
- `grade6_foundation.logic.v1.json`

## Question ID Rule

Each question should have a stable unique id:

```text
<topicCode>_<levelStage>_<challengeTier>_<serial>
```

Examples:

- `geometry_grade4_foundation_001`
- `arithmetic_grade5_foundation_012`
- `logic_grade6_foundation_004`

If AI and human-edited content need to be separated later, an optional source
prefix can be added:

- `ai_geometry_grade4_foundation_001`
- `editor_logic_grade6_foundation_002`

## Pack Shape

Each pack file should contain one consistent metadata block and a list of
questions.

```json
{
  "version": 1,
  "topic": "幾何",
  "topicCode": "geometry",
  "levelStage": "grade4",
  "challengeTier": "foundation",
  "languages": ["zh-Hant", "en", "zh-Hans", "ja"],
  "questions": []
}
```

## Question Source Shape

Each question should include a `source` block so app content never confuses
editorial rewrites with official competition material.

```json
{
  "source": {
    "type": "rewritten_olympiad_style",
    "name": "MathSpring Editorial",
    "contest": null,
    "year": null,
    "division": null,
    "problemNumber": null,
    "reference": "geometry-grade4-foundation",
    "displayText": "MathSpring Editorial · geometry-grade4-foundation",
    "sourceUrl": null,
    "rightsStatus": "cleared_for_bundle",
    "notes": "Olympiad-style rewritten content aligned to elementary competition pacing; not an official past-paper reproduction."
  }
}
```

Recommended `source.displayText`:

- non-localized plain text for direct UI display
- use the original language of the competition source
- preferred format:
  - official source: `<contest name> <year>, <group>, Problem <number>`
  - internal rewrite: `<editorial source> · <internal reference>`

Examples:

- `Math Kangaroo USA 2025, Grades 3-4, Problem 12`
- `2024/2025學年學界數學比賽（小學組）第 7 題`
- `AMC 8 2025, Problem 6`

Additional recommended fields for official-source intake:

- `contest`
- `year`
- `division`
- `problemNumber`
- `sourceUrl`
- `rightsStatus`

Recommended `rightsStatus` values:

- `cleared_for_bundle`
- `needs_review`
- `do_not_bundle`

Recommended `source.type` values:

- `rewritten_olympiad_style`
- `official_reference`
- `licensed_official`
- `internal_demo`

Current shipping policy:

- bundled app questions should default to `rewritten_olympiad_style`
- official contest papers must not be copied into the app without confirmed rights
- `official_reference` is for editorial background/reference only unless usage rights are explicitly cleared

## Manifest Shape

`manifest.json` should act as the index for all available packs.

```json
{
  "version": 1,
  "packs": [
    {
      "path": "assets/questions/geometry/grade4_foundation.geometry.v1.json",
      "topic": "幾何",
      "topicCode": "geometry",
      "levelStage": "grade4",
      "challengeTier": "foundation",
      "questionCount": 10
    }
  ]
}
```

## Notes

- `trigonometry` is not a phase-1 main topic
- mixed competition-profile packs are allowed to use `topicCode = mixed` while
  each question keeps its own specific `topic`
- junior-high topics should be added later without changing the current file rule
- question content source should remain JSON-first even if app runtime later moves
  to SQLite-backed querying
