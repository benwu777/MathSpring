# MathSpring Duplicate Review Ledger

> Audit date: 2026-07-28
> Scope: all bundled question packs under `assets/questions/`
> Source scan: [question-bank-duplicate-audit-2026-07-28.json](/Users/benwu/sideproject/Flutter/MathSpring/docs/question-bank-duplicate-audit-2026-07-28.json)
> Tool: [tool/question_bank_duplicate_audit.dart](/Users/benwu/sideproject/Flutter/MathSpring/tool/question_bank_duplicate_audit.dart)

Update:

- The audit tool now scans **manifest-listed shipped packs only** by default.
- Legacy `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json` is no longer part of duplicate-risk scoring because it is not bundled in `manifest.json`.

## Purpose

This ledger tracks duplicate-risk review in a way that can be continued across sessions.

The standard is strict:

- A valid new question must be a **completely different question**
- Not a number swap
- Not a story reskin
- Not a moved target quantity
- Not the same solution skeleton in a different wrapper

## Status Labels

- `exact_duplicate`: prompt text is identical or effectively identical
- `likely_reskin`: very high risk same skeleton; needs rewrite or merge decision
- `family_cluster`: broad same-family grouping; review manually before acting
- `acceptable_variant`: reviewed and allowed to coexist
- `corrected`: rewritten already

## Review Order

Review in this order each time:

1. High-confidence 2-item or 3-item reskins in risky subtopics:
   `work_backwards`, `balance_transfer`, `age_problem`, `angle_ratio`,
   `angle_sum_polygon`, `triangle_angles`, `trapezoid_area`, `state_tracking`
2. Lower-grade arithmetic (`grade1` to `grade3`)
3. Lower-grade geometry (`grade1` to `grade3`)
4. Logic packs
5. Broad family clusters that may contain false positives but still indicate overuse

## Current Snapshot

- Total scanned questions: `832`
- Candidate groups flagged by heuristic: `47`
- Exact-duplicate groups: `0`

Current interpretation:

- The previously reported 24 exact duplicates were legacy overlap between split
  mixed packs and the unbundled `kangaroo56` file. After manifest-scoped auditing,
  those are removed from active shipped-pack review.
- The heuristic was tightened twice on 2026-07-28: structure tags now distinguish
  arrangement constraints, ordering query types, matching/cardinality cases,
  coordinate families, translation variants, truth-statement families, and several
  geometry area/perimeter structures more accurately.
- A sixth rewrite pass replaced 11 weak same-skeleton questions directly in the
  shipped packs, an eighth pass replaced 10 more, a ninth pass replaced 10
  additional same-shell questions, and three final cleanup passes replaced 22
  more across arithmetic, geometry, and logic packs. Later heuristic
  refinements also split several broad logic and geometry families more
  accurately. The drop from `118` to `47` groups is
  therefore a mix of:
  genuine content cleanup, better structural classification, and removal of false
  positives that were previously merged under under-specified fingerprints.
- The broadest remaining queue is now much narrower. The current largest active
  content risk is still `geometry/perimeter_area`, followed by cross-grade
  arithmetic shells such as `inclusion_exclusion`, `multi_step`,
  `number_line`, `page_numbering`, and residual logic families such as
  `grid_elimination`, `grouping_balance`, `pigeonhole`, and `position`.

## Exact Duplicates

Status: no exact duplicates remain in manifest-listed shipped packs.

Historical note:

- Those 24 pairs were not independently rewritten yet.
- They were removed from active audit scope because they belong to the old,
  unbundled `kangaroo56` aggregate pack rather than current shipped content.

## High-Confidence Reskin Candidates

These are not always literal duplicates, but they are strong same-skeleton suspects.

| Status | Topic | Subtopic | Question IDs | Note |
| --- | --- | --- | --- | --- |
| `likely_reskin` | geometry | border_counting | `geometry_grade2_foundation_040`, `geometry_grade3_foundation_033` | Same rectangular border-counting family with only counts swapped |
| `likely_reskin` | logic | grid_elimination | `logic_grade2_foundation_008`, `logic_grade5_foundation_025`, `logic_grade5_foundation_027`, `logic_grade5_foundation_029` | Same grid-style elimination family with richer surface data |
| `likely_reskin` | logic | grouping_balance | `logic_grade6_foundation_027`, `logic_grade6_foundation_031` | Both remain partition-by-total-balance deduction shells |
| `likely_reskin` | arithmetic | inclusion_exclusion | `arithmetic_grade3_foundation_001`, `arithmetic_grade5_foundation_012`, `arithmetic_grade6_foundation_012` | Same direct union-count formula family |
| `likely_reskin` | arithmetic | number_line | `arithmetic_grade1_foundation_028`, `arithmetic_grade2_foundation_031`, `arithmetic_grade3_foundation_025`, `arithmetic_grade4_foundation_030` | Same forward-backward jump structure |

