# iPad 版面重新設計

日期：2026-09-04
狀態：設計已確認，待實作

## 問題

app 目前是「手機版面直接放大」。全專案只有 **3 個斷點判斷**（900、900、980）、
**42 處寫死的 fontSize**（13 種不同數值）、完全沒有用 `LayoutBuilder`。
在 iPad 上題目卡片會撐滿整個寬度，橫式時一行文字跨越 1100pt，閱讀動線很差。

## 已確認的決策

| 問題 | 決定 |
|---|---|
| 版面方向 | **單欄但正確縮放**——保留現有導航結構，不做雙欄／分割版面 |
| 適用範圍 | **依寬度分三級，不看裝置**——iPad 分屏、macOS 拉視窗都會自動正確 |
| 實作方式 | **集中的 `LayoutSpec` 物件**，呼叫端讀語意代號 |
| 改造範圍 | **一次全換**（10 個頁面、42 處字級） |
| 驗收 | 三種寬度的 widget 測試 + **iPad 模擬器實機截圖** |

## 斷點

```
compact    < 600      iPhone、iPad 分屏窄端
medium   600 – 1000   iPad 直式、小視窗
expanded   > 1000     iPad 橫式、macOS
```

## 設計代號與三級數值

現有 13 種字級先歸納成 6 個語意角色，不原樣搬進去（那只是換個地方寫死）。

| 代號 | 現況 | compact | medium | expanded |
|---|---|---|---|---|
| `displayText` | 34 / 32 | 32 | 40 | 44 |
| `headingText` | 28 / 24 | 24 | 28 | 30 |
| `titleText` | 22 / 20 / 19 | 20 | 23 | 24 |
| `promptText` | 18（題幹） | 18 | 21 | 22 |
| `bodyText` | 15 / 14 | 15 | 17 | 18 |
| `captionText` | 13 / 12 / 11 | 13 | 14 | 15 |

版面代號：

| 代號 | compact | medium | expanded |
|---|---|---|---|
| `contentMaxWidth` | ∞ | 680 | 760 |
| `pagePadding` | 16 | 32 | 48 |
| `sectionGap` | 16 | 24 | 28 |
| `cardPadding` | 16 | 24 | 28 |
| `optionGap` | 8 | 12 | 14 |
| `minTapTarget` | 48 | 56 | 56 |

**`contentMaxWidth` 是「不是 iPhone 放大版」的主要來源。**限制在 680–760pt 並置中，
兩側自然留白，這是單欄版面在大螢幕上最重要的一件事。

`minTapTarget` 由 48 提到 56：iPad 通常擺桌面上用整隻手指點，
Apple HIG 對 iPad 的建議比 iPhone 大。

## 既有的 TextTheme（設計時漏看，2026-09-04 補正）

app **已經有一套 `TextTheme`**（`lib/main.dart:177-212`）：
`displaySmall` 32、`headlineSmall` 22、`titleLarge` 18、`bodyLarge` 15、
`bodyMedium` 13、`bodySmall` 11，部分畫面已經在用 `Theme.of(context).textTheme.*`。
那 42 處寫死的字級是**額外**散落在旁邊的。初次盤點只 grep 了 `fontSize:`，所以沒看到它。

**決定：讓 `TextTheme` 本身跟著寬度變，數值來自 `LayoutSpec`。**
字級因此只有一個來源，已經在用 theme 的畫面免費得到縮放。
語意代號直接對應既有的 Material 角色：

| LayoutSpec 代號 | 對應 TextTheme 角色 | compact | medium | expanded |
|---|---|---|---|---|
| `displayText` | `displaySmall` | 32 | 40 | 44 |
| `headingText` | `headlineSmall` | 22 | 26 | 28 |
| `titleText` | `titleLarge` | 18 | 21 | 22 |
| `bodyText` | `bodyLarge` | 15 | 17 | 18 |
| `captionText` | `bodyMedium` | 13 | 14 | 15 |
| `microText` | `bodySmall` | 11 | 12 | 13 |

compact 一欄刻意**與現況完全相同**，這樣 iPhone 的呈現一個像素都不會變，
改動的風險全部集中在 medium / expanded 兩級。

`promptText`（題幹，18/21/22）不放進 TextTheme——它是題目專用的語意，
不是通用角色，留在 `LayoutSpec` 上。

## 程式結構

`lib/ui/layout_spec.dart`：

```dart
enum WidthClass { compact, medium, expanded }

class LayoutSpec {
  final WidthClass widthClass;
  final double promptText;        // 題幹專用
  final double contentMaxWidth;   // …其餘版面代號

  /// 斷點的唯一真實來源
  factory LayoutSpec.forWidth(double width) => ...;

  static LayoutSpec of(BuildContext context) =>
      LayoutSpec.forWidth(MediaQuery.sizeOf(context).width);

  /// 依這一級的字級產生 TextTheme，交給 MaterialApp 套用
  TextTheme textThemeFrom(TextTheme base);
}
```

在 `MaterialApp.builder` 依當下寬度重建 `Theme`，讓 theme 呼叫端自動縮放。

**刻意不用 InheritedWidget。**`MediaQuery.sizeOf` 本身已經是 inherited，
再包一層只會多一個必須維護的同步點，而且 `sizeOf` 只在尺寸真的變動時才重建。

**`contentMaxWidth` 不散在各頁**，做成 `ContentColumn` widget
（內部 = `Center` + `ConstrainedBox` + `Padding`）。10 個頁面把最外層 body 包進去即可，
版面骨架只改一個地方，各頁只換字級代號——這是「一次全換」不會失控的原因。

現有三個臨時斷點（900、900、980）全部移除，避免同一支 app 有三套不一致的斷點。

## 已知風險

**釘死 TextTheme 數值的既有測試會紅**（`test/widget_test.dart:677-693`
斷言 `displaySmall == 32` 等六個角色 + 兩個按鈕字級）。
那條測試跑在預設 surface size，改成依寬度斷言即可——這是預期中的更新，不是回歸。
另外既有測試已經用 `setSurfaceSize(1200, 1600)`（expanded）與 `(430, 932)`（compact）
兩種尺寸，換值後要確認這些測試仍過。


`_QuestionOptionText`（`lib/main.dart:4324`）已自己做了 `width >= 900 ? 20 : 18`。
換掉時要確認**選項字級與題幹的相對關係**維持（選項略小於題幹），
不能只是各自套代號了事。

## 測試策略

三層，各擋不同的東西。

1. **`LayoutSpec` 單元測試**——斷點邊界逐一釘死（599/600/999/1000/1001）；
   同一代號在三級之間必須遞增（擋住「調值時讓 iPad 比 iPhone 還小」）；
   compact 的 `contentMaxWidth` 必須無限大。
2. **三種寬度 pump 每個頁面**——390 / 820 / 1180 × 10 頁。斷言
   `tester.takeException()` 為 null（Flutter 在 debug 期對 overflow 丟例外，
   這是唯一自動抓得到「版面爆掉」的手段）與該頁讀到正確的 `WidthClass`。
3. **iPad 模擬器實機截圖**——直式與橫式各跑一次，10 個頁面貼給使用者目視。
   測試抓得到「爆版」，抓不到「醜」，這一層才是真正驗收的地方。

順序：先寫第 1 層（TDD，`LayoutSpec` 還不存在，測試會紅）→ 實作 →
逐頁換、每換完一頁跑第 2 層 → 最後開模擬器。
