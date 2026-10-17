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
}
