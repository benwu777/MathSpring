# MathSpring 題庫規則待處理項目

## 目的

這份文件是交接給下一個模型或編輯者使用的待處理清單。

目標不是重寫全部規則，而是先把目前文件中已確認的衝突、缺口與應補內容整理清楚，方便後續一次修正。

## 處理範圍

請以以下文件為主：

- `docs/question-bank-expansion-guidelines.md`
- `docs/AGENT_PROMPT_question_bank.md`
- `docs/olympiad-template-spec.md`
- `docs/question-bank-taxonomy.md`

必要時可一併參考：

- `docs/olympiad-template-registry.md`
- `docs/question-bank-audit-2026-07-23.md`

## 已確認問題

### 1. 主題體系不一致

目前文件存在兩套主題系統：

- 四類：
  - `arithmetic`
  - `geometry`
  - `logic`
  - `mixed`
- 六類：
  - `arithmetic`
  - `number_theory`
  - `algebra`
  - `geometry`
  - `combinatorics`
  - `logic`

這會影響：

- `topic` 定義
- pack 命名規則
- `subtopic` 歸類
- 後續是否要拆 pack

### 2. 難度層規則不一致

目前文件存在兩套難度規則：

- 三層：
  - `foundation`
  - `advanced`
  - `competition`
- 兩層：
  - `foundation`
  - `competition`

這會影響：

- 新題標記
- template 規格
- 未來資料驗證
- 題庫擴充時的難度梯度

### 3. 缺少正式 canonical subtopic registry

目前有 taxonomy 與實際題庫，但沒有一份正式文件明確規定：

- 目前允許使用哪些 `subtopic`
- 每個 `subtopic` 對應哪個主題
- 何時可新增新 `subtopic`
- 新增時需要滿足什麼條件

目前實際 pack 已經使用很多英文字串，例如：

- `balance_transfer`
- `route_counting`
- `factors_counting`
- `page_numbering`
- `gcd_lcm`

但 taxonomy 文件仍是中文概念層，沒有和實際 schema 一一對應。

### 4. 缺少可執行的上架驗收 checklist

目前規則有原則，但還沒有一份明確 checklist 要求每題或每次補題後必檢：

- 四語系是否完整
- `answerMode` 是否與欄位一致
- `correctAnswer` 是否與詳解一致
- `source` 欄位是否完整到規範要求
- `figure` 是否符合 schema
- 是否做過去重檢查
- 是否通過奧數題複審
- 是否通過測試

### 5. figure 填寫規則不夠精確

文件有提到每題要有 `figure`，但沒有把無圖題的標準寫法明文化。

至少應補清楚：

- 無圖題應如何填
- 有圖題的最低欄位要求
- 哪些情況可使用 `kind = none`
- 哪些圖形必須用結構化繪製

### 6. answerMode phase-1 邊界未在中文主規範寫死

目前英文 template spec 已說 phase 1 僅支援：

- `multiple_choice`
- `integer_input`

但中文主規範沒有把這件事寫成不可違反規則。

這會讓後續模型誤以為可以直接新增：

- 分數輸入
- 小數輸入
- 自由文字輸入

## 建議修正目標

下一位處理者至少要完成以下成果：

### A. 統一主題體系

要明確決定 phase 1 正式採用：

- 四類主題
或
- 六類主題

並把所有相關文件同步修正，不可只改一份。

### B. 統一難度體系

要明確決定 phase 1 正式採用：

- 兩層難度
或
- 三層難度

並同步修正：

- 擴充準則
- agent prompt
- template spec
- 任何示例或 checklist

### C. 建立 canonical subtopic 規則

至少要補一份文件或一個章節，明確列出：

- 目前正式允許的 `subtopic`
- 與主題的對應關係
- 新增規則
- 禁止事項

### D. 補一份上架驗收 checklist

應明確列成清單，供模型或人員在補題後逐項核對。

### E. 補 schema-level 規則細節

至少補清楚：

- `figure`
- `answerMode`
- `options`
- `inputConstraints`
- `source`

在什麼情況下必填、可省略、不可使用。

## 建議處理方式

建議不要直接重寫所有文件。

較穩妥的做法：

1. 先選定正式 phase 1 規則
2. 以 `question-bank-expansion-guidelines.md` 為主文件收口
3. 再同步修正：
   - `AGENT_PROMPT_question_bank.md`
   - `olympiad-template-spec.md`
   - `question-bank-taxonomy.md`
4. 最後補一份 checklist 或 registry 文件

## 完成後應回報

下一位處理者完成後，應至少回報：

1. 最終採用的主題體系
2. 最終採用的難度體系
3. 新增或修訂了哪些文件
4. 是否補齊 canonical subtopic 規則
5. 是否補齊上架驗收 checklist

## 注意

- 不要只修字句，必須真正消除規則衝突
- 不要新增另一套平行規則
- 不要讓英文 spec 和中文主規範繼續各講各的
- 不要把「目前題庫實作現況」和「正式規則」混在一起寫得模糊
