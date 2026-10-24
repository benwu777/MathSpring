# Release Privacy Manifest Verification

最後驗證：2026-10-24。此紀錄以未簽署的 iOS release artifact 為證；更新 Flutter、iOS plugin 或任何隱私相關程式後，必須重新執行。

## 驗證方式

```sh
flutter build ios --release --no-codesign
find build/ios/iphoneos/Runner.app -name PrivacyInfo.xcprivacy -print
```

檢查的 bundle 是 `build/ios/iphoneos/Runner.app`。最終送審前，仍要對實際上傳的已簽署 archive 重跑，並檢查 Xcode Organizer／App Store Connect 的 Privacy Report。

| Bundle | Manifest | Collected data | Tracking | Required Reason APIs |
| --- | --- | --- | --- | --- |
| App target (`Runner.app`) | 無 app 自有 manifest | 無 app 自有宣告 | 無 app 自有宣告 | app source review 未發現；若新增原生程式再檢查。 |
| `Flutter.framework` | 有 | 無 | 否 | File timestamp：`0A2A.1`、`C617.1`；system boot time：`35F9.1`。 |
| `in_app_purchase_storekit` | 有 | 無 | 否 | 無。 |
| `sqflite_darwin` | 有 | 無 | 否 | 無。 |
| `url_launcher_ios` | 有 | 無 | 否 | 無。 |

## App Store Connect 宣告

目前的 source review 顯示學習者設定、答題歷史與學習進度存於本機 SQLite；未發現帳號、分析、廣告、tracking、雲端同步或開發者伺服器資料傳輸。待確認最終已簽署 archive 和所有正式 SDK 後，App Privacy 可選擇「不從此 App 收集資料」。

StoreKit 的付款處理由 Apple 處理。除非未來程式或服務實際接收付款卡資料，不要把付款卡資料申報為開發者收集。

## 送審前仍須完成

- 對送審用已簽署 archive 重跑本檢查。
- 檢閱 Xcode Organizer／App Store Connect upload warning 與最終 Privacy Report。
- 依賴套件變動後重新驗證。
- 只有 app 自有 iOS 程式使用 Required Reason API 或收集需申報資料時，才新增 `ios/Runner/PrivacyInfo.xcprivacy`；並使用與功能相符的 Apple 核准原因。
