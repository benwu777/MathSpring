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
3. 依既有題型框架手工設計的 olympiad-style 原創新題

補充原則：

- 可以參考官方公開題庫的題型結構，但最終收錄到 app 的題目必須是原創成品
- 不可把一題官方題和另一題官方題的條件或數字「混搭」後當成新題
- 不可用同一骨架大量換數字生題
- 不可把官方題稍微改句子、改數字、改角色名稱後，就視為安全可收錄成品
- `template` 只能用來分類、校稿與檢查難度，不能直接當成 shipping 題目的生成器

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
- 題目本身必須具有獨特性，不能只是既有題的弱變形
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
- 雖然可解，但和正式競賽題相比明顯更像一般學校數學題

## 難度規則（phase 1：不分難度層）

phase 1 **只有一個維度來表示難易：年級（`levelStage`，grade1–grade6）**。不設獨立的難度分層。

- `difficulty` 與 `challengeTier` 兩個欄位**固定填 `foundation`**，作為 schema 佔位，不用來區分難易，也不得填 `advanced` 或 `competition`。
- 廢除舊文件的難度分層制（不論兩層或三層）。不要再新增 advanced / competition 題，也不要用這兩個值。
- 難度由「年級」決定：同一年級內的題目視為同一池，不再細分基礎/進階/競賽。

判定原則（以年級為準）：

- 題目難度須貼齊該 `levelStage`（見「年級與競賽級別規則」）。
- 過難或過易都算不符：明顯超出該年級認知的題不要收；低於該年級兩級以上的裸題也不要收。
- 難度提升不能只是數字變大；但也不要為了「更難」而超出年級範圍。

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
- 只是把同一模板 family 平移到另一年級，沒有新增新的推理轉折
- 平均數、比例、餘數、逆推等題型若僅更換數值規模，也視為重複

視為可共存的情況：

- 同一模板 family，但難度層不同
- 同一主題，但解題核心不同
- 同一題型，卻引入新的結構條件或錯誤誘因
- 同一能力目標，但推理路徑明顯不同

實務流程：

1. 先找相同 `topic + subtopic`
2. 再比對解法骨架
3. 再比對是否只是同一能力模板的弱變形
4. 若只是數字換皮，不新增
5. 若是同型進階版，必須能明確指出新增的推理轉折後才可新增

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
5. 確認成品是否為原創且不屬於模板弱變形
6. 做一次「奧數題複審」
7. 複審不合格就淘汰或重寫，不得因為可解或欄位完整而放行
8. 補齊 JSON 欄位
9. 若有圖，確認 renderer 支援
10. 更新 `manifest.json`
11. 跑題庫解析與 widget 測試

## 奧數題複審規則

每一題在完成初稿後，必須再做一次獨立複審，確認它不是「一般數學題偽裝成奧數題」。

複審至少檢查以下五點：

1. 和公開正式競賽題相比，這題是否仍保有競賽感與 problem solving 結構。
2. 是否至少存在一個真正的推理轉折，而不是單步直算。
3. 是否避免裸題：
   - 裸和差
   - 裸平均
   - 裸連加
   - 裸逆運算
   - 裸周長或面積代公式
4. 是否不是只換數字、換名詞、換情境包裝的模板弱變形。
5. 是否符合對應年級或競賽級別常見的思考深度。

若任一題未通過上述檢查：

- 不得標記為完成
- 不得寫入 shipping pack
- 必須重寫或淘汰

## 模板使用邊界

`olympiad-template-spec.md` 與 `olympiad-template-registry.md` 的用途是：

- 幫題目分類到正確 family
- 幫內容編輯者校對難度與能力目標
- 幫審稿時確認題目是否仍保有奧數結構

它們**不是**：

- 題目量產器
- 只換數字的出題腳本依據
- 可直接對不同年級複製貼上的生題模版

若一題能被描述成「只是某模板的另一組數字」，那題通常不應上架。

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

## answerMode 規則（phase 1 硬規則）

phase 1 **只允許**兩種 `answerMode`，不得新增其他型別：

- `multiple_choice`
- `integer_input`

明確禁止（後續模型不得自行擴充）：

- 分數輸入（fraction input）
- 小數輸入（decimal input）
- 自由文字輸入（free-response text）

