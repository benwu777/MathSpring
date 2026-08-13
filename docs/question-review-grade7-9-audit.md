# Grade 7-9 Question Review Audit

這份文件是 7-9 年級題目的逐題審核入口。只有 `reviewStatus = ok` 的題，才允許進入實際練習/測驗出題池。

## 欄位說明

- `status`: `pending / needs_fix / fixed / ok / blocked`
- `risk`: 先記高風險項，例如 `source`, `mixed`, `figure`, `math_notation`, `duplication`
- `note`: 補本題實際修正或阻塞原因

## 題目清單

| id | level | topic | subtopic | figure | answerMode | source | status | risk | note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `algebra_grade7_foundation_001` | `grade7` | `algebra` | `百分率逆推` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 選擇 1 | `ok` |  | 連續九折→0.81 推理成立，答案 100000 正確 |
| `algebra_grade7_foundation_002` | `grade7` | `algebra` | `代數式與聯立` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 3 | `ok` |  | 定義運算+聯立，答案 4 正確；009 為其重複題 |
| `algebra_grade7_foundation_003` | `grade7` | `algebra` | `多項式係數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 選擇 6 | `ok` | math_notation | 已將 x^2/x^3 改為上標 x²/x³；答案 6 正確 |
| `algebra_grade7_foundation_004` | `grade7` | `algebra` | `數字與方程` | `none` | `integer_input` | 改寫題（數字反轉聯立） | `ok` | source | 來源由 Editorial Original 改為 rewritten_olympiad_style（附設計依據）；答案 74 正確 |
| `algebra_grade7_foundation_005` | `grade7` | `algebra` | `一次方程` | `none` | `integer_input` | 改寫題（年齡問題） | `ok` | rewritten | 原裸方程已改寫為年齡倍數應用題（列 3x+5=2(x+5)），答案 5 正確 |
| `algebra_grade7_foundation_006` | `grade7` | `algebra` | `連續整數` | `none` | `integer_input` | 改寫題（連續整數之和） | `ok` | rewritten | 原單步裸題已改寫為「45 表為連續正整數之和的方法數」，答案 5 正確 |
| `algebra_grade7_foundation_007` | `grade7` | `algebra` | `數線距離差` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 7年級 選擇 2 | `ok` | solution | 詳解原推理錯誤（誤稱 P 在 [3,7] 內才等於 4）已修正；答案 4 正確 |
| `algebra_grade7_foundation_008` | `grade7` | `algebra` | `百分率方程` | `none` | `multiple_choice` | AMC 8 2020 Problem 15 | `ok` |  | 15% x = 20% y，答案 75% 正確 |
| `algebra_grade7_foundation_009` | `grade7` | `algebra` | `自定運算巢狀` | `none` | `integer_input` | 改寫題（自定運算巢狀） | `ok` | rewritten, duplication | 原與 002 完全重複，已改寫為巢狀自定運算 a⊕b=3a-2b、x⊕(x⊕4)=7，答案 3 正確 |
| `algebra_grade8_foundation_001` | `grade8` | `algebra` | `二次方程根` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 4 | `ok` | notation | 代 5 求 a=1，另一根 -9 正確；`^`→上標 |
| `algebra_grade8_foundation_002` | `grade8` | `algebra` | `一次方程組` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 7 | `ok` |  | 交點代入求 a·b=-8，正確 |
| `algebra_grade8_foundation_003` | `grade8` | `algebra` | `等比數列` | `none` | `integer_input` | 改寫題（等比數列） | `ok` | source, duplication | **原與 009 完全重複**，改寫為第2/5項推第4項=24；IMC 選擇8 由 009 保留 |
| `algebra_grade8_foundation_004` | `grade8` | `algebra` | `對稱式` | `none` | `integer_input` | 改寫題（對稱式） | `ok` | source, notation | (x+y)²-2xy=58 正確；`^`→上標；Editorial→rewritten |
| `algebra_grade8_foundation_005` | `grade8` | `algebra` | `聯立方程` | `none` | `integer_input` | 改寫題（二元聯立） | `ok` | source, bare | 原裸解 x+y=11,x-y=3 改寫為消去法求 x+y=12；Editorial→rewritten |
| `algebra_grade8_foundation_006` | `grade8` | `algebra` | `平方差` | `none` | `integer_input` | 改寫題（平方差） | `ok` | source, notation | 51²-49²=200 正確；`^`→上標；Editorial→rewritten |
| `algebra_grade8_foundation_007` | `grade8` | `algebra` | `平方恆等式` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 選擇 6 | `ok` | notation | (a-2b)²=0→a/b=2 正確；`^`→上標 |
| `algebra_grade8_foundation_008` | `grade8` | `algebra` | `方程解的個數` | `none` | `multiple_choice` | AMC 8 2019 Problem 20 | `ok` | notation | (x²-5)²=16 有 4 實解，正確；`^`→上標 |
| `algebra_grade8_foundation_009` | `grade8` | `algebra` | `等比數列總和` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 選擇 8 | `ok` | notation | 11 項等比總和 2047 正確（保留為官方 IMC）；`^`→上標 |
| `algebra_grade9_foundation_001` | `grade9` | `algebra` | `二次函數` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 2 | `ok` | duplication | 拋物線與 x 軸交點距離題本身成立，保留這一題作正式版本；007、009 視為重複題 |
| `algebra_grade9_foundation_002` | `grade9` | `algebra` | `韋達定理辨識` | `none` | `integer_input` | 改寫題（同根辨識與對稱式） | `ok` | duplication, rewritten | 原連乘化簡題與 number_theory 002/010 同題且題型屬數論，已自本 pack 移除；改寫為「a、b 滿足同一式 x²−5x−3=0 之兩根，求 a³+b³」，需先驗判別式 37>0 確認兩根相異，答案 170 已重算 |
| `algebra_grade9_foundation_003` | `grade9` | `algebra` | `配方法` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 填充 4 | `ok` |  | 配方後得 (x+1)²+4(y-1/2)²=0，故 x=-1,y=1/2，x+y=-1/2，答案成立 |
| `algebra_grade9_foundation_004` | `grade9` | `algebra` | `絕對值方程` | `none` | `integer_input` | 改寫題（雙絕對值方程） | `ok` | source, rewritten | 原裸恆等式代入題與自製 editorial 來源已淘汰；改寫為 \|x−3\|+\|x+2\|=7，轉折在先排除中間區間（和恆為 5），再解左右兩側得 4 與 −3，求和 = 1 |
| `algebra_grade9_foundation_005` | `grade9` | `algebra` | `等差數列分段和` | `none` | `integer_input` | 改寫題（等差數列分段和） | `ok` | source, rewritten | 原裸求韋達根和題與自製 editorial 來源已淘汰；改寫為 S₃=21、S₆=78 求 S₉，主解法用分段和成等差外推 93，詳解另附 a₁=3、d=4 聯立驗算，答案 171 |
| `algebra_grade9_foundation_006` | `grade9` | `algebra` | `換元求最小值` | `none` | `integer_input` | 改寫題（換元與算幾不等式） | `ok` | source, correctness, rewritten | 原題 answer 文字（58）與 correctAnswer（100）不一致且來源為自製 editorial，整題淘汰；改寫為 x>0 求 x+16/(x+2) 最小值，需先令 t=x+2 才能套算幾不等式並確認等號點 t=4 在定義域內，答案 6 已代回驗證 |
| `algebra_grade9_foundation_007` | `grade9` | `algebra` | `多項式已知根求值` | `none` | `multiple_choice` | 改寫題（三次多項式因式） | `ok` | duplication, rewritten | 原與 001 同一 IMC 題重複收錄，已淘汰；改寫為 P(x)=x³+ax²+bx+12、P(1)=P(−2)=0 求 P(3)，用因式形式比較常數項得第三根 6，答案 −30；誘答項對應漏負號與常數項誤判 |
| `algebra_grade9_foundation_008` | `grade9` | `algebra` | `一次方程應用` | `none` | `multiple_choice` | AMC 10A 2023 Problem 2 | `ok` |  | 由 1/3P+3.5C=3/4P+0.5C、C=1/4 磅解得 P=9/5 磅，題型與答案成立 |
| `algebra_grade9_foundation_009` | `grade9` | `algebra` | `等速運動聯立` | `none` | `multiple_choice` | 改寫題（火車過隧道聯立） | `ok` | duplication, rewritten | 原與 001、007 同題，已淘汰；改寫為火車過 300m/20s 與 500m/28s 兩隧道求車長，轉折在行進距離為「隧道長＋車身長」，相減消去車長得 v=25，答案 200 已雙式驗算 |
| `combinatorics_grade7_foundation_001` | `grade7` | `combinatorics` | `排列限制` | `none` | `integer_input` | 改寫題（相對順序排列） | `ok` | rewritten, duplication | 原與 009 同為「不相鄰補集法」重複，改寫為相對順序（甲在乙左邊）5!/2=60 |
| `combinatorics_grade7_foundation_002` | `grade7` | `combinatorics` | `格點路徑` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 4 | `ok` |  | C(5,2)=10，路徑↔選上步 對應正確 |
| `combinatorics_grade7_foundation_003` | `grade7` | `combinatorics` | `配對計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 選擇 7 | `ok` |  | 握手 C(6,2)=15，配對觀點正確 |
| `combinatorics_grade7_foundation_004` | `grade7` | `combinatorics` | `圓排列相鄰` | `none` | `integer_input` | 改寫題（圓排列相鄰） | `ok` | source | (6-1)!×2=240 正確；Editorial→rewritten |
| `combinatorics_grade7_foundation_005` | `grade7` | `combinatorics` | `隊伍選取` | `none` | `integer_input` | 改寫題（至少一女生選取） | `ok` | source, bare | 原裸 C(6,3) 改寫為至少一女生（補集）C(9,3)-C(5,3)=74 |
| `combinatorics_grade7_foundation_006` | `grade7` | `combinatorics` | `奇偶計數` | `none` | `integer_input` | 改寫題（組成偶數計數） | `ok` | source | 組成偶數 2×3=6 正確；Editorial→rewritten |
| `combinatorics_grade7_foundation_007` | `grade7` | `combinatorics` | `重複排列` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 8 | `ok` |  | 多重集排列 9!/(3!3!3!)=1680 正確 |
| `combinatorics_grade7_foundation_008` | `grade7` | `combinatorics` | `不同和計數` | `none` | `integer_input` | AMC 8 2011 Problem 8 | `ok` |  | 不同和 3~11 奇數 5 個，正確 |
| `combinatorics_grade7_foundation_009` | `grade7` | `combinatorics` | `受限排列` | `none` | `integer_input` | AMC 8 2020 Problem 10 | `ok` |  | S/T 不相鄰 24-12=12 正確（保留為官方 AMC 題，測試釘選） |
| `combinatorics_grade8_foundation_001` | `grade8` | `combinatorics` | `排列` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 2 | `ok` |  | 4×3×2=24，正確 |
| `combinatorics_grade8_foundation_002` | `grade8` | `combinatorics` | `組合選取` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 填充 5 | `ok` |  | 含甲必選 C(6,2)=15，正確 |
| `combinatorics_grade8_foundation_003` | `grade8` | `combinatorics` | `子集合` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 6 | `ok` | notation | 2⁵−1=31，正確；`^`→上標 |
| `combinatorics_grade8_foundation_004` | `grade8` | `combinatorics` | `限制排列` | `none` | `integer_input` | 改寫題（限制排列） | `ok` | source | 偶數 2×3!=12，正確；Editorial→rewritten |
| `combinatorics_grade8_foundation_005` | `grade8` | `combinatorics` | `格線長方形` | `none` | `integer_input` | 改寫題（格線長方形） | `ok` | source | C(4,2)×C(5,2)=60，正確；Editorial→rewritten |
| `combinatorics_grade8_foundation_006` | `grade8` | `combinatorics` | `整數拆分` | `none` | `integer_input` | 改寫題（隔板法分配） | `ok` | source, bare | 原裸題（10 拆兩正整數=5）改寫為分糖果 C(14,2)=91；Editorial→rewritten |
| `combinatorics_grade8_foundation_007` | `grade8` | `combinatorics` | `整數解計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 填充 7 | `ok` | notation | 硬幣組合＝前11奇數和 11²=121，正確；`^`→上標 |
| `combinatorics_grade8_foundation_008` | `grade8` | `combinatorics` | `受限排列計數` | `none` | `integer_input` | AMC 8 2026 Problem 20 | `ok` |  | 硬幣堆高 g+3s=8，1+6+6=13，正確 |
| `combinatorics_grade8_foundation_009` | `grade8` | `combinatorics` | `機率與座位` | `none` | `multiple_choice` | AMC 8 2011 Problem 12 | `ok` |  | 對面機率 1/3，正確 |
| `combinatorics_grade9_foundation_001` | `grade9` | `combinatorics` | `環狀排列` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 選擇 4 | `ok` |  | 6 人環排，旋轉同一，(6-1)!=120，答案成立 |
| `combinatorics_grade9_foundation_002` | `grade9` | `combinatorics` | `二元字串` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 3 | `ok` |  | 長度 6 恰兩個 1，即 C(6,2)=15，成立 |
| `combinatorics_grade9_foundation_003` | `grade9` | `combinatorics` | `插板法` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 選擇 6 | `ok` |  | 8 顆糖分給 3 人且每人至少 1 顆，C(7,2)=21，成立 |
| `combinatorics_grade9_foundation_004` | `grade9` | `combinatorics` | `帶限制的遞推計數` | `none` | `integer_input` | 改寫題（雙狀態遞推爬樓梯） | `ok` | source, duplication, rewritten | 原「1~8 選 3 個互不相鄰」與本 pack 008 同為隔空一一對應骨架，且來源為自製 editorial 暫代出處，整題淘汰；改寫為 10 階樓梯每次 1 或 2 階、不可連續兩次走 2 階，需依最後一步大小拆兩狀態遞推，答案 41 已用遞推／隔空插入 C(11−2k,k)／窮舉三法互相驗證 |
| `combinatorics_grade9_foundation_005` | `grade9` | `combinatorics` | `格點路徑容斥` | `none` | `integer_input` | 改寫題（雙禁點格點路徑容斥） | `ok` | source, rewritten | 原單一禁點題可直接補集、過於標準且來源為自製 editorial 暫代出處；改寫為 (0,0)→(5,5) 同時禁 (2,2) 與 (3,3)，強迫使用排容，252−(120+120−72)=84，已另以逐格動態規劃驗算一致 |
| `combinatorics_grade9_foundation_006` | `grade9` | `combinatorics` | `環狀著色計數` | `none` | `integer_input` | 改寫題（環狀著色遞推） | `ok` | source, olympiadness, rewritten | 原題為單步奇偶配對計數（答案 4），深度遠低於本年級且來源為自製 editorial 暫代出處；改寫為 5 格圓環三色相鄰異色，剪開得 3×2⁴ 再扣首尾同色導出 aₙ+aₙ₋₁=3×2ⁿ⁻¹，由 a₃=6 推得 a₅=30，已用色多項式與 3⁵ 窮舉雙重驗算 |
| `combinatorics_grade9_foundation_007` | `grade9` | `combinatorics` | `整數三角形計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 5 | `ok` | cross_pack_conflict | 周長 24 的整數三角形共有 12 種，已用程式枚舉核對；number_theory 001 的 15 為錯 |
| `combinatorics_grade9_foundation_008` | `grade9` | `combinatorics` | `不相鄰安排` | `none` | `integer_input` | AMC 10A 2018 Problem 4 | `ok` |  | 先選 3 個不相鄰節次再排 3 科，答案 24 成立 |
| `combinatorics_grade9_foundation_009` | `grade9` | `combinatorics` | `整數拆分` | `none` | `integer_input` | AMC 10A 2016 Problem 14 | `ok` |  | 2016=2a+3b，b 需為偶數且 0≤b≤672，共 337 種，成立 |
| `geometry_grade7_foundation_001` | `grade7` | `geometry` | `正多邊形角度` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 7年級 選擇 4 | `ok` | figure | 純角度代數（n=18 正確）；原裝飾六邊形圖改 kind:none |
| `geometry_grade7_foundation_002` | `grade7` | `geometry` | `平面座標距離` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 5 | `ok` | figure | 答案 7 正確；原座標圖把 P(7,-9) 畫出＝洩題，改 kind:none |
| `geometry_grade7_foundation_003` | `grade7` | `geometry` | `圖形切割` | `geometry_scene` | `integer_input` | IMC Taiwan 2026 複賽 7年級 計算 1-(1) | `ok` | solution, figure | 詳解原寫「依官方解法」偷懶，改為完整推導（周長差=2(x−y)=12→6）；補真圖（切割＋陰影三角＋直角＋等長股） |
| `geometry_grade7_foundation_004` | `grade7` | `geometry` | `等腰三角形角度` | `geometry_scene` | `integer_input` | 改寫題（等腰角平分線） | `ok` | source, figure | ∠ADB=90 正確；Editorial→rewritten；補真圖（角平分線＋40°弧＋直角＋等長邊） |
| `geometry_grade7_foundation_005` | `grade7` | `geometry` | `三角形中位線` | `geometry_scene` | `integer_input` | 改寫題（中位線梯形面積） | `ok` | source, bare, figure | 原裸套中位線改寫為梯形面積多步題（答案 36）；補真圖（中位線＋陰影梯形） |
| `geometry_grade7_foundation_006` | `grade7` | `geometry` | `平行線角度` | `geometry_scene` | `integer_input` | 改寫題（平行線同位角） | `ok` | source, bare, figure | 原裸套同位角改寫為兩步（內角和＋同位角，答案 65）；補真圖（DE∥BC＋角標） |
| `geometry_grade7_foundation_007` | `grade7` | `geometry` | `面積比與中點` | `geometry_scene` | `multiple_choice` | AMC 8 2002 Problem 20 | `ok` | figure | 陰影面積 3 正確；「圖中陰影」補真圖（中線＋高＋交點＋陰影四邊形） |
| `geometry_grade7_foundation_008` | `grade7` | `geometry` | `長方形中點三角形面積` | `geometry_scene` | `multiple_choice` | AMC 8 2000 Problem 25 | `ok` | figure | 面積 27 正確；補真圖（矩形＋A 連 BC/CD 中點的陰影三角形） |
| `geometry_grade7_foundation_009` | `grade7` | `geometry` | `正方形中點與面積` | `geometry_scene` | `multiple_choice` | AMC 8 2018 Problem 22 | `ok` | math_notation, figure | 面積 108 正確；`s^2`→`s²`；補真圖（對角線＋割線交於 F＋陰影 AFED） |
| `geometry_grade7_foundation_010` | `grade7` | `geometry` | `圓弧圍成區域面積` | `geometry_scene` | `multiple_choice` | AMC 8 2000 Problem 19 | `ok` | math_notation, figure | 面積 50 正確；`5^2`→`5²`；補真圖（三段圓弧圍成區域） |
| `geometry_grade8_foundation_001` | `grade8` | `geometry` | `梯形面積` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 選擇 2 | `ok` | figure | 中線×高=32；純公式，改 kind:none |
| `geometry_grade8_foundation_002` | `grade8` | `geometry` | `摺紙角度` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 填充 4 | `ok` | figure | ∠EAB=15° 正確；摺紙難忠實畫，改 kind:none |
| `geometry_grade8_foundation_003` | `grade8` | `geometry` | `內切圓半徑` | `geometry_scene` | `integer_input` | IMC Taiwan 2026 複賽 8年級 填充 8 | `ok` | figure | r=2 正確；補真圖（6-8-10 直角三角形＋內切圓） |
| `geometry_grade8_foundation_004` | `grade8` | `geometry` | `直角三角形中點` | `geometry_scene` | `integer_input` | 改寫題（斜邊中點） | `ok` | source, notation, figure | CM=5 正確；`^`→上標；補真圖；Editorial→rewritten |
| `geometry_grade8_foundation_005` | `grade8` | `geometry` | `圓弦與距離` | `geometry_scene` | `integer_input` | 改寫題（圓弦與距離） | `ok` | source, notation, figure | 弦長 16 正確；補真圖（圓＋弦＋垂距）；Editorial→rewritten |
| `geometry_grade8_foundation_006` | `grade8` | `geometry` | `菱形對角線` | `geometry_scene` | `integer_input` | 改寫題（菱形對角線） | `ok` | source, notation, figure | 周長 52 正確；補真圖（菱形＋對角線）；Editorial→rewritten |
| `geometry_grade8_foundation_007` | `grade8` | `geometry` | `梯形面積與邊長` | `none` | `multiple_choice` | AMC 8 2003 Problem 21 | `ok` | correctness, figure | **prompt 誤把 17 說成底邊（應為腰）**已改；詳解改為自足（√(17²-8²)=15）；BC=10 正確；圖 none |
| `geometry_grade8_foundation_008` | `grade8` | `geometry` | `三角形陰影面積` | `geometry_scene` | `multiple_choice` | 改寫題（面積比） | `ok` | source, duplication, figure | **原與 grade7 幾何 007 完全重複**（AMC 8 2002 P20），改寫為面積比 BD:BC=1:3→6；補真圖 |
| `geometry_grade8_foundation_009` | `grade8` | `geometry` | `直角三角形與正方形` | `geometry_scene` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 選擇 5 | `ok` | notation, figure | 9-12-15 周長 36 正確；`^`→上標；補真圖（三角形＋兩正方形） |
| `geometry_grade8_foundation_010` | `grade8` | `geometry` | `圓與雙正方形面積比` | `none` | `multiple_choice` | AMC 8 2011 Problem 25 | `ok` | figure | (π-2)/2≈0.57 最接近 1/2，正確；角點多、詳解自足，改 kind:none |
| `geometry_grade9_foundation_001` | `grade9` | `geometry` | `長方形摺疊` | `geometry_scene` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 1 | `ok` | solution, figure | 官方題與答案 5 成立但原詳解以「依官方解法」帶過相似三角形，已改為完整推理：BE=BC=15→AD=15→ED=3→(9−x)²+3²=x²→x=5；原圖 BC 畫成 16（應等於 BE=15）、F 點 (9,8) 不滿足 FE=FC 且缺 E–F 邊，已重繪為 A(0,15) B(9,15) C(9,0) D(0,0) E(0,3) F(4,0) 並補等長記號與直角記號 |
| `geometry_grade9_foundation_002` | `grade9` | `geometry` | `等腰直角三角形與圓` | `geometry_scene` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 5 | `ok` | figure | 題目與答案 4√5/5 成立；本輪發現整圓（圓心 (0,0)、半徑 1）超出原 bounds 的 minX/minY = −0.3 會被截掉左下角，已放寬為 −1.2 使整圓可見 |
| `geometry_grade9_foundation_003` | `grade9` | `geometry` | `對稱與座標` | `coordinate_plane` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 8 | `ok` |  | 關於 y=2x+1 的對稱點為 (-4/5, 2/5)，題型與答案成立 |
| `geometry_grade9_foundation_004` | `grade9` | `geometry` | `梯形對角線分割面積` | `geometry_scene` | `integer_input` | 改寫題（梯形對角線分割面積） | `ok` | source, olympiadness, rewritten | 原題為水平底乘高除二的裸公式題且來源為自製 editorial 暫代出處，整題淘汰；改寫為 AB∥CD、AB=8、CD=12、[APB]=16 求梯形面積，需依序用相似比平方、兩側塊等積、[APD]²=[APB]·[CPD]，答案 100 已驗算 |
| `geometry_grade9_foundation_005` | `grade9` | `geometry` | `直角三角形內切圓` | `geometry_scene` | `integer_input` | 改寫題（內切圓半徑逆推面積） | `ok` | source, olympiadness, duplication, rewritten | 原題為「斜邊除以二」裸題、與原 006 考同一事實且來源為自製 editorial 暫代出處；改寫為 r=3、c=25 求面積，由切線長導出 a+b=2r+c=31 再與 a²+b²=625 聯立得 ab=168，答案 84；圖以精確 7-24-25 三角形與內心 (3,3) 繪製，已驗內心到斜邊距離為 3 |
| `geometry_grade9_foundation_006` | `grade9` | `geometry` | `相交弦定理` | `geometry_scene` | `integer_input` | 改寫題（相交弦定理與比例） | `ok` | source, olympiadness, duplication, rewritten | 原題與原 005 同為「斜邊中線等於斜邊一半」的同一事實且來源為自製 editorial 暫代出處；改寫為 AP=8、PB=3、CP:PD=2:3 求 CD，設 2k、3k 由 6k²=24 得 k=2，CD=10；圖 A(−8,0) B(3,0) C(0,−4) D(0,6) 圓心 (−2.5,1) 半徑 √31.25 已驗四點共圓且各段長度吻合 |
| `geometry_grade9_foundation_007` | `grade9` | `geometry` | `圓外點距離` | `shape_diagram` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 5 | `ok` | figure | 已升級為 geometry_scene；由最遠=OP+r、最近=OP-r 解得 r=3，成立 |
| `geometry_grade9_foundation_008` | `grade9` | `geometry` | `圓錐與圓柱體積` | `shape_diagram` | `multiple_choice` | AMC 10B 2021 Problem 10 | `ok` | figure | 屬情境提示圖，暫時保留簡圖可接受；體積換算得高 1.5 公分，答案成立 |
| `geometry_grade9_foundation_009` | `grade9` | `geometry` | `拋物線水面` | `coordinate_plane` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 7 | `ok` |  | 拋物線弦長與頂點距離成平方根關係，10:2=√10:√PN，得 PN=2/5，成立 |
| `geometry_grade9_foundation_010` | `grade9` | `geometry` | `直線圍成三角形面積` | `coordinate_plane` | `multiple_choice` | AMC 8 2019 Problem 21 | `ok` |  | 三線交點為 (-4,5),(4,5),(0,1)，面積 1/2×8×4=16，成立 |
| `logic_grade7_foundation_001` | `grade7` | `logic` | `真假判定` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 7年級 選擇 2 | `ok` | correctness | **原答案錯誤（標丙，正解甲）＋詳解推理錯**，已修正為甲並重寫三情形分析 |
| `logic_grade7_foundation_002` | `grade7` | `logic` | `排除法` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 7年級 填充 2 | `ok` |  | 錯標盒經典，抽『混裝』盒，正確 |
| `logic_grade7_foundation_003` | `grade7` | `logic` | `規律判斷` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 選擇 5 | `ok` |  | 差分 1,2,3,4→+5=17，正確 |
| `logic_grade7_foundation_004` | `grade7` | `logic` | `真假推理` | `none` | `multiple_choice` | 改寫題（真假推理） | `ok` | source | 答案丙正確；Editorial→rewritten |
| `logic_grade7_foundation_005` | `grade7` | `logic` | `順序線索` | `none` | `multiple_choice` | 改寫題（名次推理） | `ok` | source | 賽跑排序第一名=乙，正確；Editorial→rewritten |
| `logic_grade7_foundation_006` | `grade7` | `logic` | `數字順序` | `none` | `integer_input` | 改寫題（數字排序） | `ok` | source | A=3 正確；Editorial→rewritten |
| `logic_grade7_foundation_007` | `grade7` | `logic` | `表格一致性` | `none` | `multiple_choice` | AMC 8 2023 Problem 8 | `ok` |  | 循環賽紀錄，每欄兩勝→000101，正確 |
| `logic_grade7_foundation_008` | `grade7` | `logic` | `條件反例` | `none` | `multiple_choice` | AJHSME 1985 Problem 25 | `ok` | notation | Wason 卡片翻 3，正確；去掉會顯示成原文的反引號 |
| `logic_grade7_foundation_009` | `grade7` | `logic` | `唯一真話排序` | `none` | `multiple_choice` | AMC 8 2004 Problem 13 | `ok` |  | 恰一句真→Amy,Celine,Bill，正確 |
| `logic_grade8_foundation_001` | `grade8` | `logic` | `日曆推理` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 5 | `ok` |  | 1日週三、31天→週一 4 次，正確 |
| `logic_grade8_foundation_002` | `grade8` | `logic` | `配對推理` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 填充 1 | `ok` |  | 顏色配對，乙=紅，正確 |
| `logic_grade8_foundation_003` | `grade8` | `logic` | `規律判斷` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 9 | `ok` |  | 火柴 3,5,7…第10=21，正確 |
| `logic_grade8_foundation_004` | `grade8` | `logic` | `等量轉換` | `none` | `integer_input` | 改寫題（等量轉換） | `ok` | source | 天平等量鏈 4紅=6黃，正確；Editorial→rewritten |
| `logic_grade8_foundation_005` | `grade8` | `logic` | `排隊推理` | `none` | `multiple_choice` | 改寫題（排隊推理） | `ok` | source | 甲<乙<丁、丙最右→最左=甲，正確；Editorial→rewritten |
| `logic_grade8_foundation_006` | `grade8` | `logic` | `編碼對應` | `none` | `integer_input` | 改寫題（編碼對應） | `ok` | source | 字母序號 DOG→4157，正確；Editorial→rewritten |
| `logic_grade8_foundation_007` | `grade8` | `logic` | `模運算移動` | `none` | `integer_input` | AMC 8 2023 Problem 18 | `ok` |  | 5x-3y=2023 最少跳 411，正確 |
| `logic_grade8_foundation_008` | `grade8` | `logic` | `座位推理` | `none` | `multiple_choice` | AJHSME 1987 Problem 17 | `ok` |  | 兩句皆假＋Bret=3→座位2=Dana，正確 |
| `logic_grade8_foundation_009` | `grade8` | `logic` | `真假數字判定` | `none` | `multiple_choice` | AMC 8 2017 Problem 8 | `ok` |  | 恰3句真→98，個位 8，正確 |
| `logic_grade9_foundation_001` | `grade9` | `logic` | `編碼規則` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 選擇 3 | `ok` |  | DOG 對應 4,15,7，拼成 4157，成立 |
| `logic_grade9_foundation_002` | `grade9` | `logic` | `切換規律` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 6 | `ok` |  | 最後亮燈數等於完全平方數個數，1²~10² 共 10 盞，成立 |
| `logic_grade9_foundation_003` | `grade9` | `logic` | `真假排除` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 選擇 7 | `ok` |  | 枚舉唯一真話，可得第 3 條路通往學校，成立 |
| `logic_grade9_foundation_004` | `grade9` | `logic` | `奇偶不變量` | `none` | `integer_input` | 改寫題（差的絕對值不變量） | `ok` | source, olympiadness, rewritten | 原為留 4 的倍數的標準取石子題且來源為自製 editorial 暫代出處；改寫為 1~20 反覆以 \|a−b\| 取代求最終最小值，需同時給下界（總和奇偶不變、210 為偶）與構造（配對降到 0），答案 0 已用 2000 次隨機模擬與構造雙重驗證 |
| `logic_grade9_foundation_005` | `grade9` | `logic` | `抽屜原理配對` | `none` | `integer_input` | 改寫題（抽屜原理與奇偶壓縮） | `ok` | source, olympiadness, rewritten | 原題僅 6 種排列可直接窮舉、深度遠低於本年級且來源為自製 editorial 暫代出處；改寫為四色各 10 隻保證配出 4 雙，轉折在落單數需與取出總數同奇偶，故界線落在 11 而非 12，已用四色分配窮舉驗證 k=10 最壞 3 雙、k=11 最壞 4 雙 |
| `logic_grade9_foundation_006` | `grade9` | `logic` | `天平稱重下界` | `none` | `multiple_choice` | 改寫題（天平稱重資訊下界） | `ok` | source, correctness, rewritten | 原題 answer 文字寫「不可能」但 correctAnswer 指向選項「可能」，且 solutionSteps 直接寫入自我推翻的思考過程（「奇偶性沒有排除？再看實際上⋯所以其實是可能」），整題不可上架已淘汰；改寫為 12 枚含 1 枚不知輕重假幣求最少稱重次數，需同時給資訊下界（24 > 3²）與 4-4-4 構造上界，答案 3 |
| `logic_grade9_foundation_007` | `grade9` | `logic` | `輪替序列` | `none` | `integer_input` | AMC 10A 2019 Problem 23 | `ok` |  | 依三人輪替與區塊長累計，可得 Tadd 的第 2019 個數為 5979，成立 |
| `logic_grade9_foundation_008` | `grade9` | `logic` | `真假區間判定` | `none` | `multiple_choice` | AMC 10A 2018 Problem 5 | `ok` |  | 三句全錯推出 d<6、d>5、d>4，因此 d∈(5,6)，成立 |
| `logic_grade9_foundation_009` | `grade9` | `logic` | `自我指涉語句` | `none` | `multiple_choice` | AMC 8 2021 Problem 22 | `ok` | i18n | 題目與答案 1 成立（已窮舉 16 種真假指派確認唯一自洽解為第 3 句假）；本輪發現 solutionSteps 四語系長度不一致（中文 5 步、英日 6 步），已把中文第 4 步拆成兩步對齊為 6 步 |
| `number_theory_grade7_foundation_001` | `grade7` | `number_theory` | `進位制` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 6 | `ok` | correctness, notation | **原答案錯（標 5，正解 2）＋詳解自相矛盾**，已修正 a=2；`_(7)`→`₇` 下標 |
| `number_theory_grade7_foundation_002` | `grade7` | `number_theory` | `數字計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 填充 7 | `ok` |  | 恰一個數字 7，3×9×9=243，正確 |
| `number_theory_grade7_foundation_003` | `grade7` | `number_theory` | `包除與倍數` | `none` | `integer_input` | 改寫題（容斥計數） | `ok` | source, duplication | **原與 010 完全重複**，改寫為「1~100 非 2/3/5 倍數」＝26；來源改 rewritten（IMC 選擇8 由 010 保留） |
| `number_theory_grade7_foundation_004` | `grade7` | `number_theory` | `餘數循環` | `none` | `integer_input` | 改寫題（模餘循環） | `ok` | source, notation | 2²⁰ mod 7 = 4 正確；`^`→上標；Editorial→rewritten |
| `number_theory_grade7_foundation_005` | `grade7` | `number_theory` | `數位整除` | `none` | `integer_input` | 改寫題（數位整除） | `ok` | source | 3a7b 被 9 整除，max(a+b)=17 正確；Editorial→rewritten |
| `number_theory_grade7_foundation_006` | `grade7` | `number_theory` | `連續整數` | `none` | `integer_input` | 改寫題（連續整數乘積） | `ok` | source | 13×14×15=2730→15 正確；詳解補立方根估算；Editorial→rewritten |
| `number_theory_grade7_foundation_007` | `grade7` | `number_theory` | `整除計數` | `none` | `integer_input` | IMC Taiwan 2026 複賽 7年級 選擇 5 | `ok` |  | 從 4-8 選 3 位排成被 6 整除，16 個，正確 |
| `number_theory_grade7_foundation_008` | `grade7` | `number_theory` | `指數比較` | `none` | `multiple_choice` | AMC 8 2010 Problem 24 | `ok` | notation | 取四次方根比較，中間 10⁸ 正確；`^`→上標 |
| `number_theory_grade7_foundation_009` | `grade7` | `number_theory` | `同餘最小值` | `none` | `integer_input` | AMC 8 2004 Problem 19 | `ok` |  | 除 3/4/5/6 皆餘 2，N-2=lcm=60→62，正確 |
| `number_theory_grade7_foundation_010` | `grade7` | `number_theory` | `倍數容斥計數` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 7年級 選擇 8 | `ok` |  | 1~2026 中 2/3 倍數非 5 倍數，1081 正確（保留為官方 IMC，測試釘選） |
| `number_theory_grade8_foundation_001` | `grade8` | `number_theory` | `因數分解` | `none` | `integer_input` | 改寫題（因數配對） | `ok` | source, duplication | **原與 010 重複**（x²+ax+48），改寫為 72 的乘積寫法數=6；IMC 選擇1 由 010 保留 |
| `number_theory_grade8_foundation_002` | `grade8` | `number_theory` | `整數解` | `none` | `integer_input` | 改寫題（整數解計數） | `ok` | correctness, source, duplication | **答案原標 25（實際 81）＋與 grade8 組合 007 同官方題**，改寫為 2x+3y=60 正整數解=9 |
| `number_theory_grade8_foundation_003` | `grade8` | `number_theory` | `整數計算` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 選擇 3 | `ok` | correctness, notation | **原答案錯（標1992000，實際1995000）＋詳解矛盾**已修；`998^2`→`998²` |
| `number_theory_grade8_foundation_004` | `grade8` | `number_theory` | `因數個數` | `none` | `integer_input` | 改寫題（因數個數） | `ok` | source, notation | 360=2³×3²×5→24 個，正確；`^`→上標；Editorial→rewritten |
| `number_theory_grade8_foundation_005` | `grade8` | `number_theory` | `最大公因數` | `none` | `integer_input` | 改寫題（最大公因數） | `ok` | source, bare | 原裸算 gcd(84,126) 改寫為 gcd·lcm=積 求另一數=30；Editorial→rewritten |
| `number_theory_grade8_foundation_006` | `grade8` | `number_theory` | `最小公倍數` | `none` | `integer_input` | 改寫題（最小公倍數） | `ok` | source, notation | lcm(18,24,30)=360，正確；`^`→上標；Editorial→rewritten |
| `number_theory_grade8_foundation_007` | `grade8` | `number_theory` | `餘數配對` | `none` | `integer_input` | IMC Taiwan 2026 複賽 8年級 計算 2(2) | `ok` |  | 1~100 兩數和 7 倍數，餘數配對 707，正確 |
| `number_theory_grade8_foundation_008` | `grade8` | `number_theory` | `位值方程` | `none` | `integer_input` | AMC 8 2014 Problem 22 | `ok` |  | 位值方程 a(b+1)=10a→b=9，正確 |
| `number_theory_grade8_foundation_009` | `grade8` | `number_theory` | `整除排列計數` | `none` | `integer_input` | AMC 8 2016 Problem 24 | `ok` |  | 1-5 排列被 4 整除，末兩位 4 種×3!=24，正確 |
| `number_theory_grade8_foundation_010` | `grade8` | `number_theory` | `整數因數配對` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 8年級 選擇 1 | `ok` | notation | x²+ax+48 因式分解，a 有 10 種（保留官方 IMC）；`^`→上標 |
| `number_theory_grade9_foundation_001` | `grade9` | `number_theory` | `整數三角形` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 5 | `needs_fix` | correctness, duplication, classification | 與 combinatorics 007 同題但此處答案寫成 15；實際程式枚舉為 12，且更適合留在 combinatorics |
| `number_theory_grade9_foundation_002` | `grade9` | `number_theory` | `連乘積` | `none` | `multiple_choice` | IMC Taiwan 2026 複賽 9年級 填充 2 | `needs_fix` | duplication | 與 algebra 002、number_theory 010 同題重複收錄，需合併成單一正式版本 |
| `number_theory_grade9_foundation_003` | `grade9` | `number_theory` | `數位和` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 選擇 1 | `ok` |  | 每段 123456789 的數位和為 45，重複 2026 次得 91170，成立 |
| `number_theory_grade9_foundation_004` | `grade9` | `number_theory` | `最大公因數與最小公倍數` | `none` | `integer_input` | MathSpring Editorial Original | `needs_fix` | source | 題目可算，但來源仍是 Editorial Original，不可直接上架 |
| `number_theory_grade9_foundation_005` | `grade9` | `number_theory` | `完全平方數` | `none` | `integer_input` | MathSpring Editorial Original | `needs_fix` | source | 題目過裸且來源不合格，需改寫成正式可追溯版本 |
| `number_theory_grade9_foundation_006` | `grade9` | `number_theory` | `模幂` | `none` | `integer_input` | MathSpring Editorial Original | `needs_fix` | source, olympiadness | 3¹⁵ mod 8 過於直接，需重寫來源並提升題面品質 |
| `number_theory_grade9_foundation_007` | `grade9` | `number_theory` | `數字倒序整除` | `none` | `integer_input` | AMC 10A 2023 Problem 12 | `ok` |  | 倒序數須末位 0 或 5，但三位且可被 7 整除，枚舉/同餘可得 14，成立 |
| `number_theory_grade9_foundation_008` | `grade9` | `number_theory` | `七進位數字和` | `none` | `integer_input` | AMC 10B 2019 Problem 12 | `ok` |  | 最大數位和在接近 2019 的七進位表達達成，答案 22 成立 |
| `number_theory_grade9_foundation_009` | `grade9` | `number_theory` | `整除比例` | `none` | `multiple_choice` | AMC 8 2026 Problem 16 | `ok` |  | 四位數各位皆偶數時，被 4 整除只看末兩位，比例 3/5 可成立 |
| `number_theory_grade9_foundation_010` | `grade9` | `number_theory` | `望遠鏡乘積` | `none` | `integer_input` | IMC Taiwan 2026 複賽 9年級 填充 2 | `needs_fix` | duplication | 與 number_theory 002、algebra 002 同題，應合併成單一版本後再審 |
