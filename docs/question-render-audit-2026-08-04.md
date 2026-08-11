# Question Render Audit

日期：2026-08-04

## 目的

這份文件記錄目前題庫在「數學式呈現」與「幾何圖形呈現」上的掃描結果。

固定補充檢查項：

- 幾何圖上的標籤不得彼此重疊
- 幾何圖上的標籤不得壓到頂點、線段、角弧、圓點、虛線或陰影邊界
- 若標籤重疊會讓幾何元素辨識不清，該題視為未通過圖形品質檢查

重點不是重新審內容正確性，而是先找出：

1. 哪些題庫檔仍大量使用程式式數學寫法
2. 哪些幾何題目前沒有圖
3. 哪些檔案適合優先批次清理

---

## 一、數學式字串掃描結果

掃描條件：

- `^`
- `<=`
- `>=`

掃描範圍：

- `assets/questions/**/*.json`

結果：

- 總匹配數：`1273`

高優先清理檔案（前 20）：

1. `assets/questions/algebra/grade11_foundation.algebra.v1.json`：`288`
2. `assets/questions/geometry/grade10_foundation.geometry.v1.json`：`143`
3. `assets/questions/algebra/grade9_foundation.algebra.v1.json`：`130`
4. `assets/questions/geometry/grade11_foundation.geometry.v1.json`：`100`
5. `assets/questions/algebra/grade12_foundation.algebra.v1.json`：`82`
6. `assets/questions/number_theory/grade11_foundation.number_theory.v1.json`：`80`
7. `assets/questions/number_theory/grade9_foundation.number_theory.v1.json`：`72`
8. `assets/questions/number_theory/grade10_foundation.number_theory.v1.json`：`54`
9. `assets/questions/geometry/grade12_foundation.geometry.v1.json`：`53`
10. `assets/questions/number_theory/grade12_foundation.number_theory.v1.json`：`44`
11. `assets/questions/geometry/grade9_foundation.geometry.v1.json`：`43`
12. `assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json`：`42`
13. `assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json`：`32`
14. `assets/questions/algebra/grade10_foundation.algebra.v1.json`：`30`
15. `assets/questions/combinatorics/grade11_foundation.combinatorics.v1.json`：`24`
16. `assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json`：`24`
17. `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json`：`8`
18. `assets/questions/mixed/grade6_foundation.mixed.v1.json`：`8`
19. `assets/questions/logic/grade12_foundation.logic.v1.json`：`4`
20. `assets/questions/logic/grade10_foundation.logic.v1.json`：`4`

### 判讀

- 這不代表有 `1273` 個錯題。
- 很多其實已經可由 app 的 render-time formatter 正常顯示。
- 但 JSON 本體仍保留程式式寫法，後續若要做：
  - 匯出題面
  - 做外部審核
  - 建立靜態題庫文件
  - 給其他模型直接編修

  仍然會造成品質不一致。

### 結論

顯示層已先補上，但 JSON 內容本身仍建議分批回寫。

建議優先順序：

1. `grade9-12 algebra`
2. `grade9-12 geometry`
3. `grade9-12 number_theory`
4. `grade11-12 combinatorics`
5. `grade4/6 arithmetic`

---

## 二、幾何圖形 kind 掃描結果

掃描範圍：

- `assets/questions/geometry/*.json`

統計結果：

- `none`：`134`
- `shape_diagram`：`91`
- `coordinate_plane`：`46`
- `geometry_scene`：`14`
- `composite_grid_shape`：`42`
- `circle_quadrants_point`：`1`

### 判讀

- `none` 不一定是錯。
- 若圖形對理解沒有實質幫助，保持 `none` 是正確的。
- 但高年級幾何題若仍大量停留在 `shape_diagram`，通常代表：
  - 圖只是外框加標籤
  - 圖未表達關鍵條件
  - 還沒有升級到較準確的宣告式幾何圖

### 結論

幾何題的下一波品質提升，不應該是「把所有 `none` 都補圖」。

正確作法是：

1. 先抓高年級 `shape_diagram`
2. 判斷圖是否真的承載題目條件
3. 能升級的改成 `geometry_scene`
4. 若無法精確表意，反而保留 `none`

---

## 三、幾何題無圖數量

目前 `geometry/*.json` 中：

- `figure.kind = "none"` 的題共有 `134` 題

這批不應直接視為待補圖清單。

要再分成兩類：

1. **應補圖**
   - 題目明確依賴位置關係
   - 有中點、垂線、角度、切線、陰影、座標結構
   - 沒圖會降低理解或容易誤解

2. **可維持無圖**
   - 題面本身已完整且圖不增加理解
   - 若硬畫只會變成裝飾或誤導

---

## 四、目前建議的下一步

### A. 先處理數學式 JSON 回寫

先從這幾包開始：

