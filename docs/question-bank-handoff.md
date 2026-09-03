# 題庫擴充與品質閘門：交接與已知缺口

最後更新：2026-09-03
分支：`question-bank-expansion-2026-08`
題庫現況：**2757 題 / 50 個題包**，驗證器全綠，Flutter 183 passed、Python 工具 30 passed。

## 這條線在做什麼

用「多個背景代理平行起草 + 主流程集中把關」的方式補題。代理只寫草稿到 scratchpad，
去重與寫入由主流程獨佔。規範見 `docs/question-bank-expansion-guidelines.md`
與 `docs/AGENT_PROMPT_question_bank.md`；圖形規格見 `docs/geometry-figure-spec.md`。

本 session 共補 **328 題**（2429 → 2757），並新增兩道品質閘門
（選項長度線索、幾何圖點名檢查）。2026-09-03 使用者裁示**開放附圖**，
第三輪起代理可以產 `geometry_scene` 等圖形。

## 待辦（按價值排序）

### 1. `c:calculus` 標錯，且它是該標籤唯一的使用者
`geometry_grade4_foundation_052` 的標籤是 `['c:calculus','c:area','c:quadrilateral','m:direct']`，
但題目是「長方形分成 4 塊，已知三塊面積求第四塊」——四年級題，跟微積分無關。
`c:calculus` 全庫只有這一題在用，所以**這個概念實際上是零覆蓋**。

要做的事：把 `c:calculus` 從這題移除（`c:area` + `c:quadrilateral` 已足夠，
或補 `c:mul_div`）；然後決定 `c:calculus` 是要保留在詞彙表等高中題來補，
還是直接從 `docs/question-bank-tags.json` 移除。**注意驗證器要求每題至少 1 個
`c:` 標籤**，移除後這題還有兩個，沒問題。

### 2. 簡體字混入 zh-Hant 的檢查還沒進驗證器（要 TDD）
第三輪抓到一個新的失敗模式：代理把簡體文字**同時寫進 `zh-Hant` 與 `zh-Hans`**，
等於繁體欄位整段是簡體。既有閘門（英文殘留掃描、四語系齊全檢查）完全抓不到。

當時的偵測方式：從題庫自身推導「簡體專用字」——在 `zh-Hans` 出現 ≥5 次、
但在 `zh-Hant` 從未出現的漢字，得到 490 個字。用這個集合掃，確認**全庫既有題乾淨**，
只有那兩題中標（已改寫）。

要做的事：把這個檢查做進 `scripts/validate_question_packs.py`（先寫失敗測試）。
字元集合建議存成獨立資料檔（例如 `docs/simplified-only-chars.txt`）而不是寫死在程式裡，
並在檔頭註明它是怎麼推導出來的。推導腳本可以重寫，很短：
比較全庫 zh-Hans 與 zh-Hant 的字頻即可。

### 3. 三種 figure kind 的 params 驗證器完全不檢查
只有 `geometry_scene` 有 `scene_checks()`。`shape_diagram`（42 題）、
`coordinate_plane`（41 題）、`composite_grid_shape`（26 題）的 params 寫錯時，
**畫面只會靜默畫錯或一片空白，不報錯、不留 log**。開放附圖之後這個缺口變得重要。

已知的具體陷阱（都寫在 guidelines 的 figure kind 表格裡）：
- `coordinate_plane` 的 `highlightPoint` 不會自己畫點，只把 `points` 裡座標相同的
  那一點改成紅色；不匹配就完全沒有效果。
- `composite_grid_shape` 的 `filledCells` 是 0-indexed `[row, col]`，row 0 在最上面；
  超出 `rows`/`cols` 的格子不會被畫也不會報錯。
- `shape_diagram` 的 `shape` 若不是支援清單裡的值，會靜默 fallback 成 rectangle。

### 4. `composite_grid_shape` 沒有目視工具
`test/figure_preview_test.dart` 只渲染 `GeometryScenePainter`。第三輪收進的
4 張 `composite_grid_shape` 圖只用程式核對過 `filledCells` 與題意方格數一致，
**沒有人看過畫面**。要嘛擴充那支 test 讓它也能渲染其他 painter，要嘛接受風險。

### 5. `circle_quadrants_point` 實際上是壞的
`shadedRegion` **只有 `"topRight"` 有作用**，填其他值靜默不上色；圓、四個鑲邊點
（標籤寫死 A/B/C/D）與內部點的位置全部寫死，無法設定。全庫只有
`geometry_grade6_foundation_014` 一題在用。
要嘛修 renderer 讓四個區域都能上色，要嘛把那題改成 `geometry_scene` 後移除這個 kind。
guidelines 目前已標明「不要用」。

### 6. 未列在 switch 裡的 figure kind 會靜默不畫
`lib/main.dart` 的 `_buildFigureRenderSpec` 對未知 kind 回傳 null，
`_QuestionFigureView` 就 `SizedBox.shrink()`——不報錯、不留 log、畫面一片空白。
驗證器的 `KINDS` 白名單擋住了題庫這一側，但 renderer 這一側沒有測試涵蓋這條路徑。
另外 `trig_plane` 是 renderer 支援但白名單沒有的 kind（只存在於測試 fixture）。

### 7. 選擇題選項的實機排版沒有驗證
`geometry_grade8_foundation_050` 是全庫第一題把 `√` 放進 `options` 的題
（題幹／詳解用 √ 的有 135 題，但選項是第一次）。已從程式碼確認選項與題幹
走同一條 `normalizeMathText` → `_emphasisText` 路徑（`lib/main.dart:4385`），
理論上渲染一致，但沒有實機看過。

### 8. 選項長度門檻是依現況資料選的
`OPTION_LENGTH_RATIO = 1.6`、`OPTION_LENGTH_FLOOR = 12` 是量測當時 470 道選擇題的
長度比值分布後決定的（現在 476 道）。選擇題數量大幅增加後值得重新量一次分布。

## 不屬於這條線的既有異動
`macos/` 底下有 5 個未提交的建置檔異動（Podfile、Podfile.lock、project.pbxproj、
Runner.xcscheme、AppDelegate.swift），在本 session 開始前就存在，與題庫無關，未處理。

## 補題的關鍵教訓（詳見記憶檔）
- 去重要跑六道閘門，各自抓不到的東西不同；**字面分數低不代表沒撞**——
  第二輪有一題字面只有 0.41，但模板掃描的**詳解**相似度 0.60。
- **代理只掃自己的切片不夠，一定要掃全庫**：同一個推理骨架可以出現在任何年級、任何 topic。
- **代理會在送出報告前最後一刻改檔**，一定要等 task-notification 到達才整合。
- 代理寫選擇題會系統性地讓正解比誘答長（已有驗證器擋，但仍要在規格裡明講）。
- **實際上網查閱來源題目**能把撞題率從每 12 題 4–6 題降到每 10 題 1 題。
