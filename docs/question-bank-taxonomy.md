# MathSpring Question Bank Taxonomy

## Overview

MathSpring uses a two-level subject taxonomy:

- Level 1: major topic
- Level 2: subtopic

This keeps file management simple while still giving enough detail for
recommendation, filtering, and learner progress analysis.

## Level Structure

Primary level rules:

- Current shipped elementary packs remain `grade1` to `grade6`
- New expansion stage adds `grade7` to `grade12`
- **Grade (`levelStage`) is the only difficulty axis** in the current model
- `challengeTier` (and per-question `difficulty`) stays fixed at `foundation`
  as a schema placeholder
- `grade1` to `grade6` keep the legacy top-level topic folders for app
  compatibility
- `grade7` to `grade12` use canonical olympiad topic folders directly

## Major Topics

### Legacy shipped top-level topics (`grade1` to `grade6`)

Phase 1 ships **four** top-level topics (these are the only `topicCode` values and
the only pack folders):

| `topicCode`  | display   |
| ------------ | --------- |
| `arithmetic` | 算術      |
| `geometry`   | 幾何      |
| `logic`      | 邏輯      |
| `mixed`      | 混合      |

The six mathematical **skill families** below (算術 / 數論 / 代數 / 幾何 / 組合 /
邏輯) are a classification layer for subtopics only. They map onto the four shipped
topics — they are NOT separate topics or folders:

- 算術、數論 → `arithmetic`（跨家族競賽題可放 `mixed`）
- 代數、組合 → `mixed`（純推理計數的組合題可放 `logic`）
- 幾何 → `geometry`
- 邏輯 → `logic`

The canonical allowed `subtopic` list per shipped topic is maintained in
`docs/question-bank-subtopic-registry.md`.

### Canonical olympiad topics (`grade7` to `grade12`)

Starting with `grade7`, the canonical topic system becomes first-class:

| `topicCode`       | display |
| ----------------- | ------- |
| `algebra`         | 代數    |
| `geometry`        | 幾何    |
| `number_theory`   | 數論    |
| `combinatorics`   | 組合    |
| `logic`           | 邏輯    |

For `grade1` to `grade6`, these canonical topics are stored as compatibility
metadata on each question through `olympiadTaxonomy`.

## Subtopic Skill Families (classification layer)

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
  geometry/
    grade4_foundation.geometry.v1.json
  logic/
    grade4_foundation.logic.v1.json
  mixed/
    grade5_foundation.mixed.v1.json
    grade6_foundation.mixed.v1.json
  algebra/
    grade7_foundation.algebra.v1.json
  number_theory/
    grade8_foundation.number_theory.v1.json
  combinatorics/
    grade10_foundation.combinatorics.v1.json
```

`grade1` to `grade6` continue to use the four legacy topic folders
(`arithmetic`, `geometry`, `logic`, `mixed`).

`grade7` to `grade12` may use canonical olympiad folders directly:

- `algebra/`
- `geometry/`
- `number_theory/`
- `combinatorics/`
- `logic/`

## File Naming Rule

Recommended pack filename:

```text
<levelStage>_<challengeTier>.<topicCode>.v<version>.json
```

Examples:

- `grade4_foundation.geometry.v1.json`
- `grade5_foundation.arithmetic.v1.json`
- `grade6_foundation.logic.v1.json`
- `grade7_foundation.algebra.v1.json`
- `grade12_foundation.number_theory.v1.json`

## Question ID Rule

Each question should have a stable unique id:

```text
<topicCode>_<levelStage>_<challengeTier>_<serial>
```

Examples:

- `geometry_grade4_foundation_001`
- `arithmetic_grade5_foundation_012`
- `logic_grade6_foundation_004`
- `algebra_grade7_foundation_001`
- `combinatorics_grade12_foundation_003`

If AI and human-edited content need to be separated later, an optional source
prefix can be added:

- `ai_geometry_grade4_foundation_001`
- `editor_logic_grade6_foundation_002`

## Display Code Rule（精簡顯示碼）

除了內部主鍵 `id`（穩定唯一、不改），每題有一個給人看的**精簡顯示碼**，掃一眼即可判讀「類型 + 年級」（phase 1 不分難度，故不含難度段）。

格式：

```text
<TT>-G<grade>-<serial>
```

- `TT`（類型，兩碼）：`AR`=arithmetic、`GE`=geometry、`LO`=logic、`MX`=mixed
- `G<grade>`：`G1`~`G6`，取自 `levelStage`（mixed pack 取其主年級）
- `serial`：3 碼流水號，與 `id` 尾碼相同

範例：

- `AR-G5-012` = 算術 · 5 年級 · 第 12 題
- `GE-G3-004` = 幾何 · 3 年級 · 第 4 題
- `LO-G6-008` = 邏輯 · 6 年級 · 第 8 題
- `MX-G6-001` = 混合（袋鼠）· 6 年級 · 第 1 題

規則：

- 顯示碼是 `id` 的純函數（由 `topicCode` / `levelStage` / serial 推導），與 `id` 一對一，唯一性等同 `id`。
- **優先由 app 即時推導，不必存進每題 JSON**（避免資料重複與漂移）；若確定要存成欄位，用 `displayCode`，並以 `id` 為單一真實來源、由 id 產生。
- 推導參考（Dart getter 概念）：`"${{arithmetic:'AR',geometry:'GE',logic:'LO',mixed:'MX'}[topicCode]}-G${levelStage.replace('grade','')}-$serial"`

## Pack Shape

Each pack file should contain one consistent metadata block and a list of
questions.

```json
{
  "version": 1,
  "topic": "幾何",
  "topicCode": "geometry",
  "olympiadTopic": "幾何",
  "olympiadTopicCode": "geometry",
  "levelStage": "grade4",
  "challengeTier": "foundation",
  "languages": ["zh-Hant", "en", "zh-Hans", "ja"],
  "questions": []
}
```

Legacy packs may keep `topic` / `topicCode` as-is and store canonical mapping in
question-level `olympiadTaxonomy`.

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