## Broad Family Clusters

These groups are too broad to auto-delete, but they show where uniqueness review should focus.

| Status | Topic | Subtopic | Count |
| --- | --- | --- | --- |
| `family_cluster` | geometry | perimeter_area | 4 |
| `family_cluster` | arithmetic | route_counting | 2 |
| `family_cluster` | geometry | scale_factor | 2 |
| `family_cluster` | arithmetic | inclusion_exclusion | 2 |
| `family_cluster` | logic | pigeonhole | 2 |
| `family_cluster` | geometry | shape_cutting | 2 |
| `family_cluster` | logic | position | 2 |
| `family_cluster` | geometry | position_direction | 2 |
| `family_cluster` | logic | truth_deduction | 2 |
| `family_cluster` | logic | ranking | 2 |
| `family_cluster` | logic | pattern | 2 |
| `family_cluster` | arithmetic | pair_counting | 1 |
| `family_cluster` | arithmetic | parity_counting | 1 |

## Already Corrected In This Audit Cycle

These IDs were rewritten in the current 2026-07-28 cleanup passes and should be treated as reviewed.

### First Pass

- `arithmetic_grade1_foundation_026`
- `arithmetic_grade1_foundation_037`
- `arithmetic_grade2_foundation_023`
- `arithmetic_grade2_foundation_042`
- `arithmetic_grade3_foundation_028`
- `arithmetic_grade3_foundation_035`
- `geometry_grade3_foundation_028`
- `geometry_grade3_foundation_030`
- `logic_grade4_foundation_020`
- `mixed_grade5_foundation_001`

### Second Pass

- `arithmetic_grade1_foundation_021`
- `arithmetic_grade1_foundation_029`
- `arithmetic_grade2_foundation_026`
- `arithmetic_grade2_foundation_043`
- `arithmetic_grade2_foundation_048`
- `arithmetic_grade2_foundation_050`
- `arithmetic_grade3_foundation_016`
- `arithmetic_grade3_foundation_029`
- `arithmetic_grade3_foundation_051`
- `arithmetic_grade4_foundation_029`
- `arithmetic_grade4_foundation_035`
- `arithmetic_grade4_foundation_037`
- `arithmetic_grade4_foundation_046`
- `arithmetic_grade4_foundation_049`
- `arithmetic_grade5_foundation_007`
- `arithmetic_grade6_foundation_032`
- `geometry_grade3_foundation_003`
- `geometry_grade3_foundation_008`
- `geometry_grade3_foundation_010`
- `geometry_grade3_foundation_022`
- `geometry_grade3_foundation_038`
- `logic_grade1_foundation_022`
- `logic_grade2_foundation_022`
- `logic_grade3_foundation_022`
- `logic_grade5_foundation_020`
- `logic_grade6_foundation_023`

### Third Pass

- `geometry_grade5_foundation_018`
- `geometry_grade6_foundation_001`
- `geometry_grade6_foundation_009`
- `geometry_grade6_foundation_024`
- `arithmetic_grade5_foundation_023`
- `arithmetic_grade6_foundation_022`
- `arithmetic_grade6_foundation_026`
- `arithmetic_grade1_foundation_004`
- `arithmetic_grade5_foundation_008`
- `arithmetic_grade6_foundation_008`
- `geometry_grade5_foundation_011`
- `geometry_grade5_foundation_015`
- `geometry_grade5_foundation_025`
- `geometry_grade5_foundation_027`
- `geometry_grade5_foundation_028`
- `geometry_grade5_foundation_030`
- `geometry_grade5_foundation_032`
- `geometry_grade5_foundation_036`
- `arithmetic_grade1_foundation_002`
- `arithmetic_grade2_foundation_005`
- `arithmetic_grade4_foundation_008`

### Fourth Pass

- `arithmetic_grade2_foundation_006`
- `arithmetic_grade4_foundation_007`
- `arithmetic_grade4_foundation_044`

### Fifth Pass

- `arithmetic_grade4_foundation_007`
- `arithmetic_grade6_foundation_008`

### Sixth Pass

- `arithmetic_grade1_foundation_040`
- `arithmetic_grade4_foundation_009`
- `arithmetic_grade4_foundation_032`
- `arithmetic_grade5_foundation_010`
- `geometry_grade3_foundation_016`
- `geometry_grade3_foundation_026`
- `geometry_grade4_foundation_013`
- `geometry_grade4_foundation_021`
- `geometry_grade5_foundation_012`
- `logic_grade2_foundation_010`
- `logic_grade6_foundation_011`

### Eighth Pass