1. `grade11_foundation.algebra.v1.json`
2. `grade9_foundation.algebra.v1.json`
3. `grade10_foundation.geometry.v1.json`
4. `grade11_foundation.geometry.v1.json`
5. `grade12_foundation.algebra.v1.json`

理由：

- 命中量最高
- 高年級題較常直接暴露程式式寫法
- 修完後使用者體感最明顯

### 2026-08-04 已完成第一批

以下 5 包已完成 JSON 原文數學式回寫，`^ / <= / >=` 掃描命中已降為 `0`：

1. `assets/questions/algebra/grade11_foundation.algebra.v1.json`
2. `assets/questions/algebra/grade9_foundation.algebra.v1.json`
3. `assets/questions/geometry/grade10_foundation.geometry.v1.json`
4. `assets/questions/geometry/grade11_foundation.geometry.v1.json`
5. `assets/questions/algebra/grade12_foundation.algebra.v1.json`

本次同步補上的能力：

- grouped exponent 也能標準化，例如：
  - `2^(1+2+3)` → `2⁽¹⁺²⁺³⁾`
  - `x^(log x)` → `x⁽ˡᵒᵍˣ⁾`

### 2026-08-04 已完成第二批

以下 6 包也已完成 JSON 原文數學式回寫，`^ / <= / >=` 掃描命中已降為 `0`：

1. `assets/questions/number_theory/grade11_foundation.number_theory.v1.json`
2. `assets/questions/number_theory/grade9_foundation.number_theory.v1.json`
3. `assets/questions/number_theory/grade10_foundation.number_theory.v1.json`
4. `assets/questions/number_theory/grade12_foundation.number_theory.v1.json`
5. `assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json`
6. `assets/questions/combinatorics/grade11_foundation.combinatorics.v1.json`

截至目前為止，已清完的高命中第二階段範圍為：

- `grade9-12 algebra` 中的第一批高優先包
- `grade9-12 number_theory` 的高優先包
- `grade11-12 combinatorics` 的高優先包
- `grade10-11 geometry` 的高優先包

### 2026-08-04 已完成第三批

以下 5 包也已完成 JSON 原文數學式回寫，`^ / <= / >=` 掃描命中已降為 `0`：

1. `assets/questions/geometry/grade12_foundation.geometry.v1.json`
2. `assets/questions/geometry/grade9_foundation.geometry.v1.json`
3. `assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json`
4. `assets/questions/algebra/grade10_foundation.algebra.v1.json`
5. `assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json`

截至目前為止，已清完的高命中第三階段範圍為：

- `grade9-12 algebra` 的高命中包
- `grade9-12 number_theory` 的高命中包
- `grade9-12 geometry` 中的高命中包
- `grade11-12 combinatorics` 的高命中包
- `grade4`、`grade6` arithmetic` 的高命中包

### 2026-08-04 已完成尾包清理

以下尾包也已完成 JSON 原文數學式回寫，`^ / <= / >=` 掃描命中已降為 `0`：

1. `assets/questions/mixed/kangaroo56_foundation.mixed.v1.json`
2. `assets/questions/mixed/grade6_foundation.mixed.v1.json`
3. `assets/questions/logic/grade10_foundation.logic.v1.json`
4. `assets/questions/logic/grade12_foundation.logic.v1.json`
5. `assets/questions/geometry/grade6_foundation.geometry.v1.json`
6. `assets/questions/combinatorics/grade10_foundation.combinatorics.v1.json`

這表示目前先前掃描列出的高命中 raw math notation 包，已全部完成至少一輪 JSON 原文清理。

### B. 再做高年級 geometry figure audit

優先看：

1. `grade9_foundation.geometry.v1.json`
2. `grade10_foundation.geometry.v1.json`
3. `grade11_foundation.geometry.v1.json`
4. `grade12_foundation.geometry.v1.json`

檢查重點：

- `shape_diagram` 是否只是外框貼字
- 是否該升級為 `geometry_scene`
- 是否其實不應該放圖

### 2026-08-04 高年級 `shape_diagram` 審核結論

這一輪先看 `grade9` 到 `grade12` 幾何包內所有 `shape_diagram`。

判定原則再明確補一層：

1. 題目條件若包含中點、切線、摺線、弦、圓心角、圓周角、內接結構、交點或等長關係，圖就不能只放外框加文字
2. 若現有 `geometry_scene` primitive 已能表達，就應升級，不可繼續停留在 `shape_diagram`
3. 若題目是 3D、向量空間、或目前 renderer 還無法準確表達的結構，就不要用假示意圖冒充，可暫時保留簡圖或改成 `none`
4. 圖若對理解幫助很小，或只是在重複題面已知數據，也不必強行補圖

#### A. 第一批直接升級為 `geometry_scene`

這批都是條件明確、且目前 renderer 已可準確表達的題：

1. `geometry_grade9_foundation_001`
   - 摺疊長方形
   - 現況問題：只有長方形外框與「摺線 BF」文字，沒有表出 `E`、`F`、對摺與相等關係
2. `geometry_grade10_foundation_004`
   - 圓外點作切線
   - 現況問題：沒有明確畫出 `OP`、`PT`、`OT` 與切線垂直條件
3. `geometry_grade10_foundation_006`
   - 中線與重心比例
   - 現況問題：只有三角形和 `G`，沒有 `D` 是邊中點與 `AD` 是中線的核心資訊
4. `geometry_grade12_foundation_004`
   - 圓心角與圓周角
   - 現況問題：只畫一個圓，沒有 `A`、`B`、`C`、`O` 與兩種角的位置關係
5. `geometry_grade12_foundation_006`
   - 圓心角與弦長
   - 現況問題：只寫 `120°` 與 `r=6`，沒有弦與半徑

#### 2026-08-04 第一批已完成

以下題目已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade9_foundation_001`
2. `geometry_grade10_foundation_004`
3. `geometry_grade10_foundation_006`
4. `geometry_grade12_foundation_004`
5. `geometry_grade12_foundation_006`

