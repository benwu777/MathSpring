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

- [x] `GeometryScenePainter`（`lib/main.dart`）已支援 `geometry_scene` 全部原語：points（含標籤方位）/ segments（solid 與 construction 虛線）/ polygons（shaded）/ arcs / angleMarks / rightAngles / equalTicks。解析在 `lib/models/geometry_scene.dart`。
- 因此需要構造圖的幾何題可以正常標 `ok`。

### 上架前必查

- **所有點與圓弧都必須完全落在 `bounds` 內**。`bounds` 只是縮放框，超出的部分會被裁掉。實例：`geometry_grade9_foundation_002` 的圓心 (0,0)、半徑 1 配上 `minX = minY = -0.3`，整圓左下角被截掉，複審時才發現。圓弧要檢查的是 `cx ± r` 與 `cy ± r`，不是圓心。
- **每個 `points` 元素都會被畫出標籤**，沒有「只放點不標字」的選項。因此不要為了畫線而塞入大量輔助點，否則圖面會被標籤淹沒；點多的構造圖請改以文字描述題幹，或先不上圖。
- 舊的 `shape_diagram` 若只有 `{"shape": ..., "labels": {...}}`（畫一個基本形狀再貼文字），一律視為紅線 7 違規，須改為 `geometry_scene` 或 `kind:none`。

### 座標與標記的自洽檢查（最容易漏掉的一類錯誤）

圖上的標記本身就是可驗證的斷言，必須和座標對得起來。這類錯誤肉眼幾乎看不出來，一定要用算的：

- **`equalTicks` 標了等長，兩段就必須真的等長。** 實例：`geometry_grade9_foundation_001` 原本在 BC 與 BE 上畫了等長記號，但座標算出來是 16 與 15，摺疊題的核心條件根本沒被畫對。
- **`rightAngles` 標了直角，該處夾角就必須是 90°。**
- **`angleMarks` 的標籤若寫「60°」，實際夾角就必須是 60°。**
- **`polygons` 的頂點不得共線**（面積為 0 表示圖畫錯了）。
- **衍生點（切點、交點、垂足、內心）必須用算的，不要目測。** 實例：`geometry_grade12_foundation_009` 的小圓圓心原本畫在 (2, 0)，但依題目條件（同時與兩半徑相切且與大圓內切）應在 OP = 2r = R − r = 10/3。

建議在複審流程中對每個 pack 跑一次自動檢查：把上述四項與「所有點和圓弧實際繪出範圍都落在 `bounds` 內」一起驗，可在不看圖的情況下攔下絕大多數座標錯誤。注意圓弧要看 `from`/`to` 實際畫出的那一段，不要當成整圓（`geometry_grade12_foundation_008` 的 0°–60° 弧就會被誤判為超界）。
