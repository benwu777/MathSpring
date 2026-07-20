# Practice And Quiz Session Design

**Goal**

讓題庫頁成為正式出題入口，支援 `練習模式` 與 `測驗模式` 兩種作答流程，並記錄計時、分數、逐題作答結果與詳解查看。

**Validated Decisions**

- 題庫頁先選主題與程度，再選 `練習` 或 `測驗`
- 練習模式走無限題流
- 練習模式每題作答後立即判對錯並可立即看詳解
- 練習模式答錯不重作，直接進下一題
- 練習模式可隨時離開，離開時顯示本次練習小結
- 測驗模式固定 10 題
- 測驗模式只記錄從開始到交卷的總耗時，不做倒數限時
- 測驗模式交卷後才顯示詳解
- 測驗模式結果頁第一版只顯示總分、答對題數、總耗時，並可逐題看詳解
- 測驗模式總分先只看答對題數，不做權重與部分得分

## 1. Session Flow

### Practice Mode

- 從題庫頁選定主題與程度後進入
- 系統即時出第一題
- 使用者作答後立即判定正確或錯誤
- 當題立即顯示答案與詳解
- 系統自動切到下一題
- 使用者可隨時離開
- 離開時顯示本次練習小結：
  - 作答題數
  - 答對題數
  - 總耗時

### Quiz Mode

- 從題庫頁選定主題與程度後建立一個固定 10 題 session
- 開始作答時計時
- 不做倒數，不自動超時交卷
- 作答過程中不顯示詳解
- 第 10 題完成或手動交卷後結束 session
- 結果頁顯示：
  - 總分
  - 答對題數
  - 總耗時
- 結果頁可逐題展開詳解

## 2. Data Model Direction

現有資料責任拆成三層：

### Question JSON Packs

負責題目內容本身：

- 題目文字
- 題目圖形
- 答案
- 解題步驟
- 難度
- 類別
- 作答方式

### Session Data

負責一次完整作答過程。

建議新增：

- `PracticeSession`
- `QuizSession`
- `SessionAnswerRecord`

建議欄位：

#### Session

- `id`
- `learnerId`
- `mode`
- `topicCode`
- `levelStage`
- `startedAt`
- `endedAt` / `submittedAt`
- `elapsedSeconds`
- `totalQuestions`
- `correctCount`

#### SessionAnswerRecord

- `sessionId`
- `questionId`
- `sequence`
- `submittedAnswer`
- `isCorrect`
- `answeredAt`
- optional: `timeSpentSeconds`

### QuestionProgress

保留做 learner 對單題的最新狀態摘要：

- 最後一次作答結果
- 是否正確
- 最後更新時間

這層不承擔完整 session 歷史，只提供首頁統計與題目清單快速標示。

## 3. Screen Structure

### Library Page

升級成正式入口頁：

- 主題選擇
- 程度選擇
- `開始練習`
- `開始測驗`

### Practice Answer Page

- 顯示目前 learner
- 顯示主題
- 顯示目前累積題數
- 顯示累積耗時
- 題目文字 / 圖形 / 作答元件
- 當題即時答案與詳解區

### Practice Summary Page

- 本次作答題數
- 本次答對題數
- 本次總耗時

### Quiz Answer Page

- 顯示 `第幾題 / 10`
- 顯示累積耗時
- 顯示交卷按鈕
- 不顯示詳解

### Quiz Result Page

- 總分
- 答對題數
- 總耗時
- 每題詳解展開列表

## 4. Recommended Implementation Order

1. 先做測驗模式的固定題組 session
2. 抽出共用作答頁與作答狀態
3. 再接練習模式無限題流
4. 補離開練習小結頁
5. 最後把首頁統計與題庫標示接到新的 session / answer records

## 5. Why This Order

- 測驗模式邊界最明確，最適合先建立 session 資料模型
- 練習模式可重用大部分作答 UI，只調整回饋時機與 session 結束條件
- 先把 session 基礎做穩，後面的錯題本、歷史紀錄、主題分析才不會重做
