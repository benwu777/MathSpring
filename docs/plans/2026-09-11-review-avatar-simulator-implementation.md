# 審題介面紙娃娃模擬分頁 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 在既有「複習」審題介面新增不會寫入帳號資料的紙娃娃模擬分頁，完整重用 App 的選擇操作與即時完整臉部預覽。

**Architecture:** `_ReviewTab` 改為內部分頁容器，保留既有學習複習內容，另加入紙娃娃模擬頁。模擬頁直接建立 `AvatarEditor`，不傳入 `onChanged`、不讀取 learner、也不呼叫 `AppServices`，因此狀態只存在於頁面生命週期，離開複習頁即清除。`AvatarEditor` 與 `AvatarPreview` 維持唯一實作來源，確保 App 與審題工具使用完全相同的素材清單、圖層及操作。

**Tech Stack:** Flutter、Material 3、flutter_test、現有 `AvatarEditor`／`AvatarPreview`。

### Task 1: 先為複習分頁與暫時紙娃娃狀態建立失敗測試

**Files:**
- Modify: `test/widget_test.dart`
- Reference: `lib/main.dart:883-894`, `lib/widgets/avatar_editor.dart:7-214`

**Step 1: Write the failing test**

在 `widget_test.dart` 新增一個英文 locale 的 widget test：

```dart
testWidgets('review offers a temporary avatar simulator', (tester) async {
  await pumpApp(tester, createTestServices());
  await tester.tap(find.text('Review').first);
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const ValueKey<String>('review_avatar_tab')));
  await tester.pumpAndSettle();

  expect(find.byKey(const ValueKey<String>('review_avatar_simulator')),
      findsOneWidget);
  expect(find.byType(AvatarEditor), findsOneWidget);
  expect(find.byType(AvatarPreview), findsOneWidget);
  expect(find.byKey(const ValueKey<String>('avatar_presentation_girl')),
      findsOneWidget);
});
```

再新增一個測試，切換到男生、離開 Review 底部導覽、回到模擬器後，確認預設女生選項仍存在，證明不會寫入帳號或服務。

**Step 2: Run test to verify it fails**

Run: `flutter test test/widget_test.dart --plain-name "review offers a temporary avatar simulator"`

Expected: FAIL，找不到 `review_avatar_tab`。

**Step 3: Commit the red test**

```bash
git add test/widget_test.dart
git commit -m "test: specify temporary avatar simulator in review"
```

### Task 2: 建立複習內部分頁與模擬器畫面

**Files:**
- Modify: `lib/main.dart:883-894`
- Modify: `lib/main.dart` 中 `AppStrings` 的既有多語系字串區塊
- Test: `test/widget_test.dart`

**Step 1: Add localized labels**

在 `AppStrings` 加入下列 getter，並為繁中、簡中、英文、日文提供翻譯：

- `reviewLearningTab`：學習複習／学习复习／Learning review／学習の振り返り
- `reviewAvatarSimulatorTab`：紙娃娃模擬／纸娃娃模拟／Avatar simulator／アバターシミュレーター
- `reviewAvatarSimulatorTitle`：紙娃娃素材檢視／纸娃娃素材检视／Avatar material check／アバター素材の確認
- `reviewAvatarSimulatorSubtitle`：暫時操作，不會變更任何帳號設定／临时操作，不会变更任何账号设置／Changes here are temporary and do not affect learner profiles.／ここでの操作は一時的で、アカウント設定には影響しません。

**Step 2: Implement the minimal tab container**

將 `_ReviewTab` 改為 `DefaultTabController(length: 2)`：

- `TabBar` 使用 `ValueKey<String>('review_learning_tab')` 與 `ValueKey<String>('review_avatar_tab')`。
- `TabBarView` 第一頁仍是 `_LearningReviewSection(services: services)`，不改既有日曆與答題紀錄行為。
- 第二頁新增私有 `_ReviewAvatarSimulator`；以 `ContentScrollView`／現有內容欄樣式包住 `_SectionCard`，卡片 key 為 `review_avatar_simulator`。
- 卡片放標題、說明和 `const AvatarEditor()`；不傳 `initialConfiguration` 或 `onChanged`，也不接觸 `services`。

**Step 3: Run the focused tests**

Run: `flutter test test/widget_test.dart --plain-name "review offers a temporary avatar simulator"`

Expected: PASS。

Run: `flutter test test/widget_test.dart --plain-name "review avatar simulator resets after leaving review"`

Expected: PASS。

**Step 4: Commit the feature**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "feat: add temporary avatar simulator to review"
```

### Task 3: 保護既有複習頁與紙娃娃操作的可用性

**Files:**
- Modify: `test/widget_test.dart`
- Reference: `test/avatar_editor_test.dart`

**Step 1: Write/extend regression assertions**

在模擬分頁的測試加入下列操作：

```dart
await tester.tap(find.byKey(const ValueKey<String>('avatar_presentation_boy')));
await tester.tap(find.byKey(const ValueKey<String>('avatar_section_tab_3')));
await tester.pump();
expect(find.byKey(const ValueKey<String>('avatar_option_boy_hair_01')),
    findsOneWidget);
expect(find.byType(AvatarPreview), findsOneWidget);
```

另確認切回 `review_learning_tab` 後，既有 `reviewTitle` 內容與查看紀錄按鈕仍可見。

**Step 2: Run tests to verify the expected failure before any necessary fix**

Run: `flutter test test/widget_test.dart --plain-name "review avatar simulator uses the shared editor"`

Expected: 若尚未補齊 key 或版面，FAIL；補正後進入下一步。

**Step 3: Apply the smallest UI fix if needed**

只調整 `_ReviewAvatarSimulator` 的捲動／寬度限制，確保 `AvatarEditor` 在桌面與窄視窗都完整可操作；不得複製、分叉或修改 `AvatarEditor` 的選項邏輯。

**Step 4: Run all relevant tests**

Run:

```bash
flutter test test/widget_test.dart test/avatar_editor_test.dart test/avatar_preview_test.dart
flutter analyze
```

Expected: 所有測試及靜態分析通過。

**Step 5: Commit regression coverage**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "test: cover review avatar simulator interactions"
```

### Task 4: 桌面人工驗收

**Files:**
- No production file changes required unless Task 3 finds a layout defect.

**Step 1: Run macOS build**

Run: `flutter build macos --debug`

Expected: build succeeds.

**Step 2: Launch and inspect**

在 macOS 審題介面切到「複習 → 紙娃娃模擬」，分別操作男女、臉型、髮型、眼睛（含三種眼鏡）、膚色。確認完整臉即時重組，且不會回寫既有帳號。

**Step 3: Capture review screenshots**

保留一張女生、男生各自搭配 `face_01 + hair_01` 的完整合成截圖，並在人工作業結果中說明所有素材仍經由共享 `AvatarEditor` 渲染。

**Step 4: Final verification**

Run: `git diff --check && git status --short`

Expected: 無空白錯誤；只含本功能預期的檔案。
