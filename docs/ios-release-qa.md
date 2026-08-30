# iPhone／iPad 發布前 QA

## 範圍與裝置

- 首發平台：iPhone 與 iPad。
- 每次 release 至少在一台 iPhone Simulator、一台 iPad Simulator 與一台實體 iPhone 測試。
- 測試最新可用 iOS，以及專案宣告支援的最低 iOS 版本。

## 必測流程

- 首次啟動：無 crash、首頁可操作、預設語系正確。
- 學習者：建立、切換、編輯、刪除與資料保留。
- 題庫：年級、主題、題型、圖片／圖形題均可載入。
- 作答：選擇題、整數輸入、送出、錯誤回饋、解法與下一題。
- 紀錄：練習與測驗紀錄可正確保存、重新啟動後仍存在。
- 離線：關閉網路後，內建題庫、作答與歷史紀錄可正常使用。
- 在地化：繁中與英文；語系切換後題幹、操作文字與版面均正確。
- 輔助使用：Dynamic Type 放大、VoiceOver 基本焦點順序、按鈕可辨識。
- 版面：iPhone 直向、iPhone 橫向與 iPad 直／橫向不裁切、不重疊。

## Release 驗收門檻

- `flutter analyze` 為 0 issues。
- `flutter test` 全數通過。
- `flutter build ios --no-codesign` 成功。
- 所有 App Store 截圖來自實際 App 畫面。
- 支援與隱私頁可公開開啟；App 內入口可正常連結。
- App Store Connect 的 privacy、年齡分級、metadata 與 app 實際行為一致。

## 延後至加入 Apple Developer Program 後

- 正式 Bundle ID、Team、certificate、provisioning profile 與 Archive upload。
- TestFlight、App Review Notes、提交 App Review。
