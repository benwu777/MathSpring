# 廣告與移除廣告一次買斷交接

目前版本**沒有接入廣告 SDK 或 StoreKit 購買**。`MonetizationService` 預設不顯示任何 banner，也沒有假的「購買／恢復購買」按鈕，因此不會誤導使用者或產生未揭露的資料蒐集。

## 預定體驗

- 未購買者：僅在不遮擋題目、答案與底部導覽的安全區放一則固定 banner；不用插頁、獎勵式廣告或答題中斷。
- 已購買者：完全隱藏 banner。
- 商品：非消耗型的一次買斷「移除廣告」，必須提供 Restore Purchases。

## 接入前必做

1. 建立 AdMob 帳號、app 與 banner ad unit；開發期只用 Google 測試廣告 ID。
2. 建立 App Store Connect 一次性 In-App Purchase，完成 Paid Applications、稅務與銀行資料，取得正式 product ID。
3. 新增並實作 AdMob banner adapter 與 StoreKit 2 entitlement adapter；產品 ID 必須從設定載入，不能硬編造。
4. 在真機測試購買、取消、重新安裝後 Restore Purchases、未購買與已購買的 banner 高度與安全區。
5. 因接入廣告 SDK 可能蒐集/連結裝置資料，依 SDK 實際設定更新 App Privacy、隱私政策與 App Review Notes；未完成前不得送審。
