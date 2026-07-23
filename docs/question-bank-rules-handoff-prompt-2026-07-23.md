# MathSpring 題庫規則修訂交接提示

你現在要接手修訂 MathSpring 的題庫規則文件。

你的目標不是補題，而是消除規則衝突，讓後續模型或編輯者可以穩定依規則擴充題庫。

## 先讀

請先完整閱讀以下文件：

- `docs/question-bank-rules-open-items-2026-07-23.md`
- `docs/question-bank-expansion-guidelines.md`
- `docs/AGENT_PROMPT_question_bank.md`
- `docs/olympiad-template-spec.md`
- `docs/question-bank-taxonomy.md`

必要時可參考：

- `docs/olympiad-template-registry.md`
- `docs/question-bank-audit-2026-07-23.md`

## 任務目標

你要完成以下事情：

1. 統一 phase 1 的主題體系
2. 統一 phase 1 的難度體系
3. 補齊 canonical `subtopic` 規則
4. 補齊題庫上架驗收 checklist
5. 補齊 `figure`、`answerMode`、`options`、`inputConstraints`、`source` 的 schema-level 規則

## 重要限制

- 不要另開新規則體系
- 不要只修字句，必須真正消除衝突
- 不要讓中文主規範和英文 spec 繼續各講各的
- 不要把「實作現況」和「正式規則」混寫成模糊描述

## 建議處理順序

1. 先決定正式 phase 1 規則：
   - 主題體系採四類或六類
   - 難度體系採兩層或三層
2. 以 `docs/question-bank-expansion-guidelines.md` 作為主文件收口
3. 同步修正：
   - `docs/AGENT_PROMPT_question_bank.md`
   - `docs/olympiad-template-spec.md`
   - `docs/question-bank-taxonomy.md`
4. 視需要新增：
   - canonical subtopic registry
   - 題庫上架驗收 checklist

## 完成標準

完成後，應能明確回答：

1. phase 1 主題體系是什麼
2. phase 1 難度體系是什麼
3. `subtopic` 允許集合與新增規則是什麼
4. 題目上架前必檢清單是什麼
5. 哪些文件已同步修正

## 回報格式

完成後請回報：

- 最終決策摘要
- 修改了哪些文件
- 是否新增 registry 或 checklist 文件
- 還有哪些未決項目
