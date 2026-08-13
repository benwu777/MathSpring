# Grade 10-12 Question Review Audit

這份文件是 10-12 年級題目的逐題審核入口。只有 `reviewStatus = ok` 的題，才允許進入實際練習/測驗出題池。

格式沿用 [question-review-grade7-9-audit.md](question-review-grade7-9-audit.md)。

## 難度基準

本輪確立的年級對應競賽級別（同步寫入 `question-bank-expansion-guidelines.md`）：

| 年級 | 對齊競賽 | 說明 |
| --- | --- | --- |
| `grade10` | AMC 10 | 高中前段，代數／幾何／數論基本技巧的組合運用 |
| `grade11` | AMC 12 | 含三角、對數、複數、進階函數 |
| `grade12` | AIME 入門層 | 需多步推理，答案為 0-999 整數的題型體感 |

## 欄位說明

- `status`: `pending / needs_fix / fixed / ok / blocked`
- `risk`: 高風險項，例如 `source`, `correctness`, `duplication`, `figure`, `math_notation`, `bare`, `schema`
- `note`: 本題實際修正或阻塞原因

## 複審起始狀態

grade10-12 共 141 題，進入本輪時全部為 `pending`（從未複審）。機械化篩檢結果：

| 問題類型 | grade10 | grade11 | grade12 | 合計 |
| --- | --- | --- | --- | --- |
| 自製 editorial 暫代來源 | 15 | 15 | 15 | 45 |
| 詳解僅 2-3 步（裸題嫌疑） | 14 | 15 | 19 | 48 |
| 四語系步數不一致 | 0 | 2 | 4 | 6 |
| 同 pack subtopic 重複 | 0 | 2 | 0 | 2 |

每個 pack 的第 004、005、006 題固定為自製 editorial 來源，與 grade7-9 同一模式。

另有跨 pack / 跨年級重複（由 `tool/question_bank_duplicate_audit.dart` 與人工比對發現）：

- `algebra_grade10_007` ↔ `algebra_grade10_009`（同一 IMC 題，subtopic 命名不同而躲過機械篩檢）
- `number_theory_grade10_007` ↔ `number_theory_grade11_001`（factorial_remainder）
- `algebra_grade11_007` ↔ `algebra_grade11_009`（log_exponential_equation）
- `number_theory_grade12_003` ↔ `number_theory_grade8_004`（divisor_count）

## 題目清單

| id | level | topic | subtopic | figure | answerMode | source | status | risk | note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `algebra_grade10_foundation_001` | `grade10` | `algebra` | `指數與對數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 4 | `ok` | bare | 答案 2 正確（1/x − 1/y = log₃(7.2÷0.8) = log₃9）；原詳解僅 3 步且跳過取對數過程，已補為 6 步完整推導 |
| `algebra_grade10_foundation_002` | `grade10` | `algebra` | `二次函數值域` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 10年級 選擇 5 | `ok` | correctness | **原選項錯誤**：a = 2 與 a = 5 都成立（已驗證兩端點的 max/min 皆為 12 與 3），正確範圍是 2 ≤ a ≤ 5，但原選項只有 `2 < a < 5`；已改選項為 `2 ≤ a ≤ 5` 並保留 `2 < a < 5` 作為漏端點的誘答項，詳解補上端點逐一檢查 |
| `algebra_grade10_foundation_003` | `grade10` | `algebra` | `等比數列` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 7 | `ok` | solution | 答案 60 正確（數值掃描確認唯一解 a = 15、r = 3）；原詳解第 3 步寫「依官方解法可化成 a(1+r) = 60」屬空轉，已補為分組因式 → 消元 → 驗證 r = 3 的 9 步完整推導 |
| `algebra_grade10_foundation_004` | `grade10` | `algebra` | `含參數二次不等式` | `none` | `integer_input` | 改寫題（含參數二次不等式整數解） | `ok` | source, bare, rewritten | 原題為機械求解 \|2x−5\|<9 再數整數，無推理轉折且來源為自製 editorial 暫代出處；改寫為 (x−1)(x−a)<0 整數解恰 3 個求 a 之和，需依 a>1 / a<1 分兩支討論，答案 2 已窮舉 a ∈ [−20,20] 驗證 |
| `algebra_grade10_foundation_005` | `grade10` | `algebra` | `分式遞推週期` | `none` | `integer_input` | 改寫題（分式遞推週期） | `ok` | source, bare, rewritten | 原題為因式分解求較大根的裸題且來源為自製 editorial 暫代出處；改寫為 a₁=2、aₙ₊₁=(1+aₙ)/(1−aₙ) 求 a₂₀₂₆，需發現週期 4，答案 −3 已用 Fraction 精確計算前九項驗證 |
| `algebra_grade10_foundation_006` | `grade10` | `algebra` | `根式方程與增根` | `none` | `integer_input` | 改寫題（雙根式方程與增根） | `ok` | source, bare, rewritten | 原題為兩步移項的分式方程裸題且來源為自製 editorial 暫代出處；改寫為 √(2x+3)+√(x−2)=4，需在兩次平方間記下 11−x ≥ 0 才能排除增根 x=83，答案 3 已用判別式與代回雙重驗算 |
| `algebra_grade10_foundation_007` | `grade10` | `algebra` | `參數整數根` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 6 | `ok` | duplication | 答案 8 正確（(x−a)(x−8)=1 且 x 為整數 → x−8 = ±1 → a = 8）；保留本題為此 IMC 題的唯一版本，原 009 的重複收錄已改寫 |
| `algebra_grade10_foundation_008` | `grade10` | `algebra` | `循環小數差` | `none` | `multiple_choice` | AMC 10A 2021 Problem 8 | `ok` |  | 答案 75 正確（66×ab×(1/99 − 1/100) = ab/150 = 0.5）；四語系與詳解完整 |
| `algebra_grade10_foundation_009` | `grade10` | `algebra` | `對稱冪和遞推` | `none` | `multiple_choice` | 改寫題（對稱冪和遞推） | `ok` | duplication, rewritten | 原與本 pack 007 為同一 IMC 題（(x−a)(x−8)−1=0 求 a），只是答題方式不同，屬重複收錄已淘汰；改寫為 x+1/x=3 求 x⁵+1/x⁵，需建立遞推 pₙ₊₁=3pₙ−pₙ₋₁，答案 123 已用遞推與數值代入雙重驗證 |
