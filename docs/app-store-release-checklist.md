# MathSpring App Store 送審差距清單

最後盤點：2026-10-24。範圍為 iPhone／iPad 首次公開上架；勾選表示已由目前 repository 靜態確認，並不取代真機、Sandbox 或 App Store Connect 驗收。

## 送審阻擋項（先處理）

- [x] **發布支援頁與隱私政策頁。** 已以 GitHub Pages 從 `main` 部署；2026-10-24 已驗證 `https://benwu777.github.io/MathSpring/support/` 及 `/privacy/` 均回傳 HTTP 200。
- [ ] **統一一次性解鎖的宣稱。** 首發沒有廣告，但 UI 仍把「無廣告／ad-free」當作付費解鎖內容；這和隱私頁、App Store metadata 及產品政策不一致。改為只宣稱「完整詳解、完整紙娃娃樣式、最多五位學習者」，並確認沒有任何商店素材保留移除廣告的說法。
- [ ] **取得每一題、圖片與素材的可商業發布權利。** 題庫含 AMC、AIME、IMC 等競賽來源。公開可查閱或附來源連結不等於可重製、翻譯、改寫或商業散布；逐來源保存授權、適用條款或以自製／已取得授權的題目替換。App Store Connect 的 Content Rights 聲明只能在此項完成後據實勾選。
- [ ] **建立正式 IAP。** 在 App Store Connect 建立 non-consumable 產品 `com.benwu.mathspring.full_unlock`，名稱、描述與顯示內容須和 App 一致，並將它附加到首個版本送審。`ios/Runner/Products.storekit` 只是本機 StoreKit 測試設定，不會建立商店商品。
- [ ] **完成付費合約與收款設定。** Account Holder 在 Tax and Banking 同意最新 Paid Apps Agreement、填妥稅務與銀行資料；否則不能上架付費內容或 IAP。

## 已確認的 App／程式狀態

- [x] iOS Bundle ID：`com.benwu.mathspring`。
- [x] 最低 iOS 版本：15.0；版本／build 來自 Flutter `1.0.0+1`。每次上傳 App Store Connect 都要遞增 build number。
- [x] 含完整 1024×1024 App Icon 及各 iPhone／iPad 尺寸。
- [x] 目前沒有登入、帳號、伺服器同步、分析 SDK、廣告 SDK 或遠端 API 的程式證據；學習者與答題記錄使用本機 SQLite。
- [x] App 內已有支援與隱私政策入口；連結要在公開網址修好後以實機驗證。
- [x] 使用 StoreKit 的非消耗型內購流程，且可見「回復購買」入口。
- [ ] 原始碼沒有 app 自有的 `PrivacyInfo.xcprivacy`。先以 Release archive 的 Privacy Report 檢查 app 與全部 plugin（Flutter、sqflite、url_launcher、in_app_purchase）是否已正確帶入 privacy manifest；若本身或 SDK 使用 Required Reason API，補上正確宣告後再上傳。

## 程式與產品驗收

- [x] 執行 `flutter analyze`，結果為 0 issues（2026-10-24）。
- [x] 執行完整 `flutter test`，371 passed、1 skipped（2026-10-24）。
- [ ] 執行 `flutter build ipa --release`（具備簽署後），確認 archive 可被 Xcode Organizer／Transporter 驗證並上傳。
- [ ] 在至少一台實體 iPhone、iPhone Simulator、iPad Simulator 完成 QA：首次啟動、離線題庫、四語系、建立／切換／刪除學習者、練習／測驗／歷史紀錄、所有圖形題、直橫向、Dynamic Type、VoiceOver。
- [ ] 以 Sandbox 測試購買、取消、購買失敗、重新開啟後 restore，以及不同 Apple ID 的恢復行為；交易完成後確實解鎖且不重複扣款。
- [ ] 檢查題目、圖形、答案、詳解與所有外連來源在實機皆正確；移除 placeholder、測試內容與不能操作的入口。
- [ ] 以 release archive 實測 App 內的支援／隱私連結、離線行為與 IAP；審查期間不依賴尚未開啟的服務。

## 隱私、年齡與法務

- [ ] 在 App Store Connect 填 App Privacy。若 Release archive 與實機流量確認只有裝置本機資料、沒有 app／第三方收集或 tracking，選擇「不從此 App 收集資料」；切勿把 Apple IAP 本身誤報成開發者收集卡號。
- [ ] 填入已公開且可存取的 Privacy Policy URL；政策、App Privacy 與實際程式行為必須一致。日後新增登入、雲端、通知、分析、廣告或 SDK 前，先重做此盤點。
- [ ] 完成年齡分級問卷；目前預期為教育 app、有一次性購買、無使用者互動／廣告／網路內容。依最終題庫與功能據實回答；不選 Kids Category，除非願意持續遵守其額外規範。
- [ ] 若日後加入帳號建立，必須在 App 內提供啟動「永久刪除帳號與個資」的流程；目前無帳號，因此不適用。
- [ ] 若日後加入第三方登入，確認是否必須提供 Sign in with Apple；若加入通知、相機、相簿、麥克風或定位，才加入對應用途文案與最小化請求時機。

## App Store Connect 與商店頁

- [ ] 加入 Apple Developer Program；若以公司名義申請，先準備法人資料與 D-U-N-S Number。
- [ ] 在 Certificates, Identifiers & Profiles 登錄 App ID `com.benwu.mathspring`，設定正確 Team、Distribution certificate 與 App Store provisioning profile。
- [ ] 建立 App Store Connect app record：名稱 MathSpring、SKU、主要語言、Bundle ID、Education 類別、內容權利、版權資訊與可聯絡的 review contact。
- [ ] 完成繁中、英文產品頁：名稱／副標題（各最多 30 字元）、描述、關鍵字、版本更新內容、Support URL、Privacy Policy URL。只有最終支援的語言才上架對應在地化內容。
- [ ] 以實機畫面準備 iPhone 與 iPad screenshots（每種必要顯示尺寸至少一張）；必須展示實際核心流程，不可用 splash、mockup 或尚未實作的功能。
- [ ] 設定免費下載、可販售國家／地區、公開發行與發布方式；確認價格與稅務設定。

## 提交前與審查資訊

- [ ] 上傳新 build，等待處理完成，回答 Export Compliance／加密問題，並確認 build 狀態可送審。
- [ ] 至少完成 TestFlight internal testing；如需外部測試，先過 TestFlight App Review。
- [ ] 在 App Review Notes 說明：無登入、內建題庫可離線使用、只有一個非消耗型 IAP、測試購買方式，以及支援／隱私連結。若最終版本與此不同，按實際行為重寫。
- [ ] 選取 build、附加 IAP、確認 metadata／年齡分級／App Privacy／所有 URL 完整後 Submit for Review。
- [ ] 通過後選擇自動發布或手動發布；保存 Apple 的核准與拒絕訊息，拒絕時在 Resolution Center 提供具體重現步驟與修正內容。

## 送審用資料夾與關聯檔案

- 商店文案草稿：`docs/app-store-metadata-zh-Hant.md`、`docs/app-store-metadata-en.md`
- 實機 QA 範圍：`docs/ios-release-qa.md`
- 支援／隱私靜態網站：`docs/site/`
- IAP 本機測試商品：`ios/Runner/Products.storekit`

## 官方依據

- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Manage App Privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy)
- [Upload builds](https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds)
- [Required Reason APIs](https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api)
- [Provide information for App Review](https://developer.apple.com/help/app-review/before-submitting-for-review/complete-review)
