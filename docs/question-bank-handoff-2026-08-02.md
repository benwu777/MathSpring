# MathSpring 題庫接手文件

日期：2026-08-02

## 這份文件的用途

這份文件是給下一個 AI / 編輯者 / 工程師直接接手用的。

目標不是重新理解整個專案，而是：

1. 立刻知道目前題庫規則與紅線
2. 立刻知道現在做到哪裡
3. 立刻知道下一步該做什麼
4. 不要再把已經確認過的規則推翻或混淆

## 目前狀態摘要

- 題庫目前 `id` 已確認唯一
- 總題數目前約 `1271`
- `7-9` 年級已建立第一版逐題審核清單
- `7-9` 年級題目 JSON 已補上 `reviewStatus`
- app 出題流程已加入 review gating：
  - 只有 `reviewStatus = ok` 的題，才允許進入實際練習 / 測驗出題池
- 目前 `7-9` 題目先統一是 `pending`
- 因此 `7-9` 題目現在不應直接被出到 app，必須逐題審核後改成 `ok`

## 本次已完成事項

### 1. 出題紅線已提到文件最前面

已更新：

- `docs/question-bank-expansion-guidelines.md`
- `docs/AGENT_PROMPT_question_bank.md`

這兩份現在都把最高優先規則放到最前面。

### 2. reviewStatus 機制已落地

已完成：

- `Question` schema 支援 `reviewStatus`
- 出題流程只放行 `reviewStatus = ok`
- 若某個範圍內沒有通過審查的題，app 會提示，不會無反應

相關程式：

- `lib/models/question.dart`
- `lib/services/session_launch_plan_builder.dart`
- `lib/main.dart`

### 3. 7-9 年級審核入口已建立

已生成：

- `docs/question-review-grade7-9-audit.md`

這份文件是目前最重要的逐題審核入口。

## 最高優先紅線

以下任一條不符合，該題不得標 `ok`：

1. 正式題庫以官方題為主，但允許**同水準原創題**進入；來源必須明確標示，且通過同一套複審
2. 不得出現 `MathSpring Editorial Original`
3. 題目必須是真正奧數題，不是一般學校數學題或裸計算題
4. 不得用模板弱變形充數，不可只換數字、故事、單位、圖形尺寸、求量位置
5. 單一能力題不得偷懶標成 `mixed`
6. 數學表達必須像數學，不可用 `2^2`、`3^15` 這類程式式寫法
7. 幾何圖必須真正畫出題目條件，不能只畫外框再貼標籤
8. 若圖形品質不足或會誤導，寧可不上圖，也不要放錯圖
9. `correctAnswer`、`answer`、`solutionSteps`、`source` 必須一致且完整
10. 每題上架前都要複審，通過後才可標 `ok`

## 來源規則

目前正式規則不是「只收官方題」的硬封鎖版本，而是：

- 正式題庫以官方題為主
- 允許同水準原創題進入
- 但原創題必須：
  - `source.type = rewritten_olympiad_style`
  - 清楚補出參考來源或設計依據
  - 通過與官方題相同等級的複審

明確禁止：

- `MathSpring Editorial Original`
- 沒有清楚來源說明的自製題直接進正式 pack

## 目前審核策略

目前採用的是：

- 先擋高風險題
- 先從 `7-9` 年級開始
- 逐題審核
- 審過才標 `ok`

不是：

- 先全題庫一口氣人工看完
- 或先假設全部都可出題

## reviewStatus 使用規則

目前建議狀態：

- `pending`
- `needs_fix`
- `fixed`
- `ok`
- `blocked`

語意：

- `pending`：尚未正式審
- `needs_fix`：已發現問題，尚未修
- `fixed`：已修，但還沒做最終複審
- `ok`：已通過完整複審，可出題
- `blocked`：目前無法判定或需要額外資訊

重要：

- 只有 `ok` 可以出題
- `fixed` 不等於可以出題

## 目前最重要的文件

接手時請按以下順序閱讀：

1. `docs/question-bank-handoff-2026-08-02.md`
2. `docs/question-review-grade7-9-audit.md`
3. `docs/question-bank-expansion-guidelines.md`
4. `docs/AGENT_PROMPT_question_bank.md`
5. `docs/question-bank-subtopic-registry.md`

## 目前最重要的審核文件

### `docs/question-review-grade7-9-audit.md`

這份文件用途：

- 以 `id` 為主鍵逐題追蹤
- 記錄：
  - 題目所屬 pack
  - 年級
  - topic
  - subtopic
  - figure kind
  - answerMode
  - source
  - status
  - risk
  - note

這份文件就是下一位接手者的主要工作台。

## 接手後應怎麼做

### Step 1：先不要亂改規則

先讀：

- `docs/question-bank-expansion-guidelines.md`
- `docs/AGENT_PROMPT_question_bank.md`

不要一開始就重新發明標準。

### Step 2：從 `docs/question-review-grade7-9-audit.md` 開始

依序處理 `7-9` 題目，不要跳整個題庫。

### Step 3：逐題檢查以下項目

每題至少檢查：

1. 是否真為奧數題
2. 是否和既有題重複或只是弱變形
3. `topic + subtopic` 是否正確
4. 是否不該標成 `mixed`
5. 數學排版是否合格
6. 圖形是否真正表意
7. 來源是否合格
8. 詳解與答案是否一致

### Step 4：審核後更新兩個地方

1. 更新審核文件：
   - `status`
   - `risk`
   - `note`

2. 更新題目 JSON：
   - `reviewStatus`

### Step 5：只有通過複審才標 `ok`

如果只是修了，但還沒重審，不可直接標 `ok`。

## 目前已知常見問題

### 1. 圖形品質堪憂

已經實際發現：

- 有些幾何圖只有外框和文字標籤
- 沒有真的畫出題目要求的線段、三角形、陰影區域
- 頂點與中點標示位置不清楚

處理原則：

- 圖若不真正表意，就不能算合格

### 2. 數學排版像程式碼

已經實際發現：

- 題面出現 `3^15` 這類寫法

處理原則：

- 改成正常數學寫法，不可保留工程師式記號

### 3. 分類過粗

已經實際發現：

- 單一題型被標成 `綜合 / mixed`

處理原則：

- 若能落到單一既有題型，就不能偷懶標 `mixed`

### 4. 來源不夠嚴謹

已經實際發現：

- 有題目來源是自製 editorial original

處理原則：

- 不得進正式可出題題庫

## 目前最適合的工作節奏

建議以 pack 為單位推進，但仍逐題落狀態：

1. 先審 `grade7`
2. 再審 `grade8`
3. 再審 `grade9`

每次處理一小批後：

- 更新 audit 文件
- 更新 JSON 的 `reviewStatus`
- 跑測試確認沒有破壞 parser / 出題流程

## 建議每批完成後執行的驗證

至少跑：

```bash
flutter test test/session_launch_plan_test.dart test/widget_test.dart
flutter test test/question_bank_test.dart
```

## 若要擴展到其他年級

當 `7-9` 的流程穩定後，再把同樣機制擴到：

- `1-6`
- `10-12`

不要一開始就全題庫一起改，不然很容易失控。

## 最後提醒

這次接手的核心不是「新增更多題」。

核心是：

- 把題目審核制度做實
- 把 `7-9` 題庫真正清乾淨
- 讓之後只有通過複審的題才會進 app

若不確定某題是否夠格，寧可留在 `pending / needs_fix / blocked`，不要硬標 `ok`。
