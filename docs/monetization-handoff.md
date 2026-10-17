# 變現接入交接

**設計定稿見 `docs/plans/2026-09-10-freemium-monetization-design.md`。本文只記接入步驟。**

目前已接入 StoreKit 購買服務與本機測試商品；尚未接入廣告 SDK，因此沒有 banner。
商品 ID 固定為 `com.benwu.mathspring.full_unlock`，程式在商品不可用時會停用購買按鈕，
不會以本地旗標假裝已付款。

## 商品定義

**一個 Non-Consumable IAP，NT$60（US$1.99），非訂閱。** 解鎖三件事：

1. 全部詳解（5,816 題的 `solutionSteps`）
2. 紙娃娃全套樣式
3. 學習者角色上限 1 → 5

免費層可作答全部題目、顯示對錯與正確答案，作答不限題數；另外**每天可自選 3 題看完整詳解**
（2026-10-17 加入，`lib/services/free_solution_allowance.dart`，以裝置本機日期換日，同一題當天重看不再扣次數）。
讓學生付費前就看得到詳解品質。

app 目前沒有廣告，因此付費說明不寫「無廣告／移除廣告」——把本來就沒有的東西當成購買好處，審核可能視為誤導（2026-10-17 從 app 文案移除）。
若日後真的加入廣告，再把「移除廣告」加回購買好處。

## 廣告

- 只放**底部常駐 banner**，不用插頁、獎勵式廣告或答題中斷
- **正式測驗作答中不顯示 banner**
- 已購買者完全隱藏 banner

## 上架前尚待完成

1. 如要加入廣告，再建立 AdMob 帳號、app 與 banner ad unit；開發期只用 Google 測試廣告 ID。
   注意撥款門檻 US$100 掛在帳號層級（跨 app 合併、逐月結轉），另有 US$20 地址驗證門檻。
2. 建立 App Store Connect 一次性 In-App Purchase，完成 Paid Applications、稅務與銀行資料，
   使用既有正式 product ID：`com.benwu.mathspring.full_unlock`。
3. 如要加入廣告，再新增並實作 AdMob banner adapter；目前沒有 banner 版位或廣告 SDK。
4. 加入 banner 時，版面要為 banner 讓出固定高度——`LayoutSpec` 的各級距與 iPad 專屬版面都要重新確認，
   `fill` 模式的捲動殼尤其要檢查。
5. 真機測試：購買、取消、重開 App 後自動恢復、重新安裝後回復購買，以及免費／已購買的四項權益。
6. **接入廣告 SDK 前必須先更新這三處**，否則敘述會與事實不符：
   - `docs/site/privacy/index.html`——目前寫「不提供廣告或追蹤」
   - `docs/app-store-metadata-zh-Hant.md`——目前寫「沒有廣告、購買」
   - App Store Connect 的 App Privacy 問卷
7. **上架前必須完成詳解品質流程**（`docs/solution-quality-review-process.md`）。
   詳解是唯一的主要付費理由，品質沒過關就不該收錢。

## 本機 StoreKit 測試（不扣款）

1. 用 Xcode 開啟 `ios/Runner.xcworkspace`，不要開 `Runner.xcodeproj`。
2. 選擇 `Runner` scheme；專案已把 Run 的 StoreKit configuration 指向
   `ios/Runner/Products.storekit`。
3. 接上已解鎖並開啟 Developer Mode 的 iPhone，從 Xcode 以 **Debug** 執行。
4. App 的「設定」→「解鎖完整版」可測購買與「回復購買」。這是本機商品，付款 sheet
   不會扣款。
5. 在 Xcode 開啟 `Products.storekit` 後，透過 Editor／Transaction Manager 重設交易，
   依序核對：取消不解鎖、購買後四項權益生效、重開 App 後回復購買、重設後回到免費。

本機設定只適合開發驗證；要測真實產品資料，仍須先在 App Store Connect 建商品、簽署
Paid Applications 協議並建立 Sandbox Apple Account，再使用 development build 或 TestFlight。
