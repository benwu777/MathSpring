# 題庫擴充與品質閘門：交接與已知缺口

最後更新：2026-09-04
分支：`question-bank-expansion-2026-08`
題庫現況：**2757 題 / 50 個題包**，驗證器全綠，Flutter 208 passed、Python 工具 70 passed。

## 這條線在做什麼

用「多個背景代理平行起草 + 主流程集中把關」的方式補題。代理只寫草稿到 scratchpad，
去重與寫入由主流程獨佔。規範見 `docs/question-bank-expansion-guidelines.md`
與 `docs/AGENT_PROMPT_question_bank.md`；圖形規格見 `docs/geometry-figure-spec.md`。

2026-09-03 那一輪共補 328 題（2429 → 2757），並開放代理附圖。
2026-09-04 這一輪沒有補題，把當時記下的八項待辦全部做完（見下方「已完成」）。

## 現在的品質閘門

`scripts/validate_question_packs.py` 逐題檢查 schema、四語系、答案一致性、標籤詞彙表、
**zh-Hant 混入簡體字**、**五種 figure kind 的 params**、`geometry_scene` 的座標自洽、
選項長度線索、manifest 一致性。

`scripts/dump_figure_previews.py` 把題庫的圖渲染成 PNG 供人目視
（`--kind` / `--id` / `--grade` / `--all`），走的是 app 自己的 `buildFigureRenderSpec`。

**驗證器過不代表圖是對的。**它只看得出 params 的形狀合不合法，看不出圖有沒有畫錯題意。
2026-09-04 逐張看圖才發現「圓內接正方形」那題只畫了一個空圓、「兩種拼法周長相差」
那題只畫了其中一種拼法——兩題的 params 都完全合法。**新增附圖的題一定要看過畫面。**

## 已完成（2026-09-04）

原本的八項待辦全部處理完畢，摘要如下；細節見對應 commit。

1. **`c:calculus` 誤標**——`geometry_grade4_foundation_052` 改標成 `c:mul_div`。
   `c:calculus` 保留在詞彙表，note 註明它現在是**已知的空白概念**（全庫零覆蓋）。
2. **簡體字混入 zh-Hant**——`check_simplified_in_traditional` 進了驗證器。
   字集在 `docs/simplified-only-chars.txt`（493 字），由
   `scripts/derive_simplified_only_chars.py` 從題庫自身的字頻推導。
3. **三種 figure kind 的 params 沒被檢查**——`check_figure_params` 涵蓋五種 kind，
   立刻抓到 25 題（7 題座標超出繪圖區、1 題浮點座標會 fallback 成 0、
   17 題贅餘的 `params.kind`、2 題根本不存在的 `highlightInterval` 等），全部修掉。
4. **`composite_grid_shape` 沒有目視工具**——`figure_preview_test.dart` 改走
   `buildFigureRenderSpec`，五種 kind 都畫得出來；新增 `dump_figure_previews.py`
   直接從真實題包挑題。26 張格線圖與 42 張 `shape_diagram` 已逐張看過。
5. **`circle_quadrants_point` 只有 topRight 能上色**——renderer 已改成四個象限都能上色，
   由 `test/circle_quadrants_painter_test.dart` 取樣像素驗證；驗證器也擋掉不合法的
   `shadedRegion` 與 `regionLabels` 鍵。
6. **未知 kind 靜默不畫**——現在會留一行 `debugPrint`；
   `test/figure_render_spec_test.dart` 涵蓋五種 kind 與未知 kind 的行為，
   另有 Python 測試比對驗證器白名單與 renderer 的 switch 分支，擋兩邊漂移。
7. **選項的數學排版沒驗過**——全庫 27 個帶 √ 的選項都跑過
   `normalizeMathText` → `splitEmphasis`（`test/option_math_text_test.dart`），
   另有一條 widget test 把 5 個全帶根號的選項真的渲染出來，確認沒有 overflow。
8. **選項長度門檻是舊資料訂的**——用 476 道選擇題重量一次分布，改成**兩個條件都要滿足**
   （比值 ≥ 1.5 且絕對字數差 ≥ 10），並修掉它抓出的 3 題。
9. **圖把答案畫出來**（第 2 項目視時才發現的一族）——`check_figure_leaks` 擴充成
   也擋「問某點坐標、圖上就把那個點畫在答案位置」，抓到 2 題；
   另一題（三條直線圍成的三角形求面積）任何忠實的座標圖都會送分，改成不畫圖。

## 待辦

### 1. `c:calculus` 是全庫唯一零覆蓋的概念
切線斜率、瞬時變化率這類 grade11-12 題材答案可以是整數，補題時優先往這裡填。
記憶檔提過「題庫飽和後要掃空白概念才不會撞題」，這就是現成的一個。

### 2. 沒有在真機 / 模擬器上看過
所有圖的目視都是 PNG，走的是 app 同一條 painter 路徑，但沒有在真的題目版面裡看過。
這一輪改了 `composite_grid_shape` 與 `coordinate_plane` 的長寬比（本來寫死，
現在跟著資料走），會影響題目頁的版面高度，值得跑一次 app 確認。

### 3. `trig_plane` 只服務 app 內建的展示畫面
renderer 支援但不在題庫白名單裡，因為 `TrigGraphPainter` 完全不讀 params，
畫的是寫死的 sin/cos 曲線。這個不對稱是刻意的，已由測試釘住，但如果哪天想讓題庫
畫三角函數圖，得先讓那支 painter 真的吃 params。

### 4. `geometry_scene` 的 94 張圖沒有重看
它本來就有目視工具、驗證器對它的檢查也最完整，這一輪沒有逐張重看。

## 不屬於這條線的既有異動
`macos/` 底下有 5 個未提交的建置檔異動（Podfile、Podfile.lock、project.pbxproj、
Runner.xcscheme、AppDelegate.swift），在 2026-09-03 那個 session 開始前就存在，
與題庫無關，未處理。

## 補題的關鍵教訓（詳見記憶檔）
- 去重要跑六道閘門，各自抓不到的東西不同；**字面分數低不代表沒撞**——
  第二輪有一題字面只有 0.41，但模板掃描的**詳解**相似度 0.60。
- **代理只掃自己的切片不夠，一定要掃全庫**：同一個推理骨架可以出現在任何年級、任何 topic。
- **代理會在送出報告前最後一刻改檔**，一定要等 task-notification 到達才整合。
- 代理寫選擇題會系統性地讓正解比誘答長（已有驗證器擋，但仍要在規格裡明講）。
- **實際上網查閱來源題目**能把撞題率從每 12 題 4–6 題降到每 10 題 1 題。
- **圖畫得出來不等於畫對**：驗證器只驗 params 形狀，畫錯題意只有看畫面才抓得到。
- **圖很容易變成送分**：座標圖如實畫出來，學生常常可以直接把答案讀出來。
  出附圖的題要先問「這張圖有沒有把該算的東西畫掉」。
