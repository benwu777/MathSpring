import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// 把 integration_test 裡 `binding.takeScreenshot(name)` 拍的圖存成 PNG。
/// 存放位置用環境變數 SCREENSHOT_DIR 指定（預設 build/screenshots）。
Future<void> main() async {
  final String dir =
      Platform.environment['SCREENSHOT_DIR'] ?? 'build/screenshots';
  await integrationDriver(
    onScreenshot: (String name, List<int> bytes,
        [Map<String, Object?>? args]) async {
      final File file = File('$dir/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