若一題的自然答案是分數或小數，必須改寫成整數作答（例如問「幾毫升」而非「幾公升」），或改成選擇題；不可為它發明新的 answerMode。

## schema 欄位必填/可省規則

- `figure`：**每題都必須有** `figure` 欄位。無圖題填 `{"type":"custom","kind":"none","params":{}}`；有圖題 `kind` 必須是 renderer 實際支援的值（目前 `shape_diagram` / `coordinate_plane`），且 `params` 需符合該 kind 的 schema。renderer 畫不出的圖（組合圖、切割線、角度器、一筆畫等）一律 `kind:none`，不可硬塞畫不出的參數。
- `options`：**只有** `multiple_choice` 有；固定 4 個選項 A/B/C/D，四語系齊全，選項互不重複，`correctAnswer.value` 必須指向其中一個 key。`integer_input` 題不得出現 `options`。
- `inputConstraints`：**只有** `integer_input` 有，必填 `allowNegative`（bool）與 `maxDigits`（int）。`multiple_choice` 題不得出現 `inputConstraints`。
- `correctAnswer`：`multiple_choice` 用 `{"type":"choice","value":"<A-D>"}`；`integer_input` 用 `{"type":"integer","value":"<字串數字>"}`。其值必須與 `answer` 文字、`solutionSteps` 結論三者一致。
- `source`：每題必填；改寫題用 `rewritten_olympiad_style`，官方參考題用 `official_reference`（詳見下方 source 規則）。
- `solutionSteps`：四語系陣列長度必須一致（每個語言步數相同）。

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

- 不要硬塞進該年級 pack
- 改放到更高年級的 pack，或直接不收；不要用難度層來容納超綱題

## 上架驗收 checklist（每次補題後逐項核對）

每一題、每一次補題後，必須逐項打勾；任一項不過即不得寫入 shipping pack。

結構與 schema：

- [ ] JSON 可正常 parse
- [ ] `id` 唯一、且符合 `<topicCode>_<levelStage>_<challengeTier>_<serial>` 命名（`challengeTier` 固定為 `foundation`）
- [ ] `topic`/`topicCode` 屬四類之一（arithmetic/geometry/logic/mixed）
- [ ] `difficulty` 與 `challengeTier` 皆固定為 `foundation`（不分難度層；不得用 advanced/competition）
- [ ] `subtopic` 屬 registry 允許集合（見 `question-bank-subtopic-registry.md`）
- [ ] `answerMode` 為 `multiple_choice` 或 `integer_input`（無其他型別）

四語系：

- [ ] `prompt` / `answer` / `solutionSteps`（＋ `options` 若有）四語系齊全（zh-Hant/zh-Hans/en/ja）
- [ ] `solutionSteps` 四語系陣列長度一致
- [ ] 翻譯保留數學條件精確性，非僅語感翻譯

答案一致性：

- [ ] `correctAnswer` 與 `answer` 文字、`solutionSteps` 結論三者一致
- [ ] 已獨立重算/窮舉驗證答案正確（不只信任初稿）
- [ ] `multiple_choice`：恰好一個正解、四選項不重複、`correctAnswer.value` 指向存在的 key
- [ ] `integer_input`：`inputConstraints` 有 `allowNegative` 與 `maxDigits`，且無 `options`

figure：

- [ ] 無圖題填 `kind:none`；有圖題 `kind` 為 renderer 支援值且 `params` 合法（座標在畫布範圍內、shape 為支援形狀）
- [ ] 圖與題意相符（圖是解題必要資訊，非裝飾），renderer 能穩定 render

source：

- [ ] 每題 `source` 存在且完整；改寫題 `rewritten_olympiad_style`、官方參考題 `official_reference`
- [ ] 未把官方題原文照抄進 app（除非 rightsStatus 已 cleared）

去重與奧數品質：

- [ ] 已對同 `topic + subtopic` 做去重比對，非既有題的換數字弱變形
- [ ] 已通過「奧數題複審」五點檢查（見下節），非一般學校數學題偽裝

pack 與測試：

- [ ] `manifest.questionCount` 與實際題數一致
- [ ] 通過題庫解析與 widget 測試

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
