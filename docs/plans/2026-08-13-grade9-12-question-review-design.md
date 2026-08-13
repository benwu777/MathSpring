# Grade 9-12 題庫複審設計

日期：2026-08-13
分支：`feature/grade10-12-question-review`（自 main 開 worktree）

## 目標

讓 grade7-12 全部 282 題的 `reviewStatus` 都變成 `ok`，使其能實際進入練習／測驗出題池。

現況盤點：

| 年級 | 題數 | 狀態 |
| --- | --- | --- |
| grade7 | 47 | 47 ok |
| grade8 | 47 | 47 ok |
| grade9 | 47 | 25 ok / 22 needs_fix |
| grade10 | 47 | 47 pending |
| grade11 | 47 | 47 pending |
| grade12 | 47 | 47 pending |
| 合計 | 282 | 119 ok / 22 needs_fix / 141 pending |

每年級的 pack 組成固定為 algebra 9 / combinatorics 9 / geometry 10 / logic 9 / number_theory 10。

本輪工作範圍：163 題（grade9 的 22 題 + grade10-12 的 141 題）。

## 批次順序

| 批次 | 內容 | 題數 |
| --- | --- | --- |
| 1 | grade9 五個 pack 的 `needs_fix` | 22 |
| 2 | grade10 五個 pack `pending` | 47 |
| 3 | grade11 五個 pack `pending` | 47 |
| 4 | grade12 五個 pack `pending` | 47 |

## 逐題流程

依 `docs/question-bank-expansion-guidelines.md`，每題依序檢查：

1. **獨立重算答案** — 不信任初稿，自己重解一次，確認 `correctAnswer` / `answer` / `solutionSteps` 三者一致
2. **奧數複審六點** — 是否有真正推理轉折、是否為裸題、是否為模板弱變形、深度是否貼齊年級
3. **去重比對** — 同 `topic + subtopic` 內比對解法骨架，答完四個必答去重問題
4. **source 檢查** — 不得出現 `MathSpring Editorial Original`；來源必須可追溯
5. **figure 檢查** — geometry pack 專屬；圖必須真的畫出題目條件，標籤不得重疊或誤導
6. **排版檢查** — `^` 冪次等程式式寫法改為 Unicode 上標
7. **四語系檢查** — zh-Hant / zh-Hans / en / ja 齊全，`solutionSteps` 四語系陣列長度一致

### 不合格題的處理

**當場修到 `ok`**，不留 `needs_fix` 過夜。

來源策略（依優先序）：

1. 先用 WebSearch 找該年級難度基準對應的真實公開競賽題，改寫後填完整 `source`（競賽名 + 年份 + 回合/division + 題號）
2. 找不到對應題型，才退回 `source.type = rewritten_olympiad_style`，並在 `source.notes` 寫明設計依據

重寫後的題必須重跑上述完整流程，**不因為是新寫的就跳過去重比對**。

## 難度基準

本輪新確立 grade10-12 的競賽級別對應（現有文件缺此定義）：

| 年級 | 對齊競賽 | 說明 |
| --- | --- | --- |
| grade7 | IMC Taiwan 複賽 7 年級 / AMC 8 | 沿用既有慣例 |
| grade8 | IMC Taiwan 複賽 8 年級 / AMC 8 | 沿用既有慣例 |
| grade9 | IMC Taiwan 複賽 9 年級 / AMC 10A | 沿用既有慣例 |
| grade10 | AMC 10 | 高中前段，代數／幾何／數論基本技巧的組合運用 |
| grade11 | AMC 12 | 含三角、對數、複數、進階函數 |
| grade12 | AIME 入門層 | 需多步推理，答案為 0-999 整數的題型體感 |

判定原則：

- 明顯低於基準兩級的裸題不收
- 明顯超出基準的（例如 grade10 出現 IMO 層級）改放高年級或不收
- 不得用難度層容納超綱題；`difficulty` 與 `challengeTier` 維持固定 `foundation`

## subtopic 約束

- 新寫或改寫題的 `subtopic` 必須落在 `docs/question-bank-subtopic-registry.md` 的允許集合
- 真的需要才新增，不發明只用一次的臨時子分類
- 分類不得過粗；單一能力題不得標成綜合類

## 文件更新

一併補齊，避免下次接手重問：

- `docs/question-bank-expansion-guidelines.md`：「年級與競賽級別規則」補上 grade7-12 對應表
- `docs/question-bank-taxonomy.md`：Level Structure 同步標註難度基準
- 新開 `docs/question-review-grade10-12-audit.md`，沿用 grade7-9 audit 的欄位（`id / level / topic / subtopic / figure / answerMode / source / status / risk / note`）
- grade9 這 22 題的修正結果更新回既有的 `docs/question-review-grade7-9-audit.md`，不另開檔

## 交付節奏

- **commit 單位**：一個 pack 一個 commit，共 20 個 pack，訊息用繁中
- **每個 pack commit 前必跑**：
  - `flutter test test/question_bank_test.dart`
  - `flutter test test/question_bank_duplicate_audit_test.dart`
  - `dart run tool/question_bank_duplicate_audit.dart`
- **每批（年級）結束加跑**：`flutter test` 全套，並確認 `manifest.questionCount` 與實際題數一致

## 已知風險

1. **geometry pack 的 figure**：grade10-12 共 30 題幾何題未審。需要構造（中點、交點、陰影區、圓弧）的題須用 `geometry_scene` 宣告式規格。renderer 畫不出來時依紅線第 8 條改 `kind:none` 或重寫題目，不硬塞劣質圖。若判斷需補 renderer 能力，屬實作 code，另走 TDD 流程並先與使用者確認。
2. **重寫量未知**：grade9 不合格率 47%。若 grade10-12 比例接近，141 題可能有 60-70 題需重寫。grade10 第一個 pack 完成時回報實際比例，由使用者決定是否調整節奏。
