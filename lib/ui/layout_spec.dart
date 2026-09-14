import 'package:flutter/material.dart';

/// 畫面寬度的三個級別。
///
/// 刻意**依寬度而非裝置**分級：iPad 分屏成 1/3 寬時該用 compact 的值，
/// macOS 把視窗拉窄時也是。用 `Platform.isIOS` 之類的判斷會在這兩種情況下出錯。
enum WidthClass {
  /// < 600：iPhone、iPad 分屏窄端
  compact,

  /// 600 – 1000：iPad 直式、小視窗
  medium,

  /// > 1000：iPad 橫式、macOS
  expanded,
}

/// 一個寬度級別對應的所有版面與字級數值。
///
/// 設計文件見 `docs/plans/2026-09-04-ipad-layout-design.md`。
/// 調值只改這個檔；斷點只有 [forWidth] 一個真實來源。
@immutable
class LayoutSpec {
  const LayoutSpec({
    required this.widthClass,
    required this.displayText,
    required this.headingText,
    required this.titleText,
    required this.promptText,
    required this.bodyText,
    required this.captionText,
    required this.microText,
    required this.contentMaxWidth,
    required this.pagePadding,
    required this.sectionGap,
    required this.cardPadding,
    required this.optionGap,
    required this.minTapTarget,
  });

  final WidthClass widthClass;

  // --- 字級：前六個會餵進 TextTheme，promptText 是題目專用 ---
  final double displayText; // TextTheme.displaySmall
  final double headingText; // TextTheme.headlineSmall
  final double titleText; // TextTheme.titleLarge
  final double bodyText; // TextTheme.bodyLarge
  final double captionText; // TextTheme.bodyMedium
  final double microText; // TextTheme.bodySmall

  /// 題幹專用。它是題目的語意而不是通用角色，所以不放進 TextTheme。
  final double promptText;

  // --- 版面 ---

  /// 內容欄的最大寬度。**這是「不是 iPhone 放大版」的主要來源**——
  /// 不限制的話，iPad 橫式上一行文字會跨越 1100pt，閱讀動線很差。
  /// compact 為無限大：手機上加側邊留白只會讓本來就窄的畫面更窄。
  final double contentMaxWidth;

  final double pagePadding;
  final double sectionGap;
  final double cardPadding;
  final double optionGap;

  /// 最小觸控目標。iPad 通常擺在桌面上用整隻手指點，
  /// Apple HIG 對 iPad 的建議比 iPhone 大，所以 medium 以上提到 56。
  final double minTapTarget;

  /// compact 的字級與 2026-09-04 改造前的既有值完全相同，
  /// 讓 iPhone 的呈現一個像素都不變，改動風險全部集中在 medium / expanded。
  static const LayoutSpec _compact = LayoutSpec(
    widthClass: WidthClass.compact,
    displayText: 32,
    headingText: 22,
    titleText: 18,
    promptText: 18,
    bodyText: 15,
    captionText: 13,
    microText: 11,
    contentMaxWidth: double.infinity,
    pagePadding: 16,
    sectionGap: 12,
    cardPadding: 16,
    optionGap: 8,
    minTapTarget: 48,
  );

  static const LayoutSpec _medium = LayoutSpec(
    widthClass: WidthClass.medium,
    displayText: 40,
    headingText: 26,
    titleText: 21,
    promptText: 21,
    bodyText: 17,
    captionText: 14,
    microText: 12,
    contentMaxWidth: 680,
    pagePadding: 32,
    sectionGap: 24,
    cardPadding: 24,
    optionGap: 12,
    minTapTarget: 56,
  );

  static const LayoutSpec _expanded = LayoutSpec(
    widthClass: WidthClass.expanded,
    displayText: 44,
    headingText: 28,
    titleText: 22,
    promptText: 22,
    bodyText: 18,
    captionText: 15,
    microText: 13,
    contentMaxWidth: 760,
    pagePadding: 48,
    sectionGap: 28,
    cardPadding: 28,
    optionGap: 14,
    minTapTarget: 56,
  );

  /// 斷點的唯一真實來源。
  factory LayoutSpec.forWidth(double width) {
    if (width < 600) return _compact;
    if (width < 1000) return _medium;
    return _expanded;
  }

  static LayoutSpec of(BuildContext context) =>
      LayoutSpec.forWidth(MediaQuery.sizeOf(context).width);

  /// 六個語意代號涵蓋不到的零散字級用這個縮放。
  ///
  /// 為什麼需要它：既有程式裡有 40 處直接寫死的 `fontSize`，數值有 13 種
  /// （11、12、13、14、15、18、19、20、22、24、28、32、34）。硬要把它們全部
  /// 塞進六個代號，會讓 compact 的呈現跟著變（例如 20 被歸成 titleText 就變成 18），
  /// 而「iPhone 一個像素都不變」是這次改造的前提。
  ///
  /// 所以：**能對上代號的用代號，對不上的用這個函式**。
  /// compact 原樣回傳，medium / expanded 依固定比例放大後取整數點數。
  double scaleText(double compactSize) {
    if (widthClass == WidthClass.compact) return compactSize;
    final double medium = (compactSize * 1.15).roundToDouble();
    if (widthClass == WidthClass.medium) return medium;
    // 小字級四捨五入後兩級會相同（11 × 1.15 與 11 × 1.22 都進位到 13），
    // 所以 expanded 至少比 medium 大 1，維持嚴格遞增。
    final double expanded = (compactSize * 1.22).roundToDouble();
    return expanded > medium ? expanded : medium + 1;
  }

  /// 把這一級的字級套進既有的 [base]，其餘視覺屬性（字重、行高、顏色）保持不動。
  TextTheme textThemeFrom(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(fontSize: displayText),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: headingText),
      titleLarge: base.titleLarge?.copyWith(fontSize: titleText),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: bodyText),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: captionText),
      bodySmall: base.bodySmall?.copyWith(fontSize: microText),
    );
  }
}
