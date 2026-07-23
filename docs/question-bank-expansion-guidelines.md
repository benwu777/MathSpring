# MathSpring 題庫擴充操作準則

## 目的

這份文件是給後續工程師、內容編輯者、或其他模型直接使用的題庫擴充規範。

目標是讓 MathSpring 在持續補題時：

- 題目風格保持奧數導向
- 分類與難度一致
- 不重複塞入相似題
- 官方題與改寫題的來源清楚可追蹤
- 能直接對應目前 app 的 JSON schema

本文件日期基準：2026-07-23。

## 先讀文件

在新增或修改題庫前，先讀以下文件：

- [question-bank-taxonomy.md](/Users/benwu/sideproject/Flutter/MathSpring/docs/question-bank-taxonomy.md)
- [olympiad-template-spec.md](/Users/benwu/sideproject/Flutter/MathSpring/docs/olympiad-template-spec.md)
- [olympiad-template-registry.md](/Users/benwu/sideproject/Flutter/MathSpring/docs/olympiad-template-registry.md)
- [assets/question_templates/olympiad_template_registry.v1.json](/Users/benwu/sideproject/Flutter/MathSpring/assets/question_templates/olympiad_template_registry.v1.json)
- [plans/2026-07-18-olympiad-content-policy.md](/Users/benwu/sideproject/Flutter/MathSpring/docs/plans/2026-07-18-olympiad-content-policy.md)
- [local-data-architecture.md](/Users/benwu/sideproject/Flutter/MathSpring/docs/local-data-architecture.md)

若新增題目的做法違反上述文件，以這些既有規範為準。

## 內容來源優先順序

題目來源應依照以下順序使用：

1. 官方公開競賽題庫，用來抽取題型、難度、語氣、常見陷阱
2. 官方題的安全改寫版
3. 依既有模板系統擴寫的 olympiad-style 新題

目前建議優先參考的來源：

- Math Kangaroo USA 歷年 PDF 與解答
- IMC Taiwan 官方試題
- 其他具官方身分、公開可查證的國小數學競賽卷

## 版權與可收錄邊界

除非已確認可重製權利，否則不要預設官方題可以直接原文打包進 app。

規則如下：

- 只把官方題當成題型與難度基準：可直接研究
- 要放進 app 的內容：優先使用改寫題
- 若已明確決定收錄官方題：每題必須補完整 `source`
- 若權利狀態不明：保留 `source.type = official_reference`，但不要假設可以大規模照抄

## 題目準則

每題都必須符合以下最低標準：

- 不是一般教科書練習題，而是有奧數型推理成分
- 有唯一明確答案
- 題幹敘述直白，不使用模糊代稱或不必要包裝語
- 有完整解題步驟，不只給答案
- 能明確歸入既有 `topic` 與 `subtopic`
- 能判定難度
- 若需要圖形，圖形可由 app 內直接繪製或以穩定方式呈現

不應收錄的題：

- 只有直接套公式、無推理的純計算題
- 條件不完整或可能多解
- 和既有題只有換數字、沒有新推理差異
- 用詞不自然，像是機器直接生成的題
- 超出國小奧數常見認知範圍太多

## 難度分層規則

目前題目 `difficulty` 使用三層：

- `foundation`
- `advanced`
- `competition`

判定原則：

### foundation

- 1 到 2 個主要推理步驟
- 題幹短
- 幾乎沒有陷阱條件
- 適合建立題型基礎

### advanced

- 2 到 3 個主要推理步驟
- 題目有轉換或隱含條件
- 比 `foundation` 更像正式競賽中段題

### competition

- 3 到 4 個主要推理步驟
- 有明顯結構轉換、分類討論、反推、不變量、容斥、因數結構或較強幾何觀察
- 接近真實競賽卷較後段題

注意：

- 難度提升不能只是數字變大
- 同一 `subtopic` 下應盡量形成基礎版與競賽版的梯度

## 類別與子分類規則

主分類使用既有 `topicCode`：

- `arithmetic`
- `geometry`
- `logic`
- `mixed`

新增題目前，先判斷它是否能落入已存在的 `subtopic` family。

若能落入既有 family：

- 優先沿用

