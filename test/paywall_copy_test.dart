import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';

void main() {
  // App 本來就沒有廣告，付費說明不能把「無廣告」當成購買後才有的好處。
  test('full unlock copy never sells ad-free as a benefit', () {
    for (final Locale locale in AppStrings.supportedLocales) {
      final AppStrings strings = AppStrings(locale);
      for (final String copy in <String>[
        strings.fullUnlockSubtitle,
        strings.fullUnlockUnlockedSubtitle,
        strings.fullUnlockDescription,
      ]) {
        expect(copy, isNot(matches(RegExp(r'廣告|广告|広告|[Aa]d-free|\bads?\b'))),
            reason: '$locale: $copy');
      }
    }
  });

  test('StoreKit full unlock copy never sells ad-free as a benefit', () {
    final String storeKit =
        File('ios/Runner/Products.storekit').readAsStringSync();

    expect(storeKit,
        isNot(matches(RegExp(r'移除廣告|無廣告|无广告|広告なし|[Aa]d-free'))));
  });

  // 免費版每天也看得到 3 題詳解，付費的差別是「全部」而不是「有沒有詳解」。
  test('full unlock copy sells every solution, not solutions at all', () {
    expect(AppStrings(const Locale('en')).fullUnlockDescription,
        contains('every solution'));
    expect(AppStrings(const Locale('zh', 'TW')).fullUnlockDescription,
        contains('全部詳解'));
  });
}
