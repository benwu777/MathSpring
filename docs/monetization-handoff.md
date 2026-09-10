# 變現接入交接

**設計定稿見 `docs/plans/2026-09-10-freemium-monetization-design.md`。本文只記接入步驟。**

目前版本**沒有接入廣告 SDK 或 StoreKit 購買**。`lib/services/monetization_service.dart`
的 `NoopMonetizationService` 讓 `hasAdFreeEntitlement` 與 `shouldShowBanner` 都回傳 `false`，
所以不顯示任何 banner，也沒有假的「購買／回復購買」按鈕，不會誤導使用者或產生未揭露的資料蒐集。

## 商品定義

**一個 Non-Consumable IAP，NT$60（US$1.99），非訂閱。** 解鎖四件事：

1. 完整詳解（3,141 題的 `solutionSteps`）
2. 移除廣告
3. 紙娃娃全套樣式
4. 學習者角色上限 1 → 5

免費層可作答全部題目、顯示對錯與正確答案，**沒有任何每日額度**。

## 廣告

- 只放**底部常駐 banner**，不用插頁、獎勵式廣告或答題中斷
- **正式測驗作答中不顯示 banner**
- 已購買者完全隱藏 banner

## 接入前必做

1. 建立 AdMob 帳號、app 與 banner ad unit；開發期只用 Google 測試廣告 ID。
   注意撥款門檻 US$100 掛在帳號層級（跨 app 合併、逐月結轉），另有 US$20 地址驗證門檻。
2. 建立 App Store Connect 一次性 In-App Purchase，完成 Paid Applications、稅務與銀行資料，
   取得正式 product ID。
3. 新增並實作 AdMob banner adapter 與 StoreKit 2 entitlement adapter；
   產品 ID 必須從設定載入，不能硬編。
4. 版面要為 banner 讓出固定高度——`LayoutSpec` 的各級距與 iPad 專屬版面都要重新確認，
   `fill` 模式的捲動殼尤其要檢查。
5. 真機測試：購買、取消、重新安裝後回復購買、未購買與已購買的 banner 高度與安全區、
   正式測驗中 banner 確實隱藏。
6. **接入廣告 SDK 前必須先更新這三處**，否則敘述會與事實不符：
   - `docs/site/privacy/index.html`——目前寫「不提供廣告或追蹤」
   - `docs/app-store-metadata-zh-Hant.md`——目前寫「沒有廣告、購買」
   - App Store Connect 的 App Privacy 問卷
7. **上架前必須完成詳解品質流程**（`docs/solution-quality-review-process.md`）。
   詳解是唯一的主要付費理由，品質沒過關就不該收錢。
