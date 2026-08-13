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
| `combinatorics_grade10_foundation_001` | `grade10` | `combinatorics` | `配對選取` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 3 | `ok` |  | 答案 210 正確（C(8,2)×C(6,2)÷2，已用集合窮舉 8 人所有無序雙隊配對驗證） |
| `combinatorics_grade10_foundation_002` | `grade10` | `combinatorics` | `受限分配` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 填充 3 | `ok` | bare | 答案 84 正確（先每盒發 1 球後插板 C(9,3)，已窮舉驗證）；原詳解僅 3 步，已補為 7 步含插板法的位置對應說明 |
| `combinatorics_grade10_foundation_003` | `grade10` | `combinatorics` | `三維格點路徑` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 8 | `ok` | bare | 答案 30 正確（多重集排列 5!/(2!2!1!)，已窮舉驗證）；原詳解僅 3 步，已補為 7 步含路徑與字串的一一對應說明 |
| `combinatorics_grade10_foundation_004` | `grade10` | `combinatorics` | `部分錯排` | `none` | `integer_input` | 改寫題（部分錯排） | `ok` | source, rewritten | 原題為 BANANA 多重集排列的教科書例題且來源為自製 editorial 暫代出處；改寫為「5 封信恰好 2 封放對」，需察覺剩下 3 封必須全錯而非隨便排，C(5,2)×D₃=10×2=20，已用 5! 全排列按固定點個數窮舉驗證 |
| `combinatorics_grade10_foundation_005` | `grade10` | `combinatorics` | `有上界的整數解計數` | `none` | `integer_input` | 改寫題（有上界的整數解計數） | `ok` | source, duplication, rewritten | 原題為「至少一位女生」補集法，與 `combinatorics_grade7_foundation_005` 同一骨架，且來源為自製 editorial 暫代出處；改寫為 x+y+z=15 且各 ≤6 的解數，主解用 a=6−x 補集代換得 C(5,2)=10，詳解另附排容驗算，已三重迴圈窮舉確認 |
| `combinatorics_grade10_foundation_006` | `grade10` | `combinatorics` | `前綴限制排列` | `none` | `integer_input` | 改寫題（反射原理與前綴限制） | `ok` | source, bare, rewritten | 原題為「個位必須是 5、其餘 4! 排列」的兩步裸題且來源為自製 editorial 暫代出處；改寫為 5 紅 3 藍排列且每個前綴紅 ≥ 藍，用反射原理把壞排法對應到 6 紅 2 藍得 56−28=28，已窮舉全部 56 種排法驗證 |
| `combinatorics_grade10_foundation_007` | `grade10` | `combinatorics` | `區域著色` | `none` | `integer_input` | AMC 12A 2022 Problem 7 | `ok` | correctness | **原題幹未定義**：只說「長方形被分成 5 個區域」卻沒有圖也沒描述相鄰結構，答案無法確定（詳解卻假設了特定配置）；已改題幹明確標示 A–E 五區並列出全部相鄰配對 A–B、A–C、A–D、B–D、B–E、C–D、D–E，答案 540 已用 5⁵ 全塗法窮舉該相鄰結構驗證 |
| `combinatorics_grade10_foundation_008` | `grade10` | `combinatorics` | `賽程計數` | `none` | `integer_input` | AMC 10A 2013 Problem 24 | `ok` |  | 答案 900 正確（已用 6⁶ 種輪次組合窮舉，篩出每個對戰組合恰出現 2 次者，得 900） |
| `combinatorics_grade10_foundation_009` | `grade10` | `combinatorics` | `多項式係數比` | `none` | `integer_input` | AMC 10A Fall 2021 Problem 21 | `ok` | correctness | **原答案錯誤**：原標 20，正確為 16。原詳解第 4 步宣稱「3!5! = 4!4!」，但 3!×5! = 720 而 4!×4! = 576，並不相等；正確計算為 p/q = 20 × (4!)²/(3!5!) = 20 × 576/720 = 16，已用實際多項式係數計算驗證 |
| `geometry_grade10_foundation_001` | `grade10` | `geometry` | `直線與圓相交` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 10年級 選擇 2 | `ok` | figure | 答案 −28 < k < 22 正確（圓心 (1,0)、半徑 5，\|k+3\|/5 < 5）；原 figure 為 `shape_diagram` 只畫一個圓再貼「C(1,0)／r=5／L」文字，直線 L 根本沒畫出來，屬紅線 7 的「畫外框貼字」，依紅線 8 改為 `kind:none`（k 是變動參數，畫任一條具體直線都會誤導） |
| `geometry_grade10_foundation_002` | `grade10` | `geometry` | `投影與垂直` | `coordinate_plane` | `multiple_choice` | IMC Taiwan 2026 複賽 10年級 填充 2 | `ok` |  | 答案 2x − 3y = 17 正確（AA₀ 斜率 −3/2 → L 斜率 2/3，過 A₀(7,−1)）；圖為 coordinate_plane 且點位正確 |
| `geometry_grade10_foundation_003` | `grade10` | `geometry` | `圓上最大三角形面積` | `coordinate_plane` | `multiple_choice` | IMC Taiwan 2026 複賽 10年級 選擇 9 | `ok` |  | 答案 (6,9) 或 (6,−9) 正確（圓心 (6,±4)，已驗 \|OA\| = 5，最遠點距 AB 為 9） |
| `geometry_grade10_foundation_004` | `grade10` | `geometry` | `兩圓外公切線長` | `geometry_scene` | `integer_input` | 改寫題（兩圓外公切線長） | `ok` | source, bare, rewritten | 原題為「半徑垂直切線再套畢氏」的四步裸題且來源為自製 editorial 暫代出處；改寫為兩圓外切（半徑 4、9）求外公切線切點距離，需平移半徑差建直角三角形，答案 12 已驗證圓心距 13、兩圓皆與切線相切 |
| `geometry_grade10_foundation_005` | `grade10` | `geometry` | `平行弦距離` | `geometry_scene` | `integer_input` | 改寫題（平行弦距離） | `ok` | source, bare, rewritten | 原題為切割線定理一步代入的裸題且來源為自製 editorial 暫代出處；改寫為半徑 10 圓中兩平行弦長 12、16 分居圓心兩側求弦距，關鍵在同側／異側決定加減（同側為 2、異側為 14），答案 14；圖中四個弦端點已驗證皆在圓上且弦長與平行關係吻合 |
| `geometry_grade10_foundation_006` | `grade10` | `geometry` | `正方形中點三角形面積` | `geometry_scene` | `integer_input` | 改寫題（正方形中點三角形面積） | `ok` | source, bare, rewritten | 原題為重心 2:1 一步代入的裸題且來源為自製 editorial 暫代出處；改寫為邊長 8 正方形中兩邊中點構成的三角形面積，用補集法扣三個角落得 64−40=24，已另以鞋帶公式驗算；圖以等長記號畫出中點並將 AMN 標為陰影區 |
| `geometry_grade10_foundation_007` | `grade10` | `geometry` | `長方形切角` | `none` | `multiple_choice` | AMC 10B 2021 Problem 9 | `ok` | figure | 答案 18 正確（a+b = 10、a²+b² = 64 → ab = 18，已驗 (a−2)²+(b−2)² = 32）；原 figure 為 `shape_diagram` 只畫一個長方形再貼「對角線=8／切去 1×1／最近距離=4√2」文字，缺角完全沒畫，屬紅線 7 違規，依紅線 8 改為 `kind:none`（題幹已描述完整；後續可補正式 geometry_scene 八邊形） |
| `geometry_grade10_foundation_008` | `grade10` | `geometry` | `四邊形邊長上界` | `none` | `multiple_choice` | AMC 10A 2015 Problem 10 | `ok` | figure | 答案 12 正確（最長邊 a < 26 − a → a ≤ 12，且 12、4、5、5 可行）；原 figure 為 `shape_diagram` 只畫一個四邊形再貼「周長 26／其中一邊 4／最長邊？」文字，對解題零幫助且屬紅線 7 違規，已改為 `kind:none` |
| `geometry_grade10_foundation_009` | `grade10` | `geometry` | `內心外心距離` | `geometry_scene` | `multiple_choice` | AMC 12B 2011 Problem 16 | `ok` |  | 答案 √65/2 正確（r = 30/15 = 2、R = 13/2，Euler 關係 OI² = R(R−2r) = 65/4，已驗算） |
| `geometry_grade10_foundation_010` | `grade10` | `geometry` | `正方形內正三角形面積比` | `geometry_scene` | `multiple_choice` | AMC 10B 2016 Problem 20 | `ok` |  | 答案 2 正確（x²+2x−2 = 0 → x = √3−1，已驗 EF² = BE²，面積比 x²/(1−x) = 2） |