- `geometry_grade2_foundation_022`
- `geometry_grade4_foundation_001`
- `geometry_grade4_foundation_024`
- `geometry_grade4_foundation_036`
- `logic_grade2_foundation_015`
- `logic_grade3_foundation_020`
- `logic_grade5_foundation_018`
- `logic_grade6_foundation_021`
- `logic_grade2_foundation_013`
- `logic_grade5_foundation_021`

### Ninth Pass

- `arithmetic_grade1_foundation_043`
- `arithmetic_grade2_foundation_003`
- `arithmetic_grade3_foundation_021`
- `geometry_grade5_foundation_005`
- `logic_grade2_foundation_018`
- `logic_grade3_foundation_015`
- `logic_grade4_foundation_013`
- `logic_grade4_foundation_021`
- `logic_grade5_foundation_013`
- `logic_grade6_foundation_016`

### Tenth Pass

- `arithmetic_grade1_foundation_040`
- `arithmetic_grade2_foundation_003`
- `arithmetic_grade2_foundation_004`
- `arithmetic_grade4_foundation_010`
- `arithmetic_grade4_foundation_018`
- `arithmetic_grade5_foundation_027`
- `arithmetic_grade5_foundation_028`
- `geometry_grade1_foundation_023`
- `geometry_grade5_foundation_007`
- `geometry_grade5_foundation_014`
- `logic_grade4_foundation_004`
- `logic_grade5_foundation_016`

### Eleventh Pass

- `arithmetic_grade1_foundation_018`
- `arithmetic_grade1_foundation_039`
- `arithmetic_grade2_foundation_012`
- `arithmetic_grade3_foundation_034`
- `arithmetic_grade4_foundation_026`
- `logic_grade5_foundation_001`

### Twelfth Pass

- `arithmetic_grade3_foundation_015`
- `arithmetic_grade3_foundation_010`
- `arithmetic_grade5_foundation_028`
- `arithmetic_grade3_foundation_036`
- `arithmetic_grade4_foundation_026`
- `logic_grade6_foundation_015`

## Next Actions

1. Review the remaining `geometry/perimeter_area` family carefully; this is still the largest active cluster.
2. Prioritize the current top arithmetic shells next: `inclusion_exclusion`, `multi_step`, `number_line`, `page_numbering`, `overlap_counting`.
3. Review residual logic families next: `grid_elimination`, `grouping_balance`, `pigeonhole`, `position`, `truth_deduction`, `ranking`.
4. Add more structure tags only when a cluster is demonstrably a false positive family rather than real duplicate risk.
5. After each rewrite or rule refinement, rerun:

```bash
dart run tool/question_bank_duplicate_audit.dart > docs/question-bank-duplicate-audit-2026-07-28.json
flutter test test/question_bank_duplicate_audit_test.dart test/question_bank_test.dart
```

6. When a candidate is reviewed, mark it explicitly as:
   `acceptable_variant` / `corrected` / `merged-away`

## 2026-08-28 續審：題幹逐字相同的三組

用重疊係數（交集 / 較短的一邊）重掃全庫，抓出三組題幹**逐字完全相同**的題。
這三組都標著 `reviewStatus: ok`——grade1-6 的逐題稽核核對的是答案、選項、
四語系解法與圖形，從未把題目兩兩相比（六份稽核文件裡「重複／去重」出現 0 次）。

| 組 | 處理 | 說明 |
| --- | --- | --- |
| `geometry_grade1_002` ≡ `geometry_grade1_015` | 改寫 015 | 同一個 pack 內逐字相同。grade1-2 的「剪掉一個角」家族已有 7 題，015 改成辨識「哪一種剪法會得到三角形＋四邊形」，要逐一檢查四種剪法。 |
| `geometry_grade4_022` ≡ `geometry_grade6_018` | 兩題都改寫 | 另有 `geometry_grade3_019` 是同模板換數字。缺口模板保留 grade3_019 一題代表；022 改成「中間挖洞，周長要加上洞的一圈」，018 改成地毯避柱的實際情境並改問裁完後的周長。 |
| `arithmetic_grade5_062` ≡ `logic_grade6_047` | **不動** | 這不是重複匯入：兩題分屬 IMC 2015 台灣區初賽的國小五年級卷與六年級卷，都是各自考卷的「選擇 21」，官方原本就在兩個年級出了同一題。兩題各自忠於自己的 `sourceUrl`，改寫任一題都會讓 `source` 對不上出處。 |

### 方針（2026-08-28 使用者裁示）

近似題**優先改寫應用情境與數字**，不要動輒刪題——刪題會一直卡住，而且可能刪到
測試引用的題（`arithmetic_grade5_062` 就被 `question_bank_test.dart` 引用）。
刪題前務必先 `grep` 測試檔：目前有 196 個題目 id 被測試引用。

## 2026-08-28 去重改寫（共 54 題）

方針：**改寫應用情境，不刪題**。答案與推理核心一律不動，只把跨年級共用的抽象句型
換成各自的情境；只有兩題連數字都撞到，才一併換數字。

