import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('public support and privacy references use production details', () {
    final Map<String, String> files = <String, String>{
      'lib/main.dart': File('lib/main.dart').readAsStringSync(),
      'docs/site/index.html': File('docs/site/index.html').readAsStringSync(),
      'docs/site/support/index.html':
          File('docs/site/support/index.html').readAsStringSync(),
      'docs/site/privacy/index.html':
          File('docs/site/privacy/index.html').readAsStringSync(),
      'docs/app-store-metadata-en.md':
          File('docs/app-store-metadata-en.md').readAsStringSync(),
      'docs/app-store-metadata-zh-Hant.md':
          File('docs/app-store-metadata-zh-Hant.md').readAsStringSync(),
    };
    final String allText = files.values.join('\n');

    expect(
      allText,
      contains('https://benwu777.github.io/MathSpring/support/'),
    );
    expect(
      allText,
      contains('https://benwu777.github.io/MathSpring/privacy/'),
    );
    expect(allText, contains('hidesor@yahoo.com.tw'));
    expect(allText, contains('繁體中文'));
    expect(allText, contains('簡體中文'));
    expect(allText, contains('English'));
    expect(allText, contains('日本語'));
    expect(allText, isNot(contains('YOUR_GITHUB_USERNAME')));
    expect(allText, isNot(contains('support@example.com')));
  });

  test('GitHub Pages workflow deploys the static site directory', () {
    final File workflowFile = File('.github/workflows/deploy-pages.yml');
    expect(workflowFile.existsSync(), isTrue);
    if (!workflowFile.existsSync()) {
      return;
    }
    final String workflow = workflowFile.readAsStringSync();

    expect(workflow, contains('actions/configure-pages@v5'));
    expect(workflow, contains('actions/upload-pages-artifact@v3'));
    expect(workflow, contains('path: docs/site'));
    expect(workflow, contains('actions/deploy-pages@v4'));
  });

  test('full unlock only describes benefits available in the first release', () {
    final String purchaseCopy = <String>[
      File('lib/main.dart').readAsStringSync(),
      File('ios/Runner/Products.storekit').readAsStringSync(),
    ].join('\n');

    expect(purchaseCopy, isNot(contains('無廣告')));
    expect(purchaseCopy, isNot(contains('无广告')));
    expect(purchaseCopy, isNot(contains('ad-free')));
    expect(purchaseCopy, isNot(contains('広告なし')));
    expect(purchaseCopy, isNot(contains('移除廣告')));
    expect(purchaseCopy, contains('完整詳解'));
    expect(purchaseCopy, contains('avatar styles'));
    expect(purchaseCopy, contains('five learner'));
  });
}