若不能：

- 先確認是否真的需要新 `subtopic`
- 不要隨意發明只用一次的臨時子分類

## 去重規則

新增題目前，必須先檢查是否已有「同型題」。

視為重複或高度重疊的情況：

- 題幹只換數字，推理骨架完全相同
- 圖形只換尺寸，核心結論相同
- 選項不同，但解法與陷阱結構相同

視為可共存的情況：

- 同一模板 family，但難度層不同
- 同一主題，但解題核心不同
- 同一題型，卻引入新的結構條件或錯誤誘因

實務流程：

1. 先找相同 `topic + subtopic`
2. 再比對解法骨架
3. 若只是數字換皮，不新增
4. 若是同型進階版，可新增並標更高難度

## 新題處理流程

每次補題請照這個順序：

1. 從官方題庫整理候選題
2. 為每題標記：
   - 來源
   - 對應年級或競賽級別
   - topic
   - subtopic
   - difficulty
3. 對照現有題庫做去重
4. 決定：
   - 直接收官方題
   - 改寫成 app 版
   - 不收
5. 補齊 JSON 欄位
6. 若有圖，確認 renderer 支援
7. 更新 `manifest.json`
8. 跑題庫解析與 widget 測試

## JSON 必備欄位

每題至少要有：

- `id`
- `topic`
- `subtopic`
- `difficulty`
- `levelStage`
- `challengeTier`
- `prompt`
- `answer`
- `solutionSteps`
- `figure`
- `answerMode`
- `correctAnswer`
- `source`

視答題方式補：

- `options`
- `inputConstraints`

## source 填寫規則

### 改寫題

使用：

- `source.type = rewritten_olympiad_style`

並填：

- `name`
- `reference`
- `notes`

### 官方題

使用：

- `source.type = official_reference`

並盡量填：

- `contest`
- `year`
- `division`
- `problemNumber`
- `displayText`
- `sourceUrl`

`displayText` 不需要多語系，保留原語言即可。

## 圖形題規則

若題目需要圖形，優先順序如下：

1. 現有 `CustomPainter` 可直接支援
2. 在現有 renderer 上新增可重用 figure kind
3. 最後才考慮靜態素材

原則：

- 幾何題盡量不用點陣圖
- 圖形必須能跟著 app 穩定縮放
- 同一種圖形 family 儘量抽象成 reusable `figure.kind`

## 多語系規則

目前題目內容至少維持：

- `zh-Hant`
- `zh-Hans`
- `en`
- `ja`

規則：

- 以繁中作為主編輯版本
- 再補簡中、英文、日文
- 若官方來源本身為中文或英文，`source.displayText` 保留原文即可
- 題幹翻譯需保留數學條件精確性，不可只做語感翻譯

## 年級與競賽級別規則

雖然 UI 現在以競賽級別為主，但題庫仍保留 `levelStage`。

擴題時請遵守：

- `grade1` 到 `grade2`：袋鼠 1-2 的體感
- `grade3` 到 `grade4`：袋鼠 3-4 的體感
- `grade5` 到 `grade6`：袋鼠 5-6 與國小競賽複賽體感

若題目明顯過難：

- 不要硬塞進 foundation pack
- 可放到同 stage 的 `advanced` 或 `competition` 題

## 驗證清單

每次補題後至少確認：

- JSON 可正常 parse
- `manifest.questionCount` 與實際題數一致
- 每題 `source` 存在
- 每題至少有繁中與英文，正式收錄時補齊四語
- 圖形題能正常 render
- 同題型沒有無意義重複
- 難度標記合理

## 推薦工作方式

若使用其他模型協作，建議在任務開頭直接附上：

- 本文件
- `docs/question-bank-taxonomy.md`
- `docs/olympiad-template-spec.md`
- 目標 pack 檔案

並要求對方輸出：

1. 題型判定
2. 是否與現有題重複
3. 建議 difficulty
4. `source` 寫法
5. 完整 JSON

## 本文件適用範圍

本文件適用於：

- 題庫擴充
- 官方題整理
- AI 生成題人工複核
- 題型去重
- 後續模型接手內容開發

若未來 schema 有變更，請同步更新本文件。