#### B. 第二批應升級，但可排下一輪

這批也適合升級成 `geometry_scene`，只是條件較多，放到下一輪較穩：

1. `geometry_grade9_foundation_002`
2. `geometry_grade9_foundation_005`
3. `geometry_grade9_foundation_006`
4. `geometry_grade9_foundation_007`
5. `geometry_grade10_foundation_005`
6. `geometry_grade10_foundation_009`
7. `geometry_grade10_foundation_010`
8. `geometry_grade11_foundation_007`
9. `geometry_grade11_foundation_008`
10. `geometry_grade12_foundation_002`
11. `geometry_grade12_foundation_003`
12. `geometry_grade12_foundation_007`
13. `geometry_grade12_foundation_008`
14. `geometry_grade12_foundation_009`
15. `geometry_grade12_foundation_010`

#### 2026-08-04 第二批已完成

以下第二批條件題也已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade9_foundation_005`
2. `geometry_grade9_foundation_006`
3. `geometry_grade9_foundation_007`
4. `geometry_grade10_foundation_005`

#### 2026-08-04 第三批已完成

以下進一步的圓與多邊形條件題也已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade10_foundation_009`
2. `geometry_grade10_foundation_010`
3. `geometry_grade11_foundation_008`

#### 2026-08-04 第四批已完成

以下內接正方形與切圓條件題也已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade11_foundation_007`
2. `geometry_grade12_foundation_007`
3. `geometry_grade12_foundation_009`

#### 2026-08-05 第五批已完成

以下最後一批可直接由現有 renderer 表達的題，也已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade9_foundation_002`
2. `geometry_grade12_foundation_008`
3. `geometry_grade12_foundation_010`

#### 2026-08-05 第六批已完成

以下剩餘的梯形條件題，也已完成 `shape_diagram` → `geometry_scene` 升級：

1. `geometry_grade12_foundation_002`
2. `geometry_grade12_foundation_003`

#### C. 不適合繼續用假示意圖的題

這些題若短期內沒有更適合的 renderer，寧可不上圖，也不要保留低資訊量圖：

1. `geometry_grade10_foundation_008`
   - 題目是四邊形邊長存在性，不依賴特定圖形配置
2. `geometry_grade11_foundation_004`
   - 正方體體對角線，現有方形圖不足以表達立體
3. `geometry_grade11_foundation_005`
   - 正四面體高，現有金字塔圖會誤導成立方或方錐感
4. `geometry_grade11_foundation_009`
   - 空間向量與角平分線，2D 三角形圖不足以表達

#### D. 可暫時保留簡圖

這些圖雖不精準，但暫時不至於誤導，且升級收益較低：

1. `geometry_grade9_foundation_008`
   - 容器體積轉換，圖主要是情境提示
2. `geometry_grade10_foundation_001`
   - 直線與圓的代數距離問題，若要升級需補座標軸與法向資訊
3. `geometry_grade10_foundation_007`
   - 缺角長方形，升級要畫兩個切角與對角線關係
4. `geometry_grade11_foundation_003`
   - 正四角錐二面角，需另做 3D renderer 才值得升級
5. `geometry_grade11_foundation_006`
   - 正六邊形面積，現有簡圖至少沒有誤導
6. `geometry_grade11_foundation_010`
   - 正八邊形雖可升級，但需先補多邊形頂點配置工具

### C. 審核文件同步補註

後續若某包已完成：

- 數學式回寫
- 圖形品質重審
- 複審通過

應同步回填：

- `docs/question-review-*.md`
- 題目 `reviewStatus`

---

## 五、已完成的基礎工程

這一輪已先做完：

1. render-time 數學式標準化
2. 題面／選項／詳解統一套用 formatter
3. `geometry_scene` 標籤邊界 clamp
4. duplicate audit 接上標準化後字串，避免 `x^2` 和 `x²` 被誤判成不同題

因此後面分批修 JSON 時，不需要再重新設計呈現層。
