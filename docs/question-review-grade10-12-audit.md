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
| `logic_grade10_foundation_001` | `grade10` | `logic` | `天平稱重` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 1 | `ok` |  | 答案 2 正確（9 顆分三組、三分法兩次）。註：本題保留為天平稱重家族的正式版本；`logic_grade9_foundation_006` 先前被改寫成 12 枚硬幣稱重題與本題撞型且難度倒掛，已同批改為雙水壺題 |
| `logic_grade10_foundation_002` | `grade10` | `logic` | `整除條件` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 填充 1 | `ok` | bare, topic | 答案 13 正確（n−1 為 lcm(2,3,4)=12 的倍數）；原詳解僅 3 步已補為 7 步。分類偏差：本題核心能力其實是數論而非邏輯，因調整 pack 會牽動題數與 manifest，暫留在 logic 並記錄 |
| `logic_grade10_foundation_003` | `grade10` | `logic` | `兩位數計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 2 | `ok` | bare, topic | 答案 6 正確（每組兩張卡恰對應 1 個合格數，C(4,2)=6，已列出 21/31/32/41/42/43）；原詳解僅 3 步已補為 7 步。分類偏差同 002，核心能力偏組合 |
| `logic_grade10_foundation_004` | `grade10` | `logic` | `名次真假話推理` | `none` | `multiple_choice` | 改寫題（名次真假話推理） | `ok` | source, olympiadness, rewritten | 原題為三人三水果且已直接給定丙的答案，僅需兩步消去，深度遠低於本年級，且來源為自製 editorial 暫代出處；改寫為四人名次、恰好一句假話，四種候選分別產生 3/2/1/2 句假話故答案唯一為 C，已窮舉驗證 |
| `logic_grade10_foundation_005` | `grade10` | `logic` | `多重限制排列計數` | `none` | `integer_input` | 改寫題（多重限制排列計數） | `ok` | source, bare, rewritten | 原題為「切換 10 次、偶數次故回到原狀」的單步奇偶裸題且來源為自製 editorial 暫代出處；改寫為五人排隊同時受綁塊、相對順序、端點排除三種限制，答案 12 已用 5! 全排列逐條件檢查窮舉驗證 |
| `logic_grade10_foundation_006` | `grade10` | `logic` | `翻杯子最少次數` | `none` | `integer_input` | 改寫題（翻杯子最少次數） | `ok` | correctness, source, rewritten | **原題有兩組解**：獎品在 B（原標答案）與獎品在 A 都恰好只有一句真話，已窮舉四種情況確認；原詳解宣稱「若獎品在 A 會變成零句真話」是錯的。不符唯一明確答案且來源為自製 editorial 暫代出處，整題淘汰；改寫為 8 杯每次翻 3 個的最少次數，需用奇偶不變量把樸素下界 3 提升到 4 再給構造 {1,7,8}{2,7,8}{3,7,8}{4,5,6}，答案 4 已用 BFS 與構造雙重驗證 |
| `logic_grade10_foundation_007` | `grade10` | `logic` | `真假話型態統計` | `none` | `integer_input` | AMC 10B 2013 Problem 23 | `ok` | correctness | 答案 7 正確（A₁=9、L=6、T=7、A₂=9，總數 31 與三題「是」的人數 22/15/9 全部吻合）；但**原題幹缺少關鍵條件**——全文從未提到糖果卻問「一共拿到了幾顆糖」，已補回「每當一個孩子回答『是』就得到一顆糖」 |
| `logic_grade10_foundation_008` | `grade10` | `logic` | `分段遞迴數列` | `none` | `integer_input` | 改寫題（分段遞迴數列） | `ok` | duplication, rewritten | **原題與 `logic_grade9_foundation_007` 完全相同**（同樣的 Tadd/Todd/Tucker 報數規則、同樣問 Tadd 說出的第 2019 個數、同樣答案 5979），因 subtopic 命名不同（turn_sequence vs rotating_count_sequence）而未被去重稽核抓到；grade9 那題保留為正式版本，本題改寫為奇偶分段遞迴數列求第 20 項，答案 1 已逐項計算驗證 |
| `logic_grade10_foundation_009` | `grade10` | `logic` | `真假話種族推理` | `none` | `multiple_choice` | AMC 8 2010 Problem 22 | `ok` |  | 答案 3 正確；已窮舉 2⁴ 種真假指派，自洽解有兩組（Chris 與 LeRoy 誰是蟾蜍不唯一），但兩組的青蛙數都是 3，所求答案唯一 |
| `number_theory_grade10_foundation_001` | `grade10` | `number_theory` | `湊因式的整數方程` | `none` | `integer_input` | 改寫題（湊因式的整數方程） | `ok` | bare, duplication, rewritten | 原題只需套一次「兩數乘積 = gcd × lcm」得 36，屬兩步裸題；且與本輪改寫的 `number_theory_grade9_foundation_004`（同樣給定 gcd 與 lcm）設定重疊而 grade9 版本反而較難，形成難度倒掛，整題淘汰；改寫為 xy = x+y+13 求 x+y 最大值，需補 1 湊出 (x−1)(y−1)=14，答案 17 已窮舉驗證解為 (2,15) 與 (3,8) |
| `number_theory_grade10_foundation_002` | `grade10` | `number_theory` | `一次不定方程` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 計算 2 | `ok` | bare | 答案 58 正確（y ≡ 3 mod 5 且 0 ≤ y ≤ 289，已窮舉驗證）；原詳解僅 4 步，已補為 8 步含範圍界定、同餘求解與最大項驗算 |
| `number_theory_grade10_foundation_003` | `grade10` | `number_theory` | `整除條件` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 6 | `ok` | correctness | **原答案錯誤**：原標 a+b = 12。窮舉全部 100 組 (a,b) 後，形如 2a5b 且被 36 整除的四位數只有 2052（a+b=2）、2556（a+b=11）、2952（a+b=11），最大值為 **11** 而非 12。已更正答案並改寫詳解，補上 a+b ≤ 9+6 = 15 的上界論證與兩組達成 11 的實例 |
| `number_theory_grade10_foundation_004` | `grade10` | `number_theory` | `階乘末尾零的個數` | `none` | `integer_input` | 改寫題（階乘末尾零反推） | `ok` | source, duplication, rewritten | 原題（7²⁰²⁶ 的個位數）與本輪改寫的 `number_theory_grade9_foundation_006`（7²⁰²⁶ 的末兩位）同底同指數，屬重複收錄，且來源為自製 editorial 暫代出處；改寫為求 n! 末尾恰好 25 個 0 的最小 n，刻意選在 n=99→22、n=100→24 的跳號處（23 個 0 不存在），答案 105 已用 Legendre 公式逐一計算驗證 |
| `number_theory_grade10_foundation_005` | `grade10` | `number_theory` | `相鄰二次式的最大公因數` | `none` | `integer_input` | 改寫題（相鄰二次式的最大公因數） | `ok` | source, bare, rewritten | 原題直接套 Legendre 公式相加求 100! 中 2 的指數，屬三步裸題且來源為自製 editorial 暫代出處；改寫為 gcd(n²+5, (n+1)²+5) 的最大值，需先相減得 d | 2n+1、論證 d 為奇數後乘 4 湊出 4n²+20 = (2n+1)(2n−1)+21 壓到 d | 21，再解 n ≡ 10 (mod 21) 證明可達，答案 21 已用 n=1..4999 實際 gcd 掃描驗證 |
| `number_theory_grade10_foundation_006` | `grade10` | `number_theory` | `數字對調條件` | `none` | `integer_input` | 改寫題（三位數對調條件） | `ok` | source, bare, rewritten | 原題為「依次試小的正整數」求 3x ≡ 1 (mod 10)，無推理成分且來源為自製 editorial 暫代出處；改寫為三位數首尾對調小 297 且數字和 15 的個數，需察覺差恆為 99(a−c) 並同時檢查 a≤9、c≥1、0≤b≤9 三組限制（b≤9 導出的 c≥2 最易漏），答案 5 已用全部三位數窮舉驗證為 582、663、744、825、906 |
| `number_theory_grade10_foundation_007` | `grade10` | `number_theory` | `階乘和的餘數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 10年級 選擇 1 | `ok` | duplication | 答案 25 正確（已用實際計算 S = 1!+…+100! 驗證 S² mod 28 = 25）。**待處理**：與 `number_theory_grade11_foundation_001` 被去重稽核標為同群（factorial_remainder），本題保留為正式版本，grade11 那題待複審時改寫 |
| `number_theory_grade10_foundation_008` | `grade10` | `number_theory` | `最大公因數連鎖` | `none` | `integer_input` | AMC 10A 2018 Problem 22 | `ok` |  | 答案 13 正確（推得 gcd(a,d) = 6k 且 70 < 6k < 100，候選 72/78/84/90/96 中只有 78 = 6×13 的額外因數不含 2、3，已逐一驗證） |
| `number_theory_grade10_foundation_009` | `grade10` | `number_theory` | `十六進位數字` | `none` | `integer_input` | AMC 10A 2015 Problem 18 | `ok` | notation | 答案 21 正確（已窮舉 1~1000 得 n = 399，數字和 21）；原詳解出現錯字「百六進位位」，已更正為「十六進位的百位」並補上 3 9 9₁₆ = 921 ≤ 1000 的上界確認 |
| `number_theory_grade10_foundation_010` | `grade10` | `number_theory` | `數字和規律` | `none` | `multiple_choice` | AMC 10A 2014 Problem 20 | `ok` |  | 答案 991 正確（乘積規律為 7、(k−2) 個 1、0、4，數字和 = k+9；已對 k=1..5 驗證規律，並直接計算 k=991 的乘積確認數字和為 1000） |
