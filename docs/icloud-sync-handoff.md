# iCloud 自動同步交接

目前版本已具備可序列化的學習資料快照與離線合併規則，但**尚未連上 iCloud**。在 Apple Developer 帳號與正式容器建立前，不應宣稱資料會跨裝置同步或在刪除 app 後自動還原。

## 已準備好的資料規則

- 每一次完成的作答 session 與其中答案視為不可變紀錄；兩台離線裝置的不同紀錄都保留。
- 同一學習者、同一題目的可變進度以較新的 `updated_at` 為準。
- 快照可轉成 JSON，CloudKit adapter 只負責傳輸、接收與呼叫合併規則。

## 啟用前必做

1. 註冊 Apple Developer Program，為正式 bundle ID 啟用 iCloud capability。
2. 建立真實 CloudKit container（不要提交猜測的 container identifier），在 Xcode 將 entitlement 綁定到它。
3. 以 Swift/Flutter platform channel 實作私有資料庫 adapter：首次上傳、每次完成作答後背景同步、啟動時下載與合併。
4. 顯示可理解的同步狀態與失敗重試；離線時只保留本機操作，網路恢復再同步。
5. 用兩台同 Apple ID、先離線後同時上線的實機驗證，確認不同作答皆保留、同題進度採最新更新。
6. 只有實機驗證完成後，再更新 App Store metadata、隱私政策與設定頁文字為「iCloud 自動同步」。
