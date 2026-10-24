# MathSpring App Store 送審與發布清單

最後更新：2026-10-24。

## 現階段原則

尚未加入 Apple Developer Program 不會阻塞產品開發。等到真機 QA、商店素材與隱私頁完成後，再申請帳號並執行簽署、TestFlight、送審。

**變現方式已定稿**：免費層可作答全部題目並顯示答案，每天可自選 3 題看完整詳解；付費 NT$60（US$1.99）
一次性解鎖全部詳解、紙娃娃全套樣式與 5 個角色（app 沒有廣告，App Store Connect 的購買項目說明也不要寫「無廣告」）；分類 Education、
年齡分級 4+、**不進 Kids Category**。完整設計見
`docs/plans/2026-09-10-freemium-monetization-design.md`，接入步驟見 `docs/monetization-handoff.md`。

**待辦功能**：每日練習提醒（本地通知，不需伺服器）尚未實作，
可行性與實作注意事項見 `docs/daily-reminder-handoff.md`。若實作，送審前需確認
符合審查指南 4.5.4，並更新 App Privacy 中的通知相關敘述。

## 發布驗收（必須全部完成）

- [x] `flutter analyze` 為 0 issues（2026-10-25；每次送審候選 build 都要重跑）。
- [x] `flutter test` 全數通過（2026-10-25；每次送審候選 build 都要重跑）。
- [ ] 完成 [iPhone／iPad 發布前 QA](ios-release-qa.md) 的必測流程。
- [x] 支援頁與隱私政策已公開：<https://benwu777.github.io/MathSpring/support/>、<https://benwu777.github.io/MathSpring/privacy/> 在 2026-10-24 回傳 HTTP 200。
- [ ] 以 release archive 在實機驗證 App 內的支援與隱私入口可開啟上述公開網址。
- [ ] 支援頁、隱私頁、App Store Connect 的 App Privacy 與 app 實際行為一致。
- [ ] 截圖均為實際 app 畫面，且繁中、英文 metadata 已完成校對。

## 開發完成前

- [x] iOS 正式 Bundle ID 為 `com.benwu.mathspring`。
- [ ] 將 app 顯示名稱、macOS copyright 與品牌文字改為正式資料。
- [ ] 在 app 內提供易於找到的「隱私政策」與「支援」頁面或外部連結。
- [x] 已建立公開、免登入可開啟的支援與隱私網址（GitHub Pages）。
- [ ] 完成 iPhone、iPad 與 macOS 的真機 QA：首次開啟、題庫載入、四語系、答題、作答紀錄、離線狀態、旋轉與字級。
- [ ] 針對所有使用者看得到的題目做最後內容抽查；確認題目、圖形、答案、選項與解法一致。
- [ ] 清除 placeholder、測試用內容與無法使用的入口。
- [ ] 處理 `flutter analyze` 的 warning／info，至少優先處理 async 後使用 `BuildContext`、未使用元件與 private type 暴露。

## 建立 Apple 發布身分後

- [ ] 加入 Apple Developer Program。
- [ ] 在 Apple Developer portal 註冊正式 App ID。
- [ ] 在 Xcode 設定 Team、Signing Certificate、Provisioning Profile 與正式 Bundle ID。
- [ ] 在 App Store Connect 建立 app record：名稱、SKU、Bundle ID、主要語言、分類、年齡分級與內容權利。
- [ ] 設定版本與 build number；目前專案版本為 `1.0.0+1`，每次上傳都必須提高 build number。
- [ ] 先經 TestFlight 內部測試，再提交 App Review。

## 隱私與法務

- [ ] 在 App Store Connect 提供 Privacy Policy URL；Apple 對 iOS/macOS app 要求此 URL。
- [ ] 填寫 App Privacy。若正式版本僅使用本機 SQLite、沒有帳號、分析、廣告或資料上傳，可在確認所有 SDK 行為後選擇「不收集資料」。
- [ ] 隱私政策需說明：收集哪些資料（若無也要明示）、用途、保存／刪除政策、聯絡方式，以及使用者如何撤回同意或要求刪除資料。
- [ ] 若未來加入登入、雲端同步、分析、廣告、付款、家長帳號或第三方 SDK，先更新隱私政策與 App Privacy，再發布。
- [ ] 若選擇 Kids Category，確認家長門檻、外連、購買與第三方分析／廣告均符合 Kids Category 的額外規則。

## 商店素材

- [ ] 準備 1024×1024 正式 App Icon，確認沒有透明背景與未授權素材。
- [ ] 撰寫名稱（30 字元內）、subtitle（30 字元內）、描述、關鍵字、支援 URL、隱私政策 URL、版權與 What’s New。
- [ ] 準備實機截圖：每個平台至少 1 張、最多 10 張，內容須展示實際使用流程而不是單純 title／splash screen。
- [ ] 依主要市場準備繁中與英文 metadata；若上架日文／簡中市場，再補對應在地化素材。

## 測試與送審

- [ ] 用 Xcode Archive 或 `flutter build ipa` 建立 Release build。
- [ ] 上傳至 App Store Connect，等待 build 處理完成。
- [ ] 先經 TestFlight 內部測試；再視需要邀請外部測試者。
- [ ] 在 Review Notes 說明：app 使用離線內建題庫、是否無需帳號、是否無付款，以及任何非直覺流程。
- [ ] 若 app 有帳號、付費或後端，提供可用 demo 帳號／測試資料並確保服務在審核期間可用。
- [ ] 提交 App Review，通過後選擇手動或自動發布。

## 目前優先順序

1. 產品與真機品質：完成真機 QA、修正分析問題、整理使用者流程與內容品質。
2. 對外頁面：支援頁與隱私政策頁。
3. 商店準備：icon 視覺 QA、截圖、名稱／描述與分類。
4. 帳號與發布：加入 Developer Program、簽署、TestFlight、送審。

## 參考資料

- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/)
- [Required app information](https://developer.apple.com/help/app-store-connect/reference/app-information/required-localizable-and-editable-properties)
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