處理的群組（依 `tool/question_bank_duplicate_audit.dart` 的候選 + 重疊係數排序）：

| 群組 | 題數 | 改寫方向 |
| --- | --- | --- |
| arithmetic/pattern、logic/pattern | 10 | 原本都是「數列是 a、b、c、d。下一個數是多少？」→ 保齡球瓶、小樹苗、存錢筒、電影院座位、飲料機、體育館分區、方塊排正方形、跳格子、積木塔、貼紙 |
| arithmetic/pair_counting | 2 | 「從 1 到 n 任選兩數和為 k」→ 拿卡片、號碼牌配對 |
| logic/position ×2 群 | 9 | 「X 藏在 1 到 n 號 Y」→ 排隊、樓層、月份、書架、公車站、車廂、公休日、停車位、補給站 |
| arithmetic/inclusion_exclusion | 4 | 「1 到 N 中…的數有幾個」→ 社團分工、置物櫃標籤、停車場設施、園遊會兌換 |
| logic/state_tracking | 2 | 「N 盞燈切換」→ 電風扇、電子看板 |
| geometry/scale_factor | 3 | 「長寬變化求面積倍數」→ 照片放大、看板裁製、菜圃改建 |
| 其餘單組 | 14 | elimination、lines_angles、position_direction、truth_deduction、perimeter_invariance、perimeter_area、scheduling、shape_cutting、pair_sum、route_counting 各一到兩題 |

`arithmetic/inclusion_exclusion` 原本在 2026-07-28 被裁決為 `acceptable_variant`，
2026-08-28 依使用者指示一併改寫。

### 成效

組內最高重疊係數的分布：

| 區間 | 改寫前 | 改寫後 |
| --- | --- | --- |
| ≥ 0.80 | 16 組 | 5 組 |
| 0.65–0.80 | 15 組 | 9 組 |
| < 0.45 | 90 組 | 99 組 |

改寫後仍 ≥ 0.65 的 14 組**全部**是 grade7-12 那批「情境相同、問法不同」的既有裁示保留題
（id 以 `_031` / `_032` 結尾）。grade1-6 已無待議群組。

### 順手修掉的既有瑕疵

- `logic_grade6_018` 原本是**多解題**：條件「大於 4、小於 10、不是 9 和 8 和 6」同時允許 5 和 7，答案卻標 5。補一個排除條件後解唯一。寫詳解、把消去過程逐步寫出來時才發現。
- `geometry_grade3_007`、`geometry_grade3_012` 的 `coordinate_plane` 圖**把答案畫出來了**：題目問「現在在起點的哪個方向」，圖卻畫出完整路徑並標上「終點」。兩題改為 `kind: none`，並在 `scripts/validate_question_packs.py` 補上這條檢查。
- `logic_grade4_015` 改寫時我把英文答案寫成 April，但答案值是 4，英文使用者無從得知要填數字；改為以月份數字敘述。

### 第四批：0.45–0.65 區間（10 題）

這一區間有不少是工具按 topic + subtopic 分組造成的鬆散配對，兩題其實推理不同，
只是共用開頭句型。依使用者指示一併改寫，推理與答案完全不動：

| 題 | 改成 |
| --- | --- |
| `geometry_grade3_007` | 方格移動 → 棋盤上的棋子 |
| `geometry_grade2_046` | 正方形卡片旋轉 → 牆上的正方形相框 |
| `logic_grade5_035` | 抽象數列遞迴 → 電子遊戲關卡分數 |
| `geometry_grade1_029` | 正方形加兩三角形 → 美勞課色紙拼貼 |
| `arithmetic_grade4_015` | 任選兩數和為偶數 → 抽獎箱號碼球 |
| `geometry_grade6_026` | 長寬倍率求面積 → 海報重新印製 |
| `geometry_grade5_046` | 方格街道最短路線 → 公園步道，往東往北 |
| `arithmetic_grade2_049` | 三色積木抽屜原理 → 三種口味水果糖 |
| `logic_grade6_028` | 三數兩兩相加 → 園遊會三個攤位得分 |
| `logic_grade2_024` | 兩人各一句話 → 兄妹猜箱中球數 |

### 最終狀態

| 區間 | session 起點 | 完成後 |
| --- | --- | --- |
| ≥ 0.80 | 16 組 | 5 組 |
| 0.65–0.80 | 15 組 | 8 組 |
| 0.45–0.65 | 13 組 | 4 組 |
| < 0.45 | 90 組 | 104 組 |

**grade1-6 已無待議群組（從 27 組降到 0 組）。** 仍在 0.45 以上的 17 組全部是
grade7-12 那批「情境相同、問法不同」的既有裁示保留題（id 以 `_031` / `_032` 結尾）。
