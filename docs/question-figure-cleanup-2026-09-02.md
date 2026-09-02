# 圖形清理準則：共用樣板圖（2026-09-02）

承接同日的題幹／答案複審輪次。這一輪**只處理 figure**，其餘一律不動。

## 背景

全庫 219 題有圖題中，**18 組圖形參數完全相同、涉及 60 題**，集中在 geometry grade1–6。
明顯是複製貼上的樣板圖，例如：

- `shape_diagram` 空白梯形（`labels` 全空）掛在 9 題上
- `coordinate_plane` 一個標著 P 的點 (2,3) 掛在 6 題上——其中 `geometry_grade5_033` 題目說
  P 的 x 座標是 6、`geometry_grade4_034` 依題幹 P =(3,5)，圖都畫在 (2,3)
- `geometry_grade5_009` 是「三角形內角比」題，卻掛 `shape_diagram` 的長方形（標 8 / 6）

違反題庫擴充準則紅線第 7、8 條：**圖必須真正畫出題目條件；圖形品質不足或會誤導，寧可不上圖。**

## 每題三選一

逐題把 `prompt`（四語系都讀）和 `figure` 並排看，然後三選一：

1. **圖是對的 → 不動。** 兩題碰巧共用同一張圖不必然是錯的（例如兩題都在問同一個 2×2 方格）。
   判準是「這張圖有沒有正確表達**這一題**的條件」，不是「有沒有和別題重複」。
2. **圖可以修對 → 改 `params`。** 座標、標籤、格子填法改成符合題幹。
   改完要能通過 renderer 的 schema（見下），且**圖上每個數值都要和題幹一致**。
3. **圖修不對或沒有幫助 → 改成 `kind:none`。** 填 `{"type":"custom","kind":"none","params":{}}`。

**優先序：寧可 `kind:none`，也不要留一張會誤導的圖。**

### 唯一的例外：題目非看圖不可

若題幹沒有圖就無法作答（例如題幹寫「如圖」、或條件只存在於圖上），**不得**改成 `kind:none`——
必須把 `params` 修對。真的修不出來就標 `需重寫題幹` 寫進報告，不要硬改。

## renderer 支援的 kind 與限制

`validate_question_packs.py` 的 `KINDS`：

```
none / geometry_scene / shape_diagram / coordinate_plane
composite_grid_shape / circle_quadrants_point
```

- `shape_diagram` 的 `shape` 只能是 renderer 實作的值：
  `compass` / `square` / `triangle` / `trapezoid` / `parallelogram` / `pentagon` / `circle` / `rectangle`
  （見 `lib/main.dart` 的 painter switch）。`labels` 依形狀支援 `top` / `right` 等鍵。
- `coordinate_plane`：`maxX` / `maxY` / `showGrid` / `points[]` / `highlightPoint`，
  座標必須落在 `maxX` / `maxY` 範圍內。
- `composite_grid_shape`：`rows` / `cols` / `filledCells`（`[row, col]` 陣列）/ `cellLabels`。
- `geometry_scene`：需要精確座標的構造圖，規格見 `geometry-figure-spec.md`。
  **這一輪不要新造 `geometry_scene`**——工作量太大且容易畫錯，需要它的題一律標進報告。
- 不確定某個 `params` 鍵是否支援時，先在同 pack 找已經在用的同 kind 題目照抄結構。

## 不得順手做的事

- 不改 `prompt`、`answer`、`solutionSteps`、`options`、`correctAnswer`
- 不改 `id`、`levelStage`、`difficulty`、`challengeTier`、`answerMode`、`subtopic`、`source`
- 不新增／刪除題目（`manifest.questionCount` 不變）
- 不動別的 pack

## 回報格式

```
pack: <檔名>  有共用圖的題數: <n>
改 params:
  <id> | 原圖畫的是什麼 | 和題幹哪裡不符 | 改成什麼
改 kind:none:
  <id> | 為什麼這張圖救不回來／對理解沒幫助
判定不動:
  <id> | 為什麼這張圖對這一題是正確的
需重寫題幹 / 需 geometry_scene（未動，待裁示):
  <id> | 問題描述
統計: 改 params N 題、改 none M 題、不動 K 題
```

## 收尾

```bash
python3 scripts/validate_question_packs.py
flutter test test/
```

注意 `test/question_bank_test.dart` 有數個測試在斷言特定題目的 `figure.kind`
（例如 `geometry_grade6_foundation_013` 為 `shape_diagram`、`_014` 為 `circle_quadrants_point`，
以及數個 "geometry packs upgrade ... to geometry_scene" 的測試），改動前先 grep 確認。
