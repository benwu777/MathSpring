# grade7-12 題庫擴充紀錄（2026-08-14）

## 結果

30 個 pack（6 個年級 × 5 個主題）**每個都從 9 或 10 題補到 15 題**，新增 165 題，
grade7-12 總題數由 285 增至 450 題，全部 `reviewStatus = ok`。

| 年級 | 代數 | 組合 | 幾何 | 邏輯 | 數論 | 小計 |
| --- | --- | --- | --- | --- | --- | --- |
| grade7 | 15 | 15 | 15 | 15 | 15 | 75 |
| grade8 | 15 | 15 | 15 | 15 | 15 | 75 |
| grade9 | 15 | 15 | 15 | 15 | 15 | 75 |
| grade10 | 15 | 15 | 15 | 15 | 15 | 75 |
| grade11 | 15 | 15 | 15 | 15 | 15 | 75 |
| grade12 | 15 | 15 | 15 | 15 | 15 | 75 |

驗證狀態：

- `flutter test` 142 passed
- 30 個 pack 全數通過結構檢查（四語系、步數一致、answerMode 欄位互斥、
  correctAnswer 型別、禁用來源標記、程式式冪次記法、圖形 bounds）
- 新增的 9 個 `geometry_scene` 全數通過座標自洽檢查
- `dart run tool/question_bank_duplicate_audit.dart`：牽涉 grade7-12 的候選群組 0 組

## 每一題的作業流程

1. 先列出該主題在 grade7-12 全部既有題的 subtopic 與題幹，避開已用過的解法骨架
2. 設計題目後，**先寫驗算程式獨立求解**（窮舉、BFS/Dijkstra、模擬、精確分數等），
   確認答案後才寫進題庫；詳解中的每個對照數字（常見誤答、抽查值）也一併實算
3. 四語系齊備，`source.type` 一律 `rewritten_olympiad_style`，
   `source.notes` 寫明設計依據與該題的關鍵轉折
4. 每個 pack 一個 commit，commit 前跑結構檢查、去重稽核、跨主題比對與 `flutter test`

難度對齊沿用既有基準：grade10 = AMC 10、grade11 = AMC 12、grade12 = AIME 入門層。

## 本輪建立的新工具

### 跨主題近似比對（`cross_topic_dupes.py`）

既有的 `tool/question_bank_duplicate_audit.dart` 以 **topic + subtopic** 分組，
因此抓不到「同一題被放在不同 topic」的情形。本輪新增的比對把題幹去掉數字與標點後
取字元 3-gram 算 Jaccard 相似度，對 grade7-12 全部題目兩兩比較。

它在本輪抓出三組真實問題，都已修正：

- `number_theory_grade7_012` 原寫「把 2025 寫成連續正整數之和」，與既有的
  `algebra_grade7_006`「把 45 寫成連續正整數之和」只有數字不同 → 換成最大公因數的分割應用
- `combinatorics_grade11_010` 原寫 Σ k·C(10,k)，與本輪新增的
  `combinatorics_grade9_012`（C(10,0)+C(10,2)+⋯）相似度 0.87 → 換成整數分割計數
- `combinatorics_grade12_014` 與 `combinatorics_grade9_012` 相似度 1.00
  （去數字後結尾的定義子句完全相同）→ 改寫題幹情境

另有兩處只改寫措辭而保留題目（數學內容確實不同，僅句型接近）：
`geometry_grade11_011`（與 grade10_011 的「三角形的三邊長分別是⋯」）、
`geometry_grade12_011`（與 grade11_014 的「求這個三角形的面積」）。

**教訓：同一批次內新增的題目最容易互撞**，因為出題者的句型習慣一致。
去重不能只靠 subtopic 分組，題幹層級的比對是必要的第二道關卡。

### `packlib.py` 與 `geometry_scene` 就地檢查

組裝題目物件的共用工具，在寫入前就檢查四語系步數一致、subtopic 不與同 pack 重複；
`scene()` 另在建構時即驗證所有點與圓弧落在 bounds 內、`rightAngles` 確為 90°、
`angleMarks` 的標籤與實際夾角相符。

## 仍待處理

1. **`geometry_grade4_foundation_003` 的圖有錯**：題目說「一直線上有兩個相鄰角，
   其中一個是 65°」，圖上 `angleMarks` 也標了 65°，但點 C 的座標 (6.2, 3) 算出來
   實際夾角是 53.75°。把 C 移到 (5.3946, 2.9908)（距 O 為 3.3、方向 65°）即可修正。
   本輪未動此檔，因為它當時有未提交的修改。
2. **grade1-6 的 960 題仍未逐題複審**，且本輪把 `geometry_scene` 座標檢查擴及
   grade1-6 時就立刻抓到上述缺陷，顯示該範圍的圖形值得做一次完整掃描。
3. 既有的判斷事項（難度偏低的官方題、`logic_grade10_002`/`003` 的分類偏差、
   `number_theory_grade12_003` 的來源引用）維持原狀，見
   `question-review-grade10-12-audit.md`。
