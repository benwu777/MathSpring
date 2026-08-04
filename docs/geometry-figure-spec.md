# 幾何圖形規格（geometry_scene）

本文件定義幾何題「AI 產圖」的宣告式規格。目標：AI 針對每題算出**精確幾何資料**（含交點等衍生座標），由強化後的 `ShapeDiagramPainter` 畫成向量圖，忠實呈現題目條件（符合擴充準則紅線 7、8）。

視覺原型（SVG，效果＝ app 內效果）：grade7 009 / 007 / 004 三題，見產圖 demo。

## 何時用 geometry_scene / 何時 kind:none

- 題目有需要「畫出構造」（中點、中線、角平分線、交點、陰影區、圓弧）→ 用 `geometry_scene`，AI 補精確座標。
- 圖對理解無實質幫助、或 renderer 尚未支援該原語 → `figure.kind = "none"`，並確保題幹文字自足。
- 舊的 `shape_diagram`（只畫基本形狀＋貼文字標籤）不得再用於需要構造的題——那是「畫外框貼字」，違反紅線 7。

## 座標慣例

- 數學慣例：**y 向上**。renderer 負責翻轉成螢幕座標並依 `bounds` 等比縮放置中。
- 座標是**示意等比**：形狀比例要對（等腰要像等腰、直角要是直角、中點要在中點），數值不必等於題目給的長度。
- 衍生點（兩線交點、垂足等）**由 AI 事先算出**填入 `points`，renderer 不做幾何運算。

## Schema

```jsonc
{
  "kind": "geometry_scene",
  "bounds": { "minX": 0, "minY": 0, "maxX": 6, "maxY": 6 },   // 數學座標畫布範圍
  "points": [
    { "name": "A", "x": 0, "y": 6, "pos": "tl" }               // pos = 標籤方位
  ],
  "segments": [
    { "from": "A", "to": "C", "style": "construction" }        // solid | construction(虛線)
  ],
  "polygons": [
    { "vertices": ["A", "F", "E", "D"], "fill": "shaded" }      // 陰影區（頂點需為 points 名稱）
  ],
  "arcs": [
    { "cx": 0, "cy": 5, "r": 5, "from": 0, "to": 180 }         // 圓心/半徑/起訖角(度, 逆時針)
  ],
  "angleMarks": [
    { "at": "A", "from": "B", "to": "C", "label": "40°" }       // 角度弧＋數值
  ],
  "rightAngles": [
    { "at": "D", "from": "A", "to": "B" }                       // 直角小方塊
  ],
  "equalTicks": [
    { "segments": [["A","B"], ["A","C"]], "count": 1 }          // 等長邊記號(同組同 count)
  ]
}
```

### 欄位說明

- `points[].pos`：標籤相對點的方位，取 `t / b / l / r / tl / tr / bl / br`。
- `segments[].style`：`solid`＝題目實體邊；`construction`＝輔助線（對角線、中線、角平分線），畫成虛線。
- `polygons[].fill`：目前支援 `shaded`（半透明強調色）。頂點依序連成封閉多邊形。
- `arcs`：角度以度為單位、逆時針為正；用於半圓、四分圓、扇形邊界。
- `angleMarks` / `rightAngles`：`at` 為頂點，`from`、`to` 為兩邊上的另一點，決定角的張開方向。
- `equalTicks`：同一組 `segments` 畫相同數量的短斜線，表示等長。

## AI 產圖作業原則

1. 先在數學座標系放好各點，讓比例忠實（等腰、直角、平行、中點要看得出來）。
2. 算出所有**衍生點**（交點、垂足、中點）並命名放進 `points`。
3. 只畫題目需要看到的元素；輔助線用 `construction`。
4. 陰影區頂點要按邊界順序，且都在 `points` 內。
5. 上架前對照「幾何圖複審四問」：只看圖能否辨識要用的點線區域、關係有無真的畫出、位置會不會誤導、拿掉題幹圖是否仍有用。

## Renderer 支援狀態

- [ ] `ShapeDiagramPainter` 支援 `geometry_scene`（points / segments / polygons / arcs / angleMarks / rightAngles / equalTicks）——待實作。
- 實作完成前，需要構造圖的幾何題先維持 `reviewStatus = pending`，不標 ok。
