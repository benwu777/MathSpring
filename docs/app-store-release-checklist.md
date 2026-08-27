# MathSpring App Store 送審與發布清單

最後更新：2026-08-27。

## 現階段原則

尚未加入 Apple Developer Program 不會阻塞產品開發。等到真機 QA、商店素材與隱私頁完成後，再申請帳號並執行簽署、TestFlight、送審。

## 發布驗收（必須全部完成）

- [ ] `flutter analyze` 為 0 issues。
- [ ] `flutter test` 全數通過。
- [ ] `flutter build ios --no-codesign` 成功。
- [ ] 完成 [iPhone／iPad 發布前 QA](ios-release-qa.md) 的必測流程。
- [ ] App 內的支援與隱私入口可開啟公開網址。
- [ ] 支援頁、隱私頁、App Store Connect 的 App Privacy 與 app 實際行為一致。
- [ ] 截圖均為實際 app 畫面，且繁中、英文 metadata 已完成校對。

## 開發完成前

- [ ] 以正式資料取代 Bundle ID、顯示名稱、copyright 與所有 placeholder。
- [ ] 建立公開、免登入可開啟的支援網址與隱私政策網址；GitHub Pages 不需要自建 server。
- [ ] 清除測試用內容與無法使用的入口。
- [ ] 完成 iPhone、iPad 與 macOS 的真機 QA：首次開啟、題庫載入、四語系、答題、作答紀錄、離線狀態、旋轉與字級。
- [ ] 針對所有使用者看得到的題目做最後內容抽查；確認題目、圖形、答案、選項與解法一致。

## 建立 Apple 發布身分後

- [ ] 加入 Apple Developer Program，並在 Developer portal 註冊正式 App ID。
- [ ] 在 Xcode 設定 Team、Signing Certificate、Provisioning Profile 與正式 Bundle ID。
- [ ] 在 App Store Connect 建立 app record：名稱、SKU、Bundle ID、主要語言、分類、年齡分級與內容權利。
- [ ] 設定版本與 build number；每次上傳都必須提高 build number。
- [ ] 先經 TestFlight 內部測試，再提交 App Review。

## 隱私與法務

- [ ] 在 App Store Connect 提供 Privacy Policy URL，並填寫 App Privacy。
- [ ] 隱私政策須說明資料收集、用途、保存／刪除、聯絡方式與資料請求方式。
- [ ] 若未來加入登入、雲端同步、分析、廣告、付款、家長帳號或第三方 SDK，先更新隱私政策與 App Privacy。
- [ ] 若選擇 Kids Category，確認家長門檻、外連、購買與第三方分析／廣告均符合其額外規則。

## 商店素材

- [ ] 準備 1024×1024 正式 App Icon，確認沒有透明背景與未授權素材。
- [ ] 撰寫名稱（30 字元內）、subtitle（30 字元內）、描述、關鍵字、支援 URL、隱私政策 URL、版權與 What’s New。
- [ ] 準備每個裝置類型的實機截圖，展示實際使用流程而不是 title／splash screen。

## 參考資料

- [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Manage app privacy](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/)
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
