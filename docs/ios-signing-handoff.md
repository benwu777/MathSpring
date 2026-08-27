# iOS 簽署與上架交接

本專案目前不需要 Apple Developer 帳號即可開發與執行 Simulator。正式上架前，請依序完成以下設定。

## 現在保留的安全預設

- `PRODUCT_BUNDLE_IDENTIFIER` 仍是 `com.example.mathspring` placeholder；不得直接上架。
- App 顯示名稱來自 Xcode 的 `PRODUCT_NAME`，目前為 `MathSpring`。
- `CFBundleShortVersionString` 與 `CFBundleVersion` 分別來自 Flutter 的 `--build-name`、`--build-number`（預設由 `pubspec.yaml` 的 `version` 提供）。
- 專案未綁定任何 Apple Team，避免把不屬於發布者的簽署資訊帶入 release。

## 加入 Apple Developer Program 後

1. 在 Apple Developer portal 註冊唯一的正式 Bundle ID，例如 `你的網域.mathspring`；先確認它在帳號內可用。
2. 開啟 `ios/Runner.xcworkspace`，選取 Runner target → **Signing & Capabilities**。
3. 選擇自己的 Team，勾選 **Automatically manage signing**，並填入剛建立的 Bundle ID。
4. 確認 Xcode 不再顯示 provisioning 或 capability 錯誤；若日後加入 Push、Sign in with Apple 等 capability，必須一併回 Developer portal 啟用。
5. 將 `pubspec.yaml` 的版本提升，例如從 `1.0.0+1` 到 `1.0.0+2`；同一個 build number 不可重複上傳。
6. 先以 TestFlight internal testing 驗證，再建立 Archive 並上傳 App Store Connect。

## 發布前命令

```bash
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

有帳號與正確 signing 後，可在 Xcode Archive，或依發布流程建立 IPA。每次上傳前再次確認 Bundle ID、版本與 build number 均為預期值。

## 不可忘記的對外設定

- 在 `lib/main.dart` 把 `YOUR_GITHUB_USERNAME` 換成實際 GitHub 帳號，並部署 `docs/site`。
- 將 `support@example.com` 換成真的可收信地址。
- 在 App Store Connect 填入公開支援網址與隱私政策網址，再完成 App Privacy、年齡分級與 Review Notes。
